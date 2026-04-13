import Foundation

struct DeformationContext {
    let state: SimulationState
    let landmarks: FaceLandmarks
    let blendShapes: [String: Float]
    let timestamp: TimeInterval
}
