import Foundation
import simd

struct FaceMesh {
    var vertices: [SIMD3<Float>]
    var indices: [Int]
    var normals: [SIMD3<Float>]

    init(vertices: [SIMD3<Float>], indices: [Int], normals: [SIMD3<Float>] = []) {
        self.vertices = vertices
        self.indices = indices

        if normals.count == vertices.count {
            self.normals = normals
        } else {
            self.normals = FaceMesh.calculateNormals(vertices: vertices, indices: indices)
        }
    }

    var isEmpty: Bool {
        vertices.isEmpty || indices.isEmpty
    }

    mutating func recalculateNormals() {
        normals = FaceMesh.calculateNormals(vertices: vertices, indices: indices)
    }

    private static func calculateNormals(vertices: [SIMD3<Float>], indices: [Int]) -> [SIMD3<Float>] {
        guard !vertices.isEmpty else {
            return []
        }

        var accumulated = Array(repeating: SIMD3<Float>(repeating: 0), count: vertices.count)

        for triangleStart in stride(from: 0, to: indices.count, by: 3) {
            guard triangleStart + 2 < indices.count else { break }

            let firstIndex = indices[triangleStart]
            let secondIndex = indices[triangleStart + 1]
            let thirdIndex = indices[triangleStart + 2]

            guard firstIndex < vertices.count, secondIndex < vertices.count, thirdIndex < vertices.count else {
                continue
            }

            let firstVertex = vertices[firstIndex]
            let secondVertex = vertices[secondIndex]
            let thirdVertex = vertices[thirdIndex]

            let faceNormal = simd_cross(secondVertex - firstVertex, thirdVertex - firstVertex)

            accumulated[firstIndex] += faceNormal
            accumulated[secondIndex] += faceNormal
            accumulated[thirdIndex] += faceNormal
        }

        return accumulated.map { normal in
            let length = simd_length(normal)
            guard length > 0.0001 else {
                return SIMD3<Float>(0, 0, 1)
            }
            return normal / length
        }
    }
}
