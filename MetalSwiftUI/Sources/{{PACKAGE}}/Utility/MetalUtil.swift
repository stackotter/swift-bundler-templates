import Metal

enum MetalUtilError: LocalizedError {
	case failedToCreateRenderPipelineState(Error)
	case failedToLoadDefaultLibrary
	case failedToLoadShaderFunction(name: String)

	var errorDescription: String? {
		switch self {
		case .failedToCreateRenderPipelineState(let error):
			return "Failed to create render pipeline state: \(error)"
		case .failedToLoadDefaultLibrary:
			return "Failed to create default Metal library: Unknown cause"
		case .failedToLoadShaderFunction(let name):
			return "Failed to load shader function '\(name)'"
		}
	}
}

enum MetalUtil {
	/// Makes a render pipeline state with the given properties.
	static func makeRenderPipelineState(
		device: MTLDevice,
		label: String,
		vertexFunction: MTLFunction,
		fragmentFunction: MTLFunction
	) throws -> MTLRenderPipelineState {
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		pipelineStateDescriptor.label = label
		pipelineStateDescriptor.vertexFunction = vertexFunction
		pipelineStateDescriptor.fragmentFunction = fragmentFunction
		pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		
		do {
			return try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
		} catch {
			throw MetalUtilError.failedToCreateRenderPipelineState(error)
		}
	}
	
	/// Loads the default metal library from the app bundle.
	static func loadDefaultLibrary(_ device: MTLDevice) throws -> MTLLibrary {
		guard let library = device.makeDefaultLibrary() else {
			throw MetalUtilError.failedToLoadDefaultLibrary
		}

		return library
	}
	
	/// Loads a metal function from the given library.
	static func loadFunction(_ name: String, from library: MTLLibrary) throws -> MTLFunction {
		guard let function = library.makeFunction(name: name) else {
			throw MetalUtilError.failedToLoadShaderFunction(name: name)
		}
		
		return function
	}
}
