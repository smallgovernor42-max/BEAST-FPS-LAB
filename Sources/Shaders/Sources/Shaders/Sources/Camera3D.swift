import simd

struct Camera3D {
    var position = SIMD3<Float>(0, 2, 6)

    // Slight downward viewing angle
    var rotationX: Float = 0.18
    var rotationY: Float = 0

    var fieldOfView: Float = 65
    var nearPlane: Float = 0.1
    var farPlane: Float = 100
    var aspectRatio: Float = 1

    var viewMatrix: simd_float4x4 {
        let rotation = simd_float4x4(
            rotationY: rotationY,
            rotationX: rotationX
        )

        let translation = simd_float4x4(
            translation: -position
        )

        return rotation * translation
    }

    var projectionMatrix: simd_float4x4 {
        let radians = fieldOfView * .pi / 180

        return simd_float4x4(
            perspectiveFov: radians,
            aspectRatio: aspectRatio,
            near: nearPlane,
            far: farPlane
        )
    }

    var viewProjectionMatrix: simd_float4x4 {
        projectionMatrix * viewMatrix
    }
}

extension simd_float4x4 {

    init(translation: SIMD3<Float>) {
        self = matrix_identity_float4x4

        columns.3 = SIMD4<Float>(
            translation.x,
            translation.y,
            translation.z,
            1
        )
    }

    init(rotationY: Float, rotationX: Float) {
        let y = simd_float4x4(
            angle: rotationY,
            axis: SIMD3<Float>(0, 1, 0)
        )

        let x = simd_float4x4(
            angle: rotationX,
            axis: SIMD3<Float>(1, 0, 0)
        )

        self = y * x
    }

    init(angle: Float, axis: SIMD3<Float>) {
        self = matrix_identity_float4x4

        let normalized = simd_normalize(axis)

        let c = cos(angle)
        let s = sin(angle)
        let t = 1 - c

        let x = normalized.x
        let y = normalized.y
        let z = normalized.z

        columns.0 = SIMD4<Float>(
            t*x*x+c,
            t*x*y+s*z,
            t*x*z-s*y,
            0
        )

        columns.1 = SIMD4<Float>(
            t*x*y-s*z,
            t*y*y+c,
            t*y*z+s*x,
            0
        )

        columns.2 = SIMD4<Float>(
            t*x*z+s*y,
            t*y*z-s*x,
            t*z*z+c,
            0
        )

        columns.3 = SIMD4<Float>(0, 0, 0, 1)
    }

    init(
        perspectiveFov fov: Float,
        aspectRatio: Float,
        near: Float,
        far: Float
    ) {
        let yScale = 1 / tan(fov / 2)
        let xScale = yScale / aspectRatio

        self = matrix_identity_float4x4

        columns.0.x = xScale
        columns.1.y = yScale
        columns.2.z = far / (near - far)
        columns.2.w = -1
        columns.3.z = (near * far) / (near - far)
        columns.3.w = 0
    }
}
