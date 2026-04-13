import Foundation

struct SimulationState: Equatable {
    var noseProjection: Float = 0

    var isNeutral: Bool {
        noseProjection == 0
    }
}
