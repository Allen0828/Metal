# Metal Programming Guide(编程指南) 

本项目旨在通过模块化工程来一步步学习 Metal 的使用方法和常用开发

## 1 运行Metal
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-1.png" width="200" height="200"/>
</p>
<div>
首先通过一个基础示例来对 Metal 的创建进行初步的了解。
</div>

```objective-c
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
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3 instanceCount: 1];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:mtkView.currentDrawable];
    }
    [commandBuffer commit];
}
@end
```



 
## 2 MDLMesh、帧刷新、数据传入GPU
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-2.png" width="200" height="200"/>
</p>

## 3 3D模型和坐标矩阵
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-3.png" width="200" height="200"/>
</p>

## 4 法线和深度
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-4.png" width="200" height="200"/>
</p>

## 5 光源
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-5.png" width="200" height="200"/>
</p>

## 6 纹理
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-6.png" width="200" height="200"/>
</p>

## 7 材质组和glTF

<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-7.png" width="200" height="200"/>
</p>
<p>
<img src="https://github.com/Allen0828/Metal/blob/main/images/metal-8.png" width="200" height="200"/>
</p>
