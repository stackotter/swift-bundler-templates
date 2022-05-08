import MetalKit

protocol Renderer {
	associatedtype Context

	init(context: Context, device: MTLDevice, commandQueue: MTLCommandQueue) throws

	func encodeFrame(into encoder: MTLRenderCommandEncoder) throws
}
