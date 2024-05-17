//
//  Renderer.m
//  metal
//
//  Created by Allen on 2024/5/14.
//

#import "Renderer.h"
#import <MetalKit/MetalKit.h>
#import "Pipeline.h"
#import "Math.h"
#import "Model.h"

typedef struct
{
    vector_float4 pos;
    vector_float4 color;
    vector_float2 coord;
} VertexData;

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

static id<MTLDevice> m_device;
static id<MTLLibrary> m_library;

@interface Renderer ()
{
    Uniforms uniform;
    MTKMesh *mesh;
}

@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic,strong) id<MTLRenderPipelineState> mainPipelineState;

@property (nonatomic,strong) id<MTLBuffer> transformBuffer;
@property (nonatomic,strong) Model *flower;


@end

@implementation Renderer

+ (id)device {
    return m_device;
}
+ (id)library {
    return m_library;
}

- (instancetype)initWithMTKView:(MTKView *)view {
    if (self=[super init]) {
        m_device = view.device;
        m_library = [m_device newDefaultLibrary];

        self.flower = [[Model alloc] initWithModelName:@"flower.obj"];
        
        NSError *error;
        self.pipelineState = [view.device newRenderPipelineStateWithDescriptor:[Pipeline newPipelineState:view.colorPixelFormat] error:&error];
        self.mainPipelineState = [view.device newRenderPipelineStateWithDescriptor:[Pipeline newMainPipelineState:view.colorPixelFormat] error:&error];
        if (error != nil) {
            NSLog(@"%@", error);
        }
        self.commandQueue = [view.device newCommandQueue];
        
        // 创建一个model  使用 MDLMesh
        MTKMeshBufferAllocator  *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:m_device];
        MDLMesh *cube = [[MDLMesh alloc] initBoxWithExtent:simd_make_float3(1,1,1) segments:simd_make_uint3(1,1,1) inwardNormals:true geometryType:MDLGeometryTypeTriangles allocator:allocator];
        mesh = [[MTKMesh alloc] initWithMesh:cube device:m_device error:&error];
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if(renderPassDescriptor)
    {
        // pipeline 1
        [self drawPipeline:commandBuffer Descriptor:renderPassDescriptor];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (void)drawPipeline:(id<MTLCommandBuffer>)buffer Descriptor:(MTLRenderPassDescriptor*)descriptor  {
    id<MTLRenderCommandEncoder> renderEncoder = [buffer renderCommandEncoderWithDescriptor:descriptor];
    // background
    [self drawBackground:renderEncoder];
    // models
    [self drawModle:renderEncoder];
    
    [renderEncoder endEncoding];
}

-  (void)drawModle:(id<MTLRenderCommandEncoder>)renderEncoder {
    [renderEncoder setRenderPipelineState:self.mainPipelineState];
    [self updateUniform];
    [renderEncoder setVertexBuffer:self.transformBuffer offset:0 atIndex:1];
    
    // obj
    [self.flower render:renderEncoder];
    
    // mdlmesh
//    [renderEncoder setVertexBuffer:mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
//    MTKSubmesh *submesh = mesh.submeshes[0];
//    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:0];
}


float timer = 0;
- (void)updateUniform {
    timer += 0.5;
    float degrees = 45.0 + timer;
    float radians = degrees * (M_PI / 180.0);
    
    simd_float4x4 translation = translation_matrix(0, 0, 1.5);
    simd_float4x4 rotation = rotation_matrix(0, radians, 0);
    matrix_float4x4 modelMatrix = matrix_multiply(translation, rotation);
    uniform.modelMatrix = modelMatrix;
    
    uniform.viewMatrix = matrix_identity_float4x4;
    
    float fovRadians = 45.0 * (M_PI / 180.0);
    simd_float4x4 projection = projectionMatrix(fovRadians, 0.1, 500, 1);
    uniform.projectionMatrix = projection;
    
    self.transformBuffer = [m_device newBufferWithBytes:(void*)&uniform length:sizeof(uniform) options:MTLResourceCPUCacheModeDefaultCache];
}

- (void)drawBackground:(id<MTLRenderCommandEncoder>)renderEncoder {
    // 刷新显示区域 如屏幕发生了旋转
    //[renderEncoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }];
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
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
    [renderEncoder setFragmentTexture:bg atIndex:2];
    
    static const uint index[] = {
        0, 1, 2, 2, 3, 0
    };
    id<MTLBuffer> indexBuffer = [Renderer.device newBufferWithBytes:index length:sizeof(index) options:MTLResourceCPUCacheModeDefaultCache];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:[indexBuffer length] / sizeof(uint) indexType:MTLIndexTypeUInt32 indexBuffer:indexBuffer indexBufferOffset:0];

}

- (id<MTLTexture>)getBackgroundTexture {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"];
    if (path == nil) {
        return nil;
    }
    NSURL *url = [NSURL fileURLWithPath:path];
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
