import Metal
import MetalKit

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState

    init?(device: MTLDevice) {

        guard let queue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(
                name: "vertex_main"
              ),
              let fragmentFunction = library.makeFunction(
                name: "fragment_main"
              ) else {
            return nil
        }

        let descriptor = MTLRenderPipelineDescriptor()

        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction

        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        guard let pipeline = try? device.makeRenderPipelineState(
            descriptor: descriptor
        ) else {
            return nil
        }

        commandQueue = queue
        pipelineState = pipeline

        super.init()
    }

    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {}

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

        encoder.setRenderPipelineState(pipelineState)

        encoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: 3
        )

        encoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
