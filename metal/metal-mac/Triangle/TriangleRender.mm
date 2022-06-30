//
//  TriangleRender.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import "TriangleRender.h"
#import "ShaderTypes.h"

typedef struct {
    float red, green, blue, alpha;
} Color;


@interface TriangleRender ()
{
    id<MTLDevice> _device;
    // 渲染管道
    id<MTLRenderPipelineState> _pipelineState;
    // 缓冲区队列
    id<MTLCommandQueue> _commandQueue;
    // 渲染区域
    vector_uint2 _viewportSize;
}


@end

@implementation TriangleRender

- (instancetype)initWithMetalView:(MTKView*)mtkView {
    if (self=[super init]) {
        NSError *error;
        _device = mtkView.device;
        
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        // 设置着色器
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        // 设置颜色
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];

        // 创建管道
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Simple Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        // 渲染管道是否可用
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        if (error != nil) {
            NSLog(@"Pipeline unavailable %@", error);
        }
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

// 窗口发生改变时调用  重新绘制
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

// update
- (void)drawInMTKView:(nonnull MTKView *)view
{
    Color color = [self makeFancyColor];
    Vertex triangleVertices[] =
    {
        // 2D positions,    RGBA colors
        { {  250,  -250 }, { color.red, color.green, color.blue, 1 } },
        { { -250,  -250 }, { color.red, color.green, color.blue, 1 } },
        { {    0,   250 }, { color.red, color.green, color.blue, 1 } },
    };

    // Create a new command buffer for each render pass to the current drawable.
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommand";
    
    // Obtain a renderPassDescriptor generated from the view's drawable textures.
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if(renderPassDescriptor != nil)
    {
        // Create a render command encoder.
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";

        // Set the region of the drawable to draw into.
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, double(_viewportSize.x), double(_viewportSize.y), 0.0, 1.0 }];
        
        [renderEncoder setRenderPipelineState:_pipelineState];

        // Pass in the parameter data.
        [renderEncoder setVertexBytes:triangleVertices
                               length:sizeof(triangleVertices)
                              atIndex:VertexInputIndexVertices];
        
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:VertexInputIndexViewportSize];

        // Draw the triangle.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];

        [renderEncoder endEncoding];

        // Schedule a present once the framebuffer is complete using the current drawable.
        [commandBuffer presentDrawable:view.currentDrawable];
    }

    // Finalize rendering here & push the command buffer to the GPU.
    [commandBuffer commit];
    [self update];
}

- (void)update {
    
}

- (Color)makeFancyColor {

    static BOOL growing = YES;
    static NSUInteger primaryChannel = 0;
    static float colorChannels[] = { 1.0, 0.0, 0.0, 1.0 };
    const float DynamicColorRate = 0.015;
    if (growing) {
        NSUInteger dynamicChannelIndex = (primaryChannel + 1) % 3;
        colorChannels[dynamicChannelIndex] += DynamicColorRate;
        if (colorChannels[dynamicChannelIndex] >= 1.0) {
            growing = NO;
            primaryChannel = dynamicChannelIndex;
        }
    } else {
        NSUInteger dynamicChannelIndex = (primaryChannel + 2) % 3;
        colorChannels[dynamicChannelIndex] -= DynamicColorRate;
        if (colorChannels[dynamicChannelIndex] <= 0.0) {
            growing = YES;
        }
    }
    Color color;
    color.red = colorChannels[0];
    color.green = colorChannels[1];
    color.blue = colorChannels[2];
    color.alpha = colorChannels[3];
    return color;
}

- (void)dealloc {
    _device = nil;
    _pipelineState = nil;
    _commandQueue = nil;
//    _viewportSize = nullptr_t;
    NSLog(@"TriangleRender == dealloc");
}

@end
