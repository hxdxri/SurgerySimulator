import Testing
import ARKit
@testable import YourAppModuleName // Replace with actual module name

@Suite("FaceMeshExporter")
struct FaceMeshExporterTests {
    @Test("Exports minimal geometry as OBJ")
    func testExportOBJ() async throws {
        // Create minimal ARFaceGeometry-like mock
        let vertex: [SIMD3<Float>] = [SIMD3<Float>(0,0,0), SIMD3<Float>(1,0,0), SIMD3<Float>(0,1,0)]
        let indices: [UInt16] = [0, 1, 2]
        // We must mock ARFaceGeometry. If not possible, skip test with #skip.
        #skip("ARFaceGeometry cannot be mocked directly in unit tests.")
        /*
        let geo = FakeFaceGeometry(vertices: vertex, indices: indices)
        let data = FaceMeshExporter.exportOBJ(from: geo)
        #expect(data != nil)
        let objString = String(data: data!, encoding: .utf8)!
        #expect(objString.contains("v 0.00000 0.00000 0.00000"))
        #expect(objString.contains("f 1 2 3"))
        */
    }

    @Test("Saves OBJ to documents directory")
    func testSaveOBJ() async throws {
        let dummy = "v 0 0 0\nf 1 2 3\n".data(using: .utf8)!
        let url = FaceMeshExporter.saveOBJToDocuments(dummy)
        #expect(url != nil)
        let loaded = try Data(contentsOf: url!)
        #expect(loaded == dummy)
    }
}
