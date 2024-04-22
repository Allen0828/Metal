//
//  ViewController.m
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#include <simd/simd.h>
#import "InputSystem.h"

NSString *shader = @"\
#include <metal_stdlib>\
\n\
using namespace metal;\
struct VertexIn {\
  float3 position [[attribute(0)]];\
};\
struct Transform {\
    float3x3 update;\
};\
vertex float4 test_vertex(const VertexIn vertex_in [[stage_in]], constant Transform *transform [[buffer(1)]]) {\
    float3 trans =  transform->update * vertex_in.position;\
    return float4(trans, 1.0);\
}\
fragment float4 test_fragment() {\
  return float4(1, 0, 0, 1);\
}\
";



@interface ViewController () <MTKViewDelegate>
{
    MTKMesh *mesh;
    simd_float3x3 transform;
}
@property (strong) MTKView *mtkView;
@property (strong) id <MTLRenderPipelineState> pipelineState;
@property (strong) id<MTLBuffer> transformBuffer;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(1, 1, 1, 1);
    [self.view addSubview:self.mtkView];

    NSError *error;
    // model
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:self.mtkView.device];
    
    MDLMesh *mMesh = [[MDLMesh alloc] initBoxWithExtent:simd_make_float3(0.75, 0.75, 0.75) segments:simd_make_uint3(1, 1, 1) inwardNormals:false geometryType:MDLGeometryTypeTriangles allocator:allocator];
    mesh = [[MTKMesh alloc] initWithMesh:mMesh device:self.mtkView.device error:&error];
    if (error != nil) {
        NSLog(@"model error");
    }
    
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newLibraryWithSource:shader options:nil error:&error];
    id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"test_vertex"];
    id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"test_fragment"];

    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    pipelineStateDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor);
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];

    transform = matrix_identity_float3x3;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (void)scrollWheel:(NSEvent *)event {
    InputSystem *input = [InputSystem shareInstance];
    input->mouseScroll.x = event.deltaX;
    input->mouseScroll.y = event.deltaY;
}

- (void)mouseDragged:(NSEvent *)event {
    InputSystem *input = [InputSystem shareInstance];
    input->mouseDelta.x = event.deltaX;
    input->mouseDelta.y = event.deltaY;
}


- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    [self update];
    
    
    id<MTLCommandBuffer> commandBuffer = [[self.mtkView.device newCommandQueue] commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = self.mtkView.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        
        self.transformBuffer = [self.mtkView.device newBufferWithLength:sizeof(simd_float3x3) options:MTLResourceCPUCacheModeDefaultCache];
        memcpy([self.transformBuffer contents], &transform, sizeof(transform));
        [renderEncoder setVertexBuffer:self.transformBuffer offset:0 atIndex:1];
        
        [renderEncoder setRenderPipelineState:self.pipelineState];
        [renderEncoder setVertexBuffer:mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
       
        
        for (MTKSubmesh *submesh in mesh.submeshes) {
            [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:0];
        }
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:self.mtkView.currentDrawable];
    }
    [commandBuffer commit];
}


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



@end
