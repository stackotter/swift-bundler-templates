import Foundation
import MetalKit
import SwiftUI

@available(macOS 13, *)
@available(iOS 16, *)
struct MetalView<T: Renderer> {
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

	func makeMTKView(context: Context) -> MTKView {
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
}

@available(macOS, deprecated: 13, renamed: "MetalView")
@available(iOS, deprecated: 16, renamed: "MetalView")
final class MetalViewClass<T: Renderer> {
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

	func makeMTKView(context: Context) -> MTKView {
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
}

#if os(macOS)
	@available(macOS 13, *)
	extension MetalView: NSViewRepresentable {
		func makeNSView(context: Context) -> some NSView {
			return makeMTKView(context: context)
		}
	
		func updateNSView(_ view: NSViewType, context: Context) {}
	}

	extension MetalViewClass: NSViewRepresentable {
		func makeNSView(context: Context) -> some NSView {
			return makeMTKView(context: context)
		}
	
		func updateNSView(_ view: NSViewType, context: Context) {}
	}
#elseif os(iOS)
	@available(iOS 16, *)
	extension MetalView: UIViewRepresentable {
		func makeUIView(context: Context) -> some UIView {
			return makeMTKView(context: context)
		}
	
		func updateUIView(_ view: UIViewType, context: Context) {}
	}

	extension MetalViewClass: UIViewRepresentable {
		func makeUIView(context: Context) -> some UIView {
			return makeMTKView(context: context)
		}
	
		func updateUIView(_ view: UIViewType, context: Context) {}
	}
#endif

@available(macOS 13, iOS 16, *)
extension MetalView where T.Context == Void {
	init(rendererType: T.Type, errorHandler: @escaping (String) -> Void) {
		self.init(rendererType: rendererType, rendererContext: Void(), errorHandler: errorHandler)
	}
}

extension MetalViewClass where T.Context == Void {
	convenience init(rendererType: T.Type, errorHandler: @escaping (String) -> Void) {
		self.init(rendererType: rendererType, rendererContext: Void(), errorHandler: errorHandler)
	}
}
