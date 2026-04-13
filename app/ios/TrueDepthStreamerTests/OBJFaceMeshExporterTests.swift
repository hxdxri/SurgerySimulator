import XCTest
@testable import TrueDepthStreamer

final class OBJFaceMeshExporterTests: XCTestCase {
    func testExportWritesOBJVerticesNormalsAndFaces() throws {
        let outputDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let exporter = OBJFaceMeshExporter(outputDirectory: outputDirectory)

        let fileURL = try exporter.export(mesh: TestFixtures.makeMesh())
        let content = try String(contentsOf: fileURL)

        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        XCTAssertTrue(content.contains("# SurgerySimulator face mesh export"))
        XCTAssertTrue(content.contains("v 0.0 0.0 0.0"))
        XCTAssertTrue(content.contains("vn 0.0 0.0 1.0"))
        XCTAssertTrue(content.contains("f 1//1 2//2 4//4"))
    }
}
