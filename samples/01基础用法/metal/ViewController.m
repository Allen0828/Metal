//
//  ViewController.m
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import <simd/simd.h>

NSString *shader = @"\
#include <metal_stdlib>\
\n\
using namespace metal;\
vertex float4 vertexShader(uint vid [[vertex_id]], constant float4 *vertices [[buffer(0)]]) {\
    return vertices[vid];\
}\
fragment float4 fragmentShader() {\
    return float4(1,0,0,1);\
}\
";

typedef struct
{
    vector_float4 pos;   // X Y Z W
} TriangleVertex;

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTKView *mtkView = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    mtkView.device = MTLCreateSystemDefaultDevice();
    mtkView.clearColor = MTLClearColorMake(1, 1, 1, 1);
    [self.view addSubview:mtkView];

    NSError *error;
    id<MTLLibrary> defaultLibrary = [mtkView.device newLibraryWithSource:shader options:nil error:&error];
    id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
    id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

    id <MTLRenderPipelineState> pipelineState = [mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];

    id<MTLCommandBuffer> commandBuffer = [[mtkView.device newCommandQueue] commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = mtkView.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder setRenderPipelineState:pipelineState];
        TriangleVertex vert[] = {
            { .pos = {0, 1.0, 0, 1}},
            { .pos = {-1.0, -1.0, 0, 1}},
            { .pos = {1.0, -1.0, 0, 1}},
        };
        [renderEncoder setVertexBytes:vert length:sizeof(vert) atIndex:0];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6 instanceCount: 2];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:mtkView.currentDrawable];
    }
    [commandBuffer commit];
}

@end
