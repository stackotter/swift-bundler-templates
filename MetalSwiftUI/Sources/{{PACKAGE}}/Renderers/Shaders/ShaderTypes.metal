struct Vertex {
	float3 position;
};

struct FragmentInput {
		float4 position [[position]];
		float3 deviceCoordinatesPosition;
};
