import XCTest
import UIKit
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
