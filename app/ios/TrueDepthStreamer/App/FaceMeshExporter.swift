// FaceMeshExporter.swift
//
// Exports repository-owned FaceMesh to .obj. Provides a deprecated ARKit convenience for legacy callers.
// Architectural note: ARKit types should be converted at the capture edge. Prefer using FaceMesh APIs.

import ARKit
import Foundation

/// Handles exporting FaceMesh and ARFaceGeometry as standard 3D assets (OBJ).
struct FaceMeshExporter {
    /// Exports the given FaceMesh as an OBJ formatted Data.
    /// - Parameter mesh: The FaceMesh to export.
    /// - Returns: OBJ file contents as Data, or nil on failure.
    static func exportOBJ(from mesh: FaceMesh) -> Data? {
        var lines: [String] = ["# Exported by FaceMeshExporter"]

        // Vertices
        lines.append(contentsOf: mesh.vertices.map { v in
            "v \(v.x) \(v.y) \(v.z)"
        })

        // Optionally normals (if present and aligned)
        if mesh.normals.count == mesh.vertices.count {
            lines.append(contentsOf: mesh.normals.map { n in
                "vn \(n.x) \(n.y) \(n.z)"
            })
        }

        // Faces (triangles, 1-based indexing)
        for i in stride(from: 0, to: mesh.indices.count, by: 3) {
            guard i + 2 < mesh.indices.count else { break }
            let i0 = mesh.indices[i] + 1
            let i1 = mesh.indices[i + 1] + 1
            let i2 = mesh.indices[i + 2] + 1
            if mesh.normals.count == mesh.vertices.count {
                lines.append("f \(i0)//\(i0) \(i1)//\(i1) \(i2)//\(i2)")
            } else {
                lines.append("f \(i0) \(i1) \(i2)")
            }
        }

        return lines.joined(separator: "\n").data(using: .utf8)
    }

    /// Exports the given FaceMesh as an OBJ file into the app's Documents directory.
    /// - Parameter mesh: The FaceMesh to export.
    /// - Returns: URL to the saved file, or nil on failure.
    static func exportFaceMeshToDocuments(_ mesh: FaceMesh) -> URL? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let exporter = OBJFaceMeshExporter(outputDirectory: documents)
        do {
            return try exporter.export(mesh: mesh)
        } catch {
            print("Failed to export OBJ: \(error)")
            return nil
        }
    }

    /// Saves OBJ data to the app documents directory with a unique filename.
    /// - Parameter data: The OBJ file contents.
    /// - Returns: URL to saved file, or nil on failure.
    static func saveOBJToDocuments(_ data: Data) -> URL? {
        let filename = "FaceCapture_\(UUID().uuidString.prefix(8)).obj"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return url
        } catch {
            print("Failed to save OBJ: \(error)")
            return nil
        }
    }

    /// Exports the given ARFaceGeometry as an OBJ formatted string.
    /// - Parameter geometry: The ARFaceGeometry to export.
    /// - Returns: OBJ file contents as Data, or nil on failure.
    @available(*, deprecated, message: "Convert ARFaceGeometry to FaceMesh at the capture edge and use exportOBJ(from: FaceMesh) or OBJFaceMeshExporter")
    static func exportOBJ(from geometry: ARFaceGeometry) -> Data? {
        let vertices: [SIMD3<Float>] = (0..<geometry.vertices.count).map { idx in
            let v = geometry.vertices[idx]
            return SIMD3<Float>(v.x, v.y, v.z)
        }
        let indices: [Int] = geometry.triangleIndices.map(Int.init)
        let mesh = FaceMesh(vertices: vertices, indices: indices)
        return exportOBJ(from: mesh)
    }
}
