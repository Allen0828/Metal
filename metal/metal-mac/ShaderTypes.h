//
//  ShaderTypes.h
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum AAPLVertexInputIndex {
    AAPLVertexInputIndexVertices     = 0,
    AAPLVertexInputIndexViewportSize = 1,
} AAPLVertexInputIndex;

typedef struct {
    vector_float2 position;
    vector_float4 color;
} AAPLVertex;





#endif /* ShaderTypes_h */
