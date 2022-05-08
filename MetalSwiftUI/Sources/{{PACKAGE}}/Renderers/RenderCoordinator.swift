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
	var context: Context
	var device: MTLDevice
	var commandQueue: MTLCommandQueue
	var renderer: R

	struct Context {
		var errorHandler: (String) -> Void
		var rendererType: R.Type
	}

	required init(_ context: Context) throws {
		// Get Metal device
		guard let device = MTLCreateSystemDefaultDevice() else {
			throw RenderCoordinatorError.failedToGetMetalDevice
		}
		
		// Create a command queue (and reuse it as much as possible)
		guard let commandQueue = device.makeCommandQueue() else {
			throw RenderCoordinatorError.failedToCreateRenderCommandQueue
		}
		
		self.context = context
		self.device = device
		self.commandQueue = commandQueue

		renderer = try context.rendererType.init(device: device, commandQueue: commandQueue)

		super.init()
	}
	
	func draw(in view: MTKView) {
		// Get render pass descriptor
		guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
			context.errorHandler("Failed to get the current render pass descriptor")
			return
		}
		
		// Create command buffer
		guard let commandBuffer = commandQueue.makeCommandBuffer() else {
			context.errorHandler("Failed to create command buffer")
			return
		}
		
		// Create render encoder
		guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
			context.errorHandler("Failed to create render encoder")
			return
		}
		
		// Run the renderer
		do {
			try renderer.encodeFrame(into: renderEncoder)
		} catch {
			context.errorHandler("Failed to encode frame: \(error)")
			return
		}
		
		// Get the current drawable
		guard let drawable = view.currentDrawable else {
			context.errorHandler("Failed to get current drawable")
			return
		}
		
		// Finish encoding the frame
		renderEncoder.endEncoding()
		commandBuffer.present(drawable)
		commandBuffer.commit()
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
