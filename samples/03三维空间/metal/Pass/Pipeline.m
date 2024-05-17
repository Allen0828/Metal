//
//  Pipeline.m
//  metal
//
//  Created by Allen on 2024/5/14.
//

#import "Pipeline.h"
#import "Renderer.h"


@implementation Pipeline

+ (MTLRenderPipelineDescriptor*)newPipelineState:(MTLPixelFormat)format {
    id<MTLFunction> vertexFunction = [Renderer.library newFunctionWithName:@"vertex_bg"];
    id<MTLFunction> fragmentFunction = [Renderer.library newFunctionWithName:@"fragment_bg"];
    
    MTLRenderPipelineDescriptor *state = [[MTLRenderPipelineDescriptor alloc] init];
    state.vertexFunction = vertexFunction;
    state.fragmentFunction = fragmentFunction;
    state.colorAttachments[0].pixelFormat = format;
    return state;
}

+ (MTLRenderPipelineDescriptor*)newMainPipelineState:(MTLPixelFormat)format {
    id<MTLFunction> vertexFunction = [Renderer.library newFunctionWithName:@"main_vertex"];
    id<MTLFunction> fragmentFunction = [Renderer.library newFunctionWithName:@"main_fragment"];
    
    MTLRenderPipelineDescriptor *state = [[MTLRenderPipelineDescriptor alloc] init];
    state.vertexFunction = vertexFunction;
    state.fragmentFunction = fragmentFunction;
    state.colorAttachments[0].pixelFormat = format;
    
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[1].offset = 12;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    vertexDescriptor.attributes[2].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[2].offset = 24;
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    vertexDescriptor.layouts[0].stride = sizeof(float) * 8;
    state.vertexDescriptor = vertexDescriptor;
    
    return state;
}

@end
