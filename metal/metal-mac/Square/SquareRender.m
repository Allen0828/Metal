//
//  SquareRender.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import "SquareRender.h"


typedef struct
{
    vector_float4 position;
    vector_float4 color;
} AEVertex;


@interface SquareRender ()
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLRenderPipelineState> _pipelineState;
}

@end


@implementation SquareRender

- (instancetype)initWithMetalView:(MTKView*)mtkView {
    if (self=[super init]) {
        _device = mtkView.device;
        // 创建一个与GPU交互的对象
        _commandQueue = [_device newCommandQueue];
        
        
        NSError *error = nil;
        // device.newDefaultLibrary 方法获得的MTLibrary 对象访问到你项目中的预编译shaders 然后通过名字检索每个shader
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"line_vertex_main"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"line_fragment_main"];
        
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
        
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor: pipelineStateDescriptor error:&error];
        if (error != nil) {
            NSLog(@"Pipeline unavailable %@", error);
        }
        
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
   
    
    
    const AEVertex lineVertices[] =
    {
        { .position = { -0.5, 0.5, 0, 1 }, .color = { 1, 0, 0, 1 } },
        { .position = {  0.5, 0.5, 0, 1 }, .color = { 1, 0, 0, 1 } },
    };
    static const uint lineIndices[]=
    {
        0, 1,
        1, 2
    };
    
//    { .position = [self randomPosition], .color = { 1, 0, 0, 1 } },
//    { .position = { -0.5, 0.5, 0, 1 }, .color = { 1, 0, 0, 1 } },
//    { .position = {  0.5, -0.5, 0, 1 }, .color = { 1, 0, 0, 1 } },
//    ,
//    1, 2,
//    2, 3,
//    0, 3
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    MTLRenderPassDescriptor *pass = view.currentRenderPassDescriptor;
    if (pass != nil) {
        id<MTLRenderCommandEncoder> commandEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:pass];
        
        id<MTLBuffer> lineVertexBuffer = [_device newBufferWithBytes:lineVertices length:sizeof(lineVertices) options:MTLResourceOptionCPUCacheModeDefault];
        id<MTLBuffer> lineIndexBuffer = [_device newBufferWithBytes:lineIndices length:sizeof(lineIndices) options:MTLResourceOptionCPUCacheModeDefault];
        
        [commandEncoder setRenderPipelineState:_pipelineState];
        [commandEncoder setVertexBuffer: lineVertexBuffer offset:0 atIndex:0];
        [commandEncoder setVertexBuffer: lineIndexBuffer offset:0 atIndex:1];
        
        
        /*
           绘制图形
         - parameter type:          画三角形
         - parameter vertexStart:   从vertex buffer 下标为0的顶点开始
         - parameter vertexCount:   顶点数
         - parameter instanceCount: 总共有1个三角形
        */
        [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6 instanceCount:4];
        
        [commandEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
        
    }
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {

}


- (vector_float4)randomPosition {
    vector_float4 ve = {[self random], [self random], [self random], [self random]};
    return ve;
}

- (float)random {
    int precision = 100;
    float subtraction = 1.0 - -1.0;
    subtraction = ABS(subtraction);
    subtraction *= precision;
    float randomNumber = arc4random() % ((int)subtraction+1);
    randomNumber /= precision;
    float result = MIN(-1.0, 1.0) + randomNumber;
    return result;
}

@end
