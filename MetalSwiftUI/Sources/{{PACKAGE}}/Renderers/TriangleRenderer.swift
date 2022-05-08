import Metal
import simd

enum TriangleRendererError: LocalizedError {
  case failedToCreateVertexBuffer
  case failedToCreateIndexBuffer

  var errorDescription: String? {
    switch self {
    case .failedToCreateVertexBuffer:
      return "Failed to create vertex buffer"
    case .failedToCreateIndexBuffer:
      return "Failed to create index buffer"
    }
  }
}

struct TriangleRenderer: Renderer {
  let vertices: [SIMD3<Float>] = [
    [0, 0.5, 0],
    [0.5, -0.5, 0],
    [-0.5, -0.5, 0]
  ]

  let indices: [UInt16] = [0, 1, 2]

  var vertexBuffer: MTLBuffer

  var indexBuffer: MTLBuffer

  var pipelineState: MTLRenderPipelineState

  init(device: MTLDevice, commandQueue: MTLCommandQueue) throws {
    // Create vertex buffer
    guard let vertexBuffer = device.makeBuffer(
      bytes: &vertices,
      length: MemoryLayout<SIMD3<Float>>.stride * vertices.count
    ) else {
      throw TriangleRendererError.failedToCreateVertexBuffer
    }

    self.vertexBuffer = vertexBuffer
    
    // Create index buffer
    guard let indexBuffer = device.makeBuffer(
      bytes: &indices,
      length: MemoryLayout<UInt16>.stride * indices.count
    ) else {
      throw TriangleRendererError.failedToCreateIndexBuffer
    }

    self.indexBuffer = indexBuffer
    
    // Load shaders and create pipeline state
    let library = try MetalUtil.loadDefaultLibrary(device)
    let vertexFunction = try MetalUtil.loadFunction("vertexShader", from: library)
    let fragmentFunction = try MetalUtil.loadFunction("fragmentShader", from: library)
    pipelineState = try MetalUtil.makeRenderPipelineState(
      device: device,
      label: "TriangleRenderer.pipelineState",
      vertexFunction: vertexFunction,
      fragmentFunction: fragmentFunction
    )
  }

  func encodeFrame(into encoder: MTLRenderCommandEncoder) throws {
    encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    encoder.setRenderPipelineState(pipelineState)
    encoder.drawIndexedPrimitives(
      type: .triangle,
      indexCount: indices.count,
      indexType: .uint16,
      indexBuffer: indexBuffer,
      indexBufferOffset: 0
    )
  }
}
