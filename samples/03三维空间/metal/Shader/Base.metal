//
//  Base.metal
//  metal
//
//  Created by Allen on 2024/5/14.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;


typedef struct
{
    float4 position;
    float4 color;
    float2 uv;
} In;

typedef struct
{
    float4 pos [[position]];
    float4 color;
    float2 uv;
} Out;

constant float3x3 colorConversion = float3x3(float3( 1.0,    1.0,     1.0    ),
                                             float3( 0.0,    -0.3437, 1.7722 ),
                                             float3( 1.4017, -0.7142, 0.0    ));


vertex Out vertex_bg(uint vid [[vertex_id]], constant In *vertexs [[buffer(0)]])
{
    Out out;
    out.pos = vertexs[vid].position;
    out.color = vertexs[vid].color;
    out.uv = vertexs[vid].uv;
    return out;
}

fragment float4 fragment_bg(Out input [[stage_in]], texture2d<float> textureY [[texture(0)]], texture2d<float> textureUV [[texture(1)]], texture2d<float> uv [[texture(2)]], constant bool &isTest[[buffer(0)]])
{
    if (isTest) {
        return float4(1, 0, 0, 1);
    }
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    if (!is_null_texture(textureY)) {
        float Y = textureY.sample(textureSampler, input.uv).r;
        float2 UV = textureUV.sample(textureSampler, input.uv).rg;
        UV = UV - float2(0.5, 0.5);
        float3 YUV = float3(Y, UV);
        return float4(colorConversion*YUV, 1.0);
    } else if (!is_null_texture(uv)) {
        float3 baseColor = uv.sample(textureSampler, input.uv).rgb;
        return float4(baseColor, 1);
    } else {
        return input.color;
    }
    return float4(1, 1, 1, 1);
}



