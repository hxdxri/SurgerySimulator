import ARKit
import SceneKit
import UIKit

final class SceneKitFaceMeshRenderer: NSObject, MeshRendering {
    let sceneView: ARSCNView

    private let meshNode = SCNNode()
    private let material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 0.20, green: 0.82, blue: 0.78, alpha: 0.95)
        material.lightingModel = .physicallyBased
        material.isDoubleSided = true
        material.fillMode = .fill
        return material
    }()

    override init() {
        sceneView = ARSCNView(frame: .zero)
        super.init()
        configureScene()
    }

    var view: UIView {
        sceneView
    }

    var session: ARSession {
        sceneView.session
    }

    func render(mesh: FaceMesh, transform: simd_float4x4) {
        guard !mesh.isEmpty else {
            meshNode.geometry = nil
            return
        }

        meshNode.geometry = makeGeometry(from: mesh)
        meshNode.simdTransform = transform
    }

    private func configureScene() {
        sceneView.scene = SCNScene()
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .black
        sceneView.contentMode = .scaleAspectFill
        sceneView.scene.rootNode.addChildNode(meshNode)
    }

    private func makeGeometry(from mesh: FaceMesh) -> SCNGeometry {
        let vertexSource = SCNGeometrySource(
            data: data(from: mesh.vertices),
            semantic: .vertex,
            vectorCount: mesh.vertices.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<SIMD3<Float>>.stride
        )

        let normalSource = SCNGeometrySource(
            data: data(from: mesh.normals),
            semantic: .normal,
            vectorCount: mesh.normals.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<SIMD3<Float>>.stride
        )

        let elementIndices = mesh.indices.map(Int32.init)
        let element = SCNGeometryElement(
            data: data(from: elementIndices),
            primitiveType: .triangles,
            primitiveCount: elementIndices.count / 3,
            bytesPerIndex: MemoryLayout<Int32>.size
        )

        let geometry = SCNGeometry(sources: [vertexSource, normalSource], elements: [element])
        geometry.firstMaterial = material
        return geometry
    }

    private func data<T>(from values: [T]) -> Data {
        values.withUnsafeBufferPointer { buffer in
            guard let baseAddress = buffer.baseAddress else {
                return Data()
            }
            return Data(bytes: baseAddress, count: buffer.count * MemoryLayout<T>.stride)
        }
    }
}
