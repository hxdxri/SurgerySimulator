import Foundation

protocol Deformation {
    var identifier: String { get }
    func apply(to mesh: inout FaceMesh, context: DeformationContext)
}
