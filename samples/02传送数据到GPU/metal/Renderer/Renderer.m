//
//  Renderer.m
//  metal
//
//  Created by Allen on 2024/5/10.
//

#import "Renderer.h"
#import <MetalKit/MetalKit.h>

typedef struct
{
    vector_float4 pos;
    vector_float4 color;
    vector_float2 coord;
} VertexData;

static id<MTLDevice> m_device;

@interface Renderer ()

@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;

@end

@implementation Renderer

- (instancetype)initWithMTKView:(MTKView *)view {
    if (self=[super init]) {
        m_device = view.device;
        NSError *error;
        id<MTLLibrary> defaultLibrary = [view.device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
        
        MTLRenderPipelineDescriptor *state = [[MTLRenderPipelineDescriptor alloc] init];
        state.vertexFunction = vertexFunction;
        state.fragmentFunction = fragmentFunction;
        state.colorAttachments[0].pixelFormat = view.colorPixelFormat;
        self.pipelineState = [view.device newRenderPipelineStateWithDescriptor:state error:&error];
        self.commandQueue = [view.device newCommandQueue];
        
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if(renderPassDescriptor)
    {
        
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        // 刷新显示区域 如屏幕发生了旋转
        //[renderEncoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }];
        [renderEncoder setRenderPipelineState:self.pipelineState];
        
        // background
        const VertexData background[] =
        {
            { { -1.0, -1.0, 0.0, 1.0 }, {1, 0, 1, 1 }, { 0, 0 } },
            { {  1.0, -1.0, 0.0, 1.0 }, {1, 1, 1, 1 }, { 1, 0 } },
            { {  1.0,  1.0, 0.0, 1.0 }, {1, 1, 0, 1 }, { 1, 1 } },
            { { -1.0,  1.0, 0.0, 1.0 }, {1, 1, 1, 1 }, { 0, 1 } },
        };
        [renderEncoder setVertexBytes:background length:sizeof(background) atIndex:0];
        bool test = false;
        [renderEncoder setFragmentBytes:&test length:sizeof(bool) atIndex:0];
        id<MTLTexture> bg = [self getBackgroundTexture];
        //[renderEncoder setFragmentTexture:bg atIndex:2];
        
        static const uint index[] = {
            0, 1, 2, 2, 3, 0
        };
        id<MTLBuffer> indexBuffer = [view.device newBufferWithBytes:index length:sizeof(index) options:MTLResourceCPUCacheModeDefaultCache];
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:[indexBuffer length] / sizeof(uint) indexType:MTLIndexTypeUInt32 indexBuffer:indexBuffer indexBufferOffset:0];

        // model
        const VertexData vert[] =
        {
            { { 0.0, 0.3, 0.0, 1.0 }, {1, 1, 1, 1 }, { 0, 0 } },
            { {-0.3, 0.0, 0.0, 1.0 }, {1, 0, 1, 1 }, { 0, 0 } },
            { { 0.3, 0.0, 0.0, 1.0 }, {1, 1, 0, 1 }, { 0, 0 } },
        };
        test = true;
        [renderEncoder setVertexBytes:vert length:sizeof(vert) atIndex:0];
        [renderEncoder setFragmentBytes:&test length:sizeof(bool) atIndex:0];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
        
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (id<MTLTexture>)getBackgroundTexture {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
    NSError *error;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:m_device];
    id<MTLTexture> uv = [textureLoader newTextureWithContentsOfURL:url options:@{MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft, MTKTextureLoaderOptionSRGB: @false, MTKTextureLoaderOptionGenerateMipmaps: @true} error:&error];
    if(error || uv == nil) {
        NSLog(@"Error creating texture %@", error.localizedDescription);
        return nil;
    }
    return uv;
}


@end


/*
 self.transformBuffer = [self.mtkView.device newBufferWithLength:sizeof(simd_float3x3) options:MTLResourceCPUCacheModeDefaultCache];
 memcpy([self.transformBuffer contents], &transform, sizeof(transform));
 [renderEncoder setVertexBuffer:self.transformBuffer offset:0 atIndex:1];
 
 - (void)update {
     InputSystem *input = [InputSystem shareInstance];
     CGFloat zoom = (input->mouseScroll.x + input->mouseScroll.y) * 0.1;
     transform.columns[0][0] += zoom;
     transform.columns[1][1] += zoom;
     input->mouseScroll = CGPointZero;
     
     if (!NSEqualPoints(input->mouseDelta, CGPointZero)) {
         transform.columns[2][0] += (input->mouseDelta.x * 0.1);
         input->mouseDelta = CGPointZero;
     }
 }

 */
