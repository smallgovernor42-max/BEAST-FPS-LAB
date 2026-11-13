import Metal
import MetalKit
import simd

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let vertexBuffer: MTLBuffer

    private var camera = Camera3D()

    private let vertexCount: Int

    init?(
        device: MTLDevice,
        pixelFormat: MTLPixelFormat
    ) {

        guard
            let queue = device.makeCommandQueue(),
            let library = device.makeDefaultLibrary(),
            let vertexFunction = library.makeFunction(
                name: "arena_vertex_main"
            ),
            let fragmentFunction = library.makeFunction(
                name: "arena_fragment_main"
            )
        else {
            print("Metal initialization failed")
            return nil
        }

        let vertices =
            ArenaGeometry.createFloor() +
            ArenaGeometry.createTarget(
                position: SIMD3<Float>(0, 2, -5)
            )

        vertexCount = vertices.count

        guard let buffer = device.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<ArenaVertex>.stride * vertices.count,
            options: .storageModeShared
        ) else {
            return nil
        }

        vertexBuffer = buffer

        let descriptor = MTLRenderPipelineDescriptor()

        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction

        descriptor.colorAttachments[0].pixelFormat = pixelFormat

        do {
            pipelineState = try device.makeRenderPipelineState(
                descriptor: descriptor
            )
        } catch {
            print("Pipeline error: \(error)")
            return nil
        }

        commandQueue = queue

        super.init()
    }

    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {

        guard size.height > 0 else { return }

        camera.aspectRatio = Float(
            size.width / size.height
        )
    }

    func draw(in view: MTKView) {

        guard
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor,
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let encoder = commandBuffer.makeRenderCommandEncoder(
                descriptor: descriptor
            )
        else {
            return
        }

        var uniforms = ArenaUniforms(
            mvp: camera.viewProjectionMatrix
        )

        encoder.setRenderPipelineState(pipelineState)

        encoder.setVertexBuffer(
            vertexBuffer,
            offset: 0,
            index: 0
        )

        encoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<ArenaUniforms>.stride,
            index: 1
        )

        encoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: vertexCount
        )

        encoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

struct ArenaUniforms {
    var mvp: simd_float4x4
}
