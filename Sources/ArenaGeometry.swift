import Foundation
import simd

struct ArenaVertex {
    var position: SIMD3<Float>
    var color: SIMD3<Float>
}

struct ArenaGeometry {

    static func createFloor() -> [ArenaVertex] {

        let green = SIMD3<Float>(0.05, 0.35, 0.12)

        let a = SIMD3<Float>(-10, 0, -10)
        let b = SIMD3<Float>( 10, 0, -10)
        let c = SIMD3<Float>( 10, 0,  10)
        let d = SIMD3<Float>(-10, 0,  10)

        return [
            ArenaVertex(position: a, color: green),
            ArenaVertex(position: b, color: green),
            ArenaVertex(position: c, color: green),

            ArenaVertex(position: a, color: green),
            ArenaVertex(position: c, color: green),
            ArenaVertex(position: d, color: green)
        ]
    }

    static func createTarget(
        position: SIMD3<Float>,
        size: Float = 0.7
    ) -> [ArenaVertex] {

        let green = SIMD3<Float>(0, 1, 0.2)

        let left = SIMD3<Float>(
            position.x - size,
            position.y - size,
            position.z
        )

        let right = SIMD3<Float>(
            position.x + size,
            position.y - size,
            position.z
        )

        let top = SIMD3<Float>(
            position.x,
            position.y + size,
            position.z
        )

        return [
            ArenaVertex(position: left, color: green),
            ArenaVertex(position: right, color: green),
            ArenaVertex(position: top, color: green)
        ]
    }
}
