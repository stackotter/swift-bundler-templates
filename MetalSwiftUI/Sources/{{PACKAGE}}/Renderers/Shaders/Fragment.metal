#include <metal_stdlib>
#include "ShaderTypes.metal"

using namespace metal;

fragment float4 fragmentShader(FragmentInput in [[stage_in]]) {
	float angle = atan2(in.deviceCoordinatesPosition.x, in.deviceCoordinatesPosition.y);
	float brightness = (angle + M_PI_F) / (M_PI_F * 2);
  return float4(brightness, brightness, brightness, 1);
}
