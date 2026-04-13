import ARKit
import Foundation
import simd

struct ARKitFaceMeshAdapter {
    func makeFrame(from anchor: ARFaceAnchor, timestamp: TimeInterval) -> FaceFrame {
        let geometry = anchor.geometry
        let vertices = geometry.vertices.map { vertex in
            return SIMD3<Float>(vertex.x, vertex.y, vertex.z)
        }
        let indices = geometry.triangleIndices.map(Int.init)

        let mesh = FaceMesh(vertices: vertices, indices: indices)
        let landmarks = estimateLandmarks(from: vertices)
        let blendShapes = anchor.blendShapes.reduce(into: [String: Float]()) { result, pair in
            result[pair.key.rawValue] = pair.value.floatValue
        }

        return FaceFrame(
            mesh: mesh,
            landmarks: landmarks,
            blendShapes: blendShapes,
            transform: anchor.transform,
            timestamp: timestamp
        )
    }

    private func estimateLandmarks(from vertices: [SIMD3<Float>]) -> FaceLandmarks {
        guard !vertices.isEmpty else {
            return FaceLandmarks(noseTip: nil, chin: nil, jawline: [])
        }

        let noseTip = vertices.max(by: { $0.z < $1.z })
        let chin = vertices.min(by: { $0.y < $1.y })

        let minY = vertices.map(\.y).min() ?? 0
        let maxY = vertices.map(\.y).max() ?? 0
        let jawThreshold = minY + ((maxY - minY) * 0.18)
        let jawline = vertices
            .filter { $0.y <= jawThreshold }
            .sorted(by: { $0.x < $1.x })

        return FaceLandmarks(noseTip: noseTip, chin: chin, jawline: jawline)
    }
}
