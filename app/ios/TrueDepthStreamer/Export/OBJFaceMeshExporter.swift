import Foundation

final class OBJFaceMeshExporter: FaceMeshExporting {
    private let outputDirectory: URL
    private let fileManager: FileManager

    init(outputDirectory: URL = FileManager.default.temporaryDirectory, fileManager: FileManager = .default) {
        self.outputDirectory = outputDirectory
        self.fileManager = fileManager
    }

    func export(mesh: FaceMesh) throws -> URL {
        try fileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true, attributes: nil)

        let filename = "face-mesh-\(UUID().uuidString).obj"
        let fileURL = outputDirectory.appendingPathComponent(filename)
        let content = makeOBJ(from: mesh)

        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }

    private func makeOBJ(from mesh: FaceMesh) -> String {
        var lines: [String] = ["# SurgerySimulator face mesh export"]

        lines.append(contentsOf: mesh.vertices.map { vertex in
            "v \(vertex.x) \(vertex.y) \(vertex.z)"
        })

        if mesh.normals.count == mesh.vertices.count {
            lines.append(contentsOf: mesh.normals.map { normal in
                "vn \(normal.x) \(normal.y) \(normal.z)"
            })
        }

        for triangleStart in stride(from: 0, to: mesh.indices.count, by: 3) {
            guard triangleStart + 2 < mesh.indices.count else { break }

            let indices = (0..<3).map { offset in mesh.indices[triangleStart + offset] + 1 }
            if mesh.normals.count == mesh.vertices.count {
                lines.append("f \(indices[0])//\(indices[0]) \(indices[1])//\(indices[1]) \(indices[2])//\(indices[2])")
            } else {
                lines.append("f \(indices[0]) \(indices[1]) \(indices[2])")
            }
        }

        return lines.joined(separator: "\n")
    }
}
