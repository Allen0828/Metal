//
//  ShaderTypes.h
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum VertexInputIndex {
    VertexInputIndexVertices     = 0,
    VertexInputIndexViewportSize = 1,
} VertexInputIndex;

typedef struct {
    vector_float2 position;
    vector_float4 color;
} Vertex;


typedef struct {
    vector_float4 position;
    vector_float2 textureCoordinate;
} HobenVertex;




#endif /* ShaderTypes_h */
