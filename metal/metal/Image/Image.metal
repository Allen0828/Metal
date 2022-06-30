//
//  Image.metal
//  metal
//
//  Created by allen0828 on 2022/6/30.
//

#include <metal_stdlib>
using namespace metal;



struct ImageVertex
{
    float4 position [[position]];
    float2 textureCoordinate;
};

typedef struct {
    float4 vertexPosition [[ position ]];
    float2 textureCoor;
} ImageData;

vertex ImageData ImageVertexShader(uint vertexId [[ vertex_id ]],
                                   constant ImageVertex *vertexArray [[ buffer(0) ]]) {
    ImageData out;
    out.vertexPosition = vertexArray[vertexId].position;
    out.textureCoor = vertexArray[vertexId].textureCoordinate;
    return out;
}

fragment float4 ImageFragmentShader(ImageData input [[ stage_in ]],
                               texture2d <float> colorTexture [[ texture(0) ]]) {
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    float4 colorSample = colorTexture.sample(textureSampler, input.textureCoor);
    return float4(colorSample);
}


