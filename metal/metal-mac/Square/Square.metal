//
//  Square.metal
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#include <metal_stdlib>
using namespace metal;

struct AEVertex
{
    float4 position [[position]];
    float4 color;
};

vertex AEVertex line_vertex_main(device AEVertex *vertices [[buffer(0)]],
                                device uint2 *lineIndices [[buffer(1)]],
                                uint vid [[vertex_id]],
                                uint iid [[instance_id]])
{
    float thickness = 0.02;
    uint lineIndex1 = lineIndices[iid].x;
    uint lineIndex2 = lineIndices[iid].y;
    
    float4 position1 = vertices[lineIndex1].position;
    float4 position2 = vertices[lineIndex2].position;
    
    float4 v = position2 - position1;
    float2 p0 = float2(position1.x, position1.y);
    float2 v0 = float2(v.x, v.y);
    float2 v1 = thickness * normalize(v0) * float2x2(float2(0, -1),float2(1, 0));
    float2 pa = p0 + v1;
    float2 pb = p0 - v1;
    float2 pc = p0 - v1 + v0;
    float2 pd = p0 + v1 + v0;
    
    AEVertex outVertex;
    switch(vid)
    {
        case 0:
            outVertex.position = float4(pa.x, pa.y, position1.z, position1.w);
            break;
        case 1:
            outVertex.position = float4(pb.x, pb.y, position1.z, position1.w);
            break;
        case 2:
            outVertex.position = float4(pc.x, pc.y, position2.z, position2.w);
            break;
        case 3:
            outVertex.position = float4(pa.x, pa.y, position1.z, position1.w);
            break;
        case 4:
            outVertex.position = float4(pc.x, pc.y, position2.z, position2.w);
            break;
        case 5:
            outVertex.position = float4(pd.x, pd.y, position2.z, position2.w);
            break;
    }
    return outVertex;
}

fragment float4 line_fragment_main(AEVertex inVertex [[stage_in]])
{
    return inVertex.color;
}


//typedef struct
//{
//    vector_float2 pos;
//} AEVertex;
//
//typedef struct
//{
//    float4 position [[position]];
//    float2 texCoord;
//} ColorInOut;
//
//vertex ColorInOut vertexShader(constant AEVertex *vertexArr [[buffer(0)]],
//                               uint vid [[vertex_id]])
//{
//    ColorInOut out;
//
//    float4 position = vector_float4(vertexArr[vid].pos, 0 , 1.0);
//    out.position = position;
//
//    return out;
//}
//
//fragment float4 fragmentShader(ColorInOut in [[stage_in]])
//{
//    return float4(1.0,0,0,0);
//}
//
