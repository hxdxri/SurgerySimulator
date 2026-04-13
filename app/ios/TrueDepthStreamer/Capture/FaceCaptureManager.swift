import ARKit
import Foundation

final class FaceCaptureManager: NSObject, FaceCaptureManaging {
    weak var delegate: FaceCaptureManagerDelegate?
    weak var frameConsumer: FaceFrameConsumer?

    private let session: ARSession
    private let adapter: ARKitFaceMeshAdapter
    private let sessionQueue = DispatchQueue(label: "com.surgerysim.capture.session", qos: .userInitiated)

    init(session: ARSession, adapter: ARKitFaceMeshAdapter = ARKitFaceMeshAdapter()) {
        self.session = session
        self.adapter = adapter
        super.init()
        self.session.delegate = self
    }

    func start() {
        guard ARFaceTrackingConfiguration.isSupported else {
            delegate?.faceCaptureManager(self, didChange: .unsupported)
            return
        }

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            DispatchQueue.main.async {
                self.delegate?.faceCaptureManager(self, didChange: .running)
            }
        }
    }

    func pause() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.pause()
            DispatchQueue.main.async {
                self.delegate?.faceCaptureManager(self, didChange: .paused)
            }
        }
    }
}

extension FaceCaptureManager: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first(where: { $0 is ARFaceAnchor }) as? ARFaceAnchor else {
            return
        }

        let timestamp = session.currentFrame?.timestamp ?? Date().timeIntervalSince1970
        let frame = adapter.makeFrame(from: faceAnchor, timestamp: timestamp)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.frameConsumer?.consume(frame)
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.faceCaptureManager(self, didFailWith: error)
            self.delegate?.faceCaptureManager(self, didChange: .failed(error.localizedDescription))
        }
    }

    func sessionWasInterrupted(_ session: ARSession) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.faceCaptureManager(self, didChange: .interrupted)
        }
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.faceCaptureManager(self, didChange: .interruptedEnded)
        }
    }
}
