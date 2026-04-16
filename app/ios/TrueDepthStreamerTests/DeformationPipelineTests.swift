import XCTest
import UIKit
import simd
@testable import TrueDepthStreamer

final class DeformationPipelineTests: XCTestCase {
    func testApplyingFromSameBaseMeshDoesNotAccumulateDrift() {
        let baseMesh = TestFixtures.makeMesh()
        let context = TestFixtures.makeContext(noseProjection: 0.8)
        let pipeline = DeformationPipeline(deformations: [NoseAugmentation()])

        let firstResult = pipeline.apply(to: baseMesh, context: context)
        let secondResult = pipeline.apply(to: baseMesh, context: context)

        TestFixtures.assertEqual(firstResult.vertices, secondResult.vertices)
        TestFixtures.assertEqual(baseMesh.vertices, TestFixtures.makeMesh().vertices)
    }
}

final class FacePipelineViewControllerTests: XCTestCase {
    func testUnsupportedCaptureStateShowsGuidanceAndDisablesControls() {
        let viewController = FacePipelineViewController()
        viewController.loadViewIfNeeded()

        viewController.applyCaptureStatus(.unsupported)

        let guidanceTitle = findView(
            in: viewController.view,
            identifier: "runtime-guidance-title",
            as: UILabel.self
        )
        let slider = findView(
            in: viewController.view,
            identifier: "nose-projection-slider",
            as: UISlider.self
        )
        let resetButton = findView(
            in: viewController.view,
            identifier: "nose-projection-reset-button",
            as: UIButton.self
        )

        XCTAssertEqual(guidanceTitle?.text, "TrueDepth Hardware Required")
        XCTAssertEqual(slider?.isEnabled, false)
        XCTAssertEqual(resetButton?.isEnabled, false)
    }

    func testFailedCaptureStateShowsRecoveryGuidance() {
        let viewController = FacePipelineViewController()
        viewController.loadViewIfNeeded()

        viewController.applyCaptureStatus(.failed("Camera permission denied."))

        let guidanceTitle = findView(
            in: viewController.view,
            identifier: "runtime-guidance-title",
            as: UILabel.self
        )
        let guidanceMessage = findView(
            in: viewController.view,
            identifier: "runtime-guidance-message",
            as: UILabel.self
        )

        XCTAssertEqual(guidanceTitle?.text, "Capture Session Failed")
        XCTAssertEqual(guidanceMessage?.text, "Camera permission denied.")
    }

    private func findView<T: UIView>(in root: UIView, identifier: String, as _: T.Type) -> T? {
        if root.accessibilityIdentifier == identifier, let view = root as? T {
            return view
        }

        for subview in root.subviews {
            if let view: T = findView(in: subview, identifier: identifier, as: T.self) {
                return view
            }
        }

        return nil
    }
}

final class FacePipelineControllerTests: XCTestCase {
    func testPipelinePreservesCapturedSnapshotSeparatelyFromRenderedMesh() {
        let renderer = MockRenderer()
        let captureManager = MockCaptureManager()
        let controller = FacePipelineController(renderer: renderer, captureManager: captureManager)
        controller.updateSimulationState(SimulationState(noseProjection: 0.8))

        let frame = FaceFrame(
            mesh: TestFixtures.makeMesh(),
            landmarks: FaceLandmarks(
                noseTip: SIMD3<Float>(0, 0, 0),
                chin: SIMD3<Float>(0, -0.05, 0),
                jawline: []
            ),
            blendShapes: [:],
            transform: matrix_identity_float4x4,
            timestamp: 42
        )

        controller.consume(frame)

        guard let snapshot = controller.latestSnapshot else {
            return XCTFail("Expected the controller to retain the latest captured snapshot.")
        }

        TestFixtures.assertEqual(snapshot.mesh.vertices, frame.mesh.vertices)
        XCTAssertEqual(snapshot.timestamp, 42, accuracy: 0.001)
        XCTAssertNotNil(renderer.lastRenderedMesh)
        XCTAssertGreaterThan(renderer.lastRenderedMesh?.vertices[0].z ?? 0, snapshot.mesh.vertices[0].z)
    }

    private final class MockRenderer: MeshRendering {
        let view = UIView()
        private(set) var lastRenderedMesh: FaceMesh?

        func render(mesh: FaceMesh, transform: simd_float4x4) {
            lastRenderedMesh = mesh
        }
    }

    private final class MockCaptureManager: FaceCaptureManaging {
        weak var delegate: FaceCaptureManagerDelegate?
        weak var frameConsumer: FaceFrameConsumer?

        func start() {}

        func pause() {}
    }
}
