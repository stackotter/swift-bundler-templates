import Foundation
import MetalKit
import SwiftUI

struct MetalView<T: Renderer>: NSViewRepresentable {
	var renderCoordinator: RenderCoordinator<T>?
	
	init(rendererType: T.Type, rendererContext: T.Context, errorHandler: @escaping (String) -> Void) {
		do {
			self.renderCoordinator = try RenderCoordinator(
				rendererType: rendererType,
				rendererContext: rendererContext,
				errorHandler: { errorHandler($0) }
			)
		} catch {
			errorHandler("Failed to initialize RenderCoordinator: \(error)")
		}
	}
	
	func makeCoordinator() -> RenderCoordinator<T>? {
		return renderCoordinator
	}
	
	func makeNSView(context: Context) -> some NSView {
		let mtkView = MTKView()
		
		if let metalDevice = MTLCreateSystemDefaultDevice() {
			mtkView.device = metalDevice
		}

		mtkView.delegate = context.coordinator
		mtkView.framebufferOnly = true
		mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1)
		mtkView.drawableSize = mtkView.frame.size

		return mtkView
	}
	
	func updateNSView(_ view: NSViewType, context: Context) {}
}

extension MetalView where T.Context == Void {
	init(rendererType: T.Type, errorHandler: @escaping (String) -> Void) {
		self.init(rendererType: rendererType, rendererContext: Void(), errorHandler: errorHandler)
	}
}