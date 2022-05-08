import Foundation
import MetalKit

enum RenderCoordinatorError: LocalizedError {
	case failedToGetMetalDevice
	case failedToCreateRenderCommandQueue

	var errorDescription: String? {
		switch self {
		case .failedToGetMetalDevice:
			return "Failed to get Metal device"
		case .failedToCreateRenderCommandQueue:
			return "Failed to create render command queue"
		}
	}
}

final class RenderCoordinator<R: Renderer>: NSObject, MTKViewDelegate {
	var device: MTLDevice
	var commandQueue: MTLCommandQueue
	var renderer: R
	var errorHandler: (String) -> Void

	required init(
		rendererType: R.Type,
		rendererContext: R.Context,
		errorHandler: @escaping (String) -> Void
	) throws {
		// Get Metal device
		guard let device = MTLCreateSystemDefaultDevice() else {
			throw RenderCoordinatorError.failedToGetMetalDevice
		}
		
		// Create a command queue (and reuse it as much as possible)
		guard let commandQueue = device.makeCommandQueue() else {
			throw RenderCoordinatorError.failedToCreateRenderCommandQueue
		}
		
		self.device = device
		self.commandQueue = commandQueue
		self.errorHandler = errorHandler

		renderer = try rendererType.init(context: rendererContext, device: device, commandQueue: commandQueue)

		super.init()
	}
	
	func draw(in view: MTKView) {
		// Get render pass descriptor
		guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
			errorHandler("Failed to get the current render pass descriptor")
			return
		}
		
		// Create command buffer
		guard let commandBuffer = commandQueue.makeCommandBuffer() else {
			errorHandler("Failed to create command buffer")
			return
		}
		
		// Create render encoder
		guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
			errorHandler("Failed to create render encoder")
			return
		}
		
		// Run the renderer
		do {
			try renderer.encodeFrame(into: renderEncoder)
		} catch {
			errorHandler("Failed to encode frame: \(error)")
			return
		}
		
		// Get the current drawable
		guard let drawable = view.currentDrawable else {
			errorHandler("Failed to get current drawable")
			return
		}
		
		// Finish encoding the frame
		renderEncoder.endEncoding()
		commandBuffer.present(drawable)
		commandBuffer.commit()
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
