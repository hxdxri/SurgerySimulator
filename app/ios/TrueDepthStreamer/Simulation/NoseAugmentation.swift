import Foundation
import simd

final class NoseAugmentation: Deformation {
    let identifier = "nose-augmentation"

    var radius: Float = 0.035
    var maxDisplacement: Float = 0.008

    func apply(to mesh: inout FaceMesh, context: DeformationContext) {
        let intensity = context.state.noseProjection
        guard intensity > 0.001 else {
            return
        }

        let noseTip = context.landmarks.noseTip ?? mesh.vertices.max(by: { $0.z < $1.z })
        guard let center = noseTip else {
            return
        }

        if mesh.normals.count != mesh.vertices.count {
            mesh.recalculateNormals()
        }

        for index in mesh.vertices.indices {
            let vertex = mesh.vertices[index]
            let distance = simd_distance(vertex, center)

            guard distance <= radius else {
                continue
            }

            let normalizedDistance = distance / radius
            let falloff = 1 - (normalizedDistance * normalizedDistance)
            let normal = mesh.normals[index]
            mesh.vertices[index] += normal * (maxDisplacement * intensity * falloff)
        }
    }
}
