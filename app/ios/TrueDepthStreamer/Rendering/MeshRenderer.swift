import UIKit

protocol MeshRendering: AnyObject {
    var view: UIView { get }
    func render(mesh: FaceMesh, transform: simd_float4x4)
}
