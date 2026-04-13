import Foundation
import simd

struct FaceLandmarks {
    var noseTip: SIMD3<Float>?
    var chin: SIMD3<Float>?
    var jawline: [SIMD3<Float>]
}
