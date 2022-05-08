#include <metal_stdlib>
#include "ShaderTypes.metal"

using namespace metal;

vertex FragmentInput vertexShader(constant Vertex *vertices [[buffer(0)]],
																				uint vertexId [[vertex_id]]) {
		FragmentInput output;
		float3 position = vertices[vertexId].position;
		output.position = float4(position, 1);
		output.deviceCoordinatesPosition = position;
		return output;
}

