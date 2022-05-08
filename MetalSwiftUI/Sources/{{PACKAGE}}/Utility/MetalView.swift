import Foundation
import MetalKit
import SwiftUI

final class MetalView<T: Renderer>: NSViewRepresentable {
  var renderCoordinator: RenderCoordinator<T>?
  
  init(rendererType: T.Type, errorHandler: @escaping (String) -> Void) {
    do {
      self.renderCoordinator = try RenderCoordinator(.init(
        errorHandler: { errorHandler($0) },
        rendererType: rendererType
      ))
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
