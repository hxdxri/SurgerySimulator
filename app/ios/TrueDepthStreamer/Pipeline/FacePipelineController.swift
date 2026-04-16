import Foundation

protocol FacePipelineControllerDelegate: AnyObject {
    func facePipelineController(_ controller: FacePipelineController, didChangeStatus message: String)
    func facePipelineController(_ controller: FacePipelineController, didUpdateCaptureStatus status: FaceCaptureStatus)
}

final class FacePipelineController {
    weak var delegate: FacePipelineControllerDelegate?

    private let renderer: MeshRendering
    private let captureManager: FaceCaptureManaging
    private let deformationPipeline: DeformationPipeline
    private var simulationState = SimulationState()
    private(set) var latestSnapshot: FaceMeshSnapshot?

    init(
        renderer: MeshRendering,
        captureManager: FaceCaptureManaging,
        deformationPipeline: DeformationPipeline = DeformationPipeline(deformations: [NoseAugmentation()])
    ) {
        self.renderer = renderer
        self.captureManager = captureManager
        self.deformationPipeline = deformationPipeline
        self.captureManager.delegate = self
        self.captureManager.frameConsumer = self
    }

    func start() {
        delegate?.facePipelineController(self, didChangeStatus: "Starting TrueDepth face capture.")
        captureManager.start()
    }

    func pause() {
        captureManager.pause()
    }

    func updateSimulationState(_ state: SimulationState) {
        simulationState = state
        let percentage = Int((state.noseProjection * 100).rounded())
        delegate?.facePipelineController(self, didChangeStatus: "Nose deformation: \(percentage)%")
    }
}

extension FacePipelineController: FaceFrameConsumer {
    func consume(_ frame: FaceFrame) {
        latestSnapshot = FaceMeshSnapshot(
            mesh: frame.mesh,
            landmarks: frame.landmarks,
            timestamp: frame.timestamp
        )

        let context = DeformationContext(
            state: simulationState,
            landmarks: frame.landmarks,
            blendShapes: frame.blendShapes,
            timestamp: frame.timestamp
        )
        let transformedMesh = deformationPipeline.apply(to: frame.mesh, context: context)
        renderer.render(mesh: transformedMesh, transform: frame.transform)
    }
}

extension FacePipelineController: FaceCaptureManagerDelegate {
    func faceCaptureManager(_ manager: FaceCaptureManaging, didChange status: FaceCaptureStatus) {
        delegate?.facePipelineController(self, didUpdateCaptureStatus: status)
        delegate?.facePipelineController(self, didChangeStatus: status.message)
        if case .interruptedEnded = status {
            captureManager.start()
        }
    }

    func faceCaptureManager(_ manager: FaceCaptureManaging, didFailWith error: Error) {
        delegate?.facePipelineController(self, didChangeStatus: "Capture failed: \(error.localizedDescription)")
    }
}
