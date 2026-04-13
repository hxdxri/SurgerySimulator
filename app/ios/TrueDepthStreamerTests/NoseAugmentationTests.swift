import XCTest
@testable import TrueDepthStreamer

final class NoseAugmentationTests: XCTestCase {
    func testNeutralStateLeavesMeshUnchanged() {
        var mesh = TestFixtures.makeMesh()
        let originalVertices = mesh.vertices
        let deformation = NoseAugmentation()

        deformation.apply(to: &mesh, context: TestFixtures.makeContext(noseProjection: 0))

        TestFixtures.assertEqual(mesh.vertices, originalVertices)
    }

    func testProjectionAffectsOnlyVerticesInsideRadius() {
        var mesh = TestFixtures.makeMesh()
        let deformation = NoseAugmentation()
        deformation.radius = 0.03
        deformation.maxDisplacement = 0.01

        deformation.apply(to: &mesh, context: TestFixtures.makeContext(noseProjection: 1))

        XCTAssertGreaterThan(mesh.vertices[0].z, 0)
        XCTAssertGreaterThan(mesh.vertices[1].z, 0)
        XCTAssertEqual(mesh.vertices[2].z, 0, accuracy: 0.0001)
    }
}
