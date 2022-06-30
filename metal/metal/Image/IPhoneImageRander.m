//
//  IPhoneImageRander.m
//  metal
//
//  Created by allen0828 on 2022/6/30.
//

#import "IPhoneImageRander.h"
#import <AVFoundation/AVFoundation.h>


typedef struct {
    vector_float4 position;
    vector_float2 textureCoordinate;
} ImageVertex;


@interface IPhoneImageRander ()

@property (nonatomic,strong) MTKView *view;

@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) id<MTLBuffer> vertices;
@property (nonatomic,strong) id<MTLTexture> texture;
@property (nonatomic,strong) id<MTLDevice> device;

@property (nonatomic,assign) NSUInteger numVertices;
@property (nonatomic,assign) vector_uint2 viewportSize;


@end

@implementation IPhoneImageRander


- (instancetype)initWithMetalKitView:(MTKView *)mtkView {
    if (self=[super init]) {
        _device = mtkView.device;
        mtkView.clearColor = MTLClearColorMake(1, 1, 0, 1);
        _commandQueue = [_device newCommandQueue];
        self.view = mtkView;

        [self setupPineline];
    }
    return self;
}


- (void)drawInMTKView:(nonnull MTKView *)view {
    
    id <MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderDesc = view.currentRenderPassDescriptor;
    if (!renderDesc) {
        [commandBuffer commit];
        return;
    }
    renderDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);
    [self setupVertex:renderDesc];
    id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderDesc];
    [renderEncoder setViewport:(MTLViewport){0, 0, self.viewportSize.x, self.viewportSize.y, -1, 1}];
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setVertexBuffer:self.vertices offset:0 atIndex:0];
    [renderEncoder setFragmentTexture:self.texture atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:self.numVertices];
    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    self.viewportSize = (vector_uint2){size.width, size.height};
}


- (void)setupPineline {
    MTLRenderPipelineDescriptor *pinelineDesc = [MTLRenderPipelineDescriptor new];
    id <MTLLibrary> library = [_device newDefaultLibrary];
    pinelineDesc.vertexFunction = [library newFunctionWithName:@"ImageVertexShader"];
    pinelineDesc.fragmentFunction = [library newFunctionWithName:@"ImageFragmentShader"];
    pinelineDesc.colorAttachments[0].pixelFormat = self.view.colorPixelFormat;
    self.pipelineState = [_device newRenderPipelineStateWithDescriptor:pinelineDesc error:nil];
}

- (void)setupVertex:(MTLRenderPassDescriptor*)renderPassDescriptor {
    if (self.vertices) {
        return;
    }
    UIImage *image = self.img;

    CGSize drawableSize = CGSizeMake(renderPassDescriptor.colorAttachments[0].texture.width, renderPassDescriptor.colorAttachments[0].texture.height);
    CGRect bounds = CGRectMake(0, 0, drawableSize.width, drawableSize.height);
    CGRect insetRect = AVMakeRectWithAspectRatioInsideRect(image.size, bounds);

    // Aspect
    float width = insetRect.size.width / drawableSize.width;
    float height = insetRect.size.height / drawableSize.height;


    ImageVertex vertices[] = {
        { {-width, height, 0.0, 1.0}, {0.0, 0.0} },
        { {width, height, 0.0, 1.0}, {1.0, 0.0} },
        { {-width, -height, 0.0, 1.0}, {0.0, 1.0} },
        { {width, -height, 0.0, 1.0}, {1.0, 1.0} },
    };
    self.vertices = [_device newBufferWithBytes:vertices length:sizeof(vertices) options:MTLResourceStorageModeShared];
    self.numVertices = sizeof(vertices) / sizeof(ImageVertex);
}

- (void)update {
    _texture = nil;
}

- (id<MTLTexture>)texture {
    // 如果不设置懒加载 每一帧都会重新计算大小 CPU使用率 41%
    // 设置后CPU使用率 7%
    if (_texture == nil) {
        UIImage *image = self.img;
        MTLTextureDescriptor *textureDesc = [MTLTextureDescriptor new];
        textureDesc.pixelFormat = MTLPixelFormatRGBA8Unorm;
        textureDesc.width = image.size.width;
        textureDesc.height = image.size.height;
        MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice:self.device];
        _texture = [loader newTextureWithCGImage:image.CGImage options:@{MTKTextureLoaderOptionSRGB:@0} error:nil];;
    }
    return _texture;
}



@end

