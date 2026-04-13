import Foundation
import simd
import XCTest
@testable import TrueDepthStreamer

enum TestFixtures {
    static func makeMesh() -> FaceMesh {
        FaceMesh(
            vertices: [
                SIMD3<Float>(0.0, 0.0, 0.0),
                SIMD3<Float>(0.01, 0.0, 0.0),
                SIMD3<Float>(0.08, 0.0, 0.0),
                SIMD3<Float>(0.0, 0.02, 0.0)
            ],
            indices: [0, 1, 3, 1, 2, 3],
            normals: [
                SIMD3<Float>(0, 0, 1),
                SIMD3<Float>(0, 0, 1),
                SIMD3<Float>(0, 0, 1),
                SIMD3<Float>(0, 0, 1)
            ]
        )
    }

    static func makeContext(noseProjection: Float) -> DeformationContext {
        DeformationContext(
            state: SimulationState(noseProjection: noseProjection),
            landmarks: FaceLandmarks(
                noseTip: SIMD3<Float>(0, 0, 0),
                chin: SIMD3<Float>(0, -0.05, 0),
                jawline: []
            ),
            blendShapes: [:],
            timestamp: 0
        )
    }

    static func assertEqual(
        _ left: [SIMD3<Float>],
        _ right: [SIMD3<Float>],
        accuracy: Float = 0.0001,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(left.count, right.count, file: file, line: line)

        for (lhs, rhs) in zip(left, right) {
            XCTAssertEqual(lhs.x, rhs.x, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(lhs.y, rhs.y, accuracy: accuracy, file: file, line: line)
            XCTAssertEqual(lhs.z, rhs.z, accuracy: accuracy, file: file, line: line)
        }
    }
}
