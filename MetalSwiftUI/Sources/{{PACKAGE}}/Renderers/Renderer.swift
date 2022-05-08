import MetalKit

protocol Renderer {
	init(device: MTLDevice, commandQueue: MTLCommandQueue) throws

	func encodeFrame(into encoder: MTLRenderCommandEncoder) throws
}
