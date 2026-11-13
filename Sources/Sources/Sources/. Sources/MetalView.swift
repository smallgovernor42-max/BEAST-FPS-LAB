import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MTKView {

        guard let device = MTLCreateSystemDefaultDevice() else {
            return MTKView(frame: .zero)
        }

        let view = MTKView(
            frame: .zero,
            device: device
        )

        view.clearColor = MTLClearColor(
            red: 0.015,
            green: 0.025,
            blue: 0.02,
            alpha: 1
        )

        view.colorPixelFormat = .bgra8Unorm
        view.preferredFramesPerSecond = 60

        let renderer = MetalRenderer(
            device: device,
            pixelFormat: view.colorPixelFormat
        )

        context.coordinator.renderer = renderer
        view.delegate = renderer

        return view
    }

    func updateUIView(
        _ uiView: MTKView,
        context: Context
    ) {}

    class Coordinator {
        var renderer: MetalRenderer?
    }
}
