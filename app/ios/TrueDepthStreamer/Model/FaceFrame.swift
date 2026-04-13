import Foundation
import simd

struct FaceFrame {
    var mesh: FaceMesh
    var landmarks: FaceLandmarks
    var blendShapes: [String: Float]
    var transform: simd_float4x4
    var timestamp: TimeInterval
}
