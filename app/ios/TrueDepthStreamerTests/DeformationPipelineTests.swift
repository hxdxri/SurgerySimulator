import XCTest
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
