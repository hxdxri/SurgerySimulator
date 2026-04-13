import Foundation

final class DeformationPipeline {
    private let deformations: [Deformation]

    init(deformations: [Deformation]) {
        self.deformations = deformations
    }

    func apply(to baseMesh: FaceMesh, context: DeformationContext) -> FaceMesh {
        var transformedMesh = baseMesh

        for deformation in deformations {
            deformation.apply(to: &transformedMesh, context: context)
        }

        transformedMesh.recalculateNormals()
        return transformedMesh
    }
}
