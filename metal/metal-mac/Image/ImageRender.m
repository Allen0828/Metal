//
//  ImageRender.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#import "ImageRender.h"
#import <AVFoundation/AVFoundation.h>
#import "ShaderTypes.h"

@interface ImageRender ()

@property (nonatomic,strong) NSImage *image;

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) id <MTLRenderPipelineState> pipelineState;
@property (nonatomic,strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic,strong) id <MTLBuffer> vertices;
@property (nonatomic,assign) NSUInteger numVertices;
@property (nonatomic,strong) id <MTLTexture> texture;
@property (nonatomic,assign) vector_uint2 viewportSize;
@property (nonatomic,weak) id <MTLDevice> device;


@end


@implementation ImageRender


- (instancetype)initWithMetalView:(MTKView*)mtkView {
    if (self=[super init]) {
        _device = mtkView.device;
        _commandQueue = [_device newCommandQueue];
        
        self.image = [NSImage imageNamed:@"test_img0"];
        [self setupFragment];
        [self setupPineline];
        [self setupFragment];
        
    }
    return self;
}

- (void)setupFragment {
    NSImage *image = self.image;
    MTLTextureDescriptor *textureDesc = [MTLTextureDescriptor new];
    textureDesc.pixelFormat = MTLPixelFormatRGBA8Unorm;
    textureDesc.width = image.size.width;
    textureDesc.height = image.size.height;
    self.texture = [_device newTextureWithDescriptor:textureDesc];
    
    MTLRegion region = {
        {0, 0, 0},
        {textureDesc.width, textureDesc.height, 1}
    };
    Byte *imageBytes = [self loadImage:image];
    if (imageBytes) {
        [self.texture replaceRegion:region mipmapLevel:0 withBytes:imageBytes bytesPerRow:image.size.width * 4];
        free(imageBytes);
        imageBytes = NULL;
    }
}

- (Byte*)loadImage:(NSImage*)image {
    CFDataRef imgDate = (__bridge CFDataRef)([image TIFFRepresentation]);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(CGImageSourceCreateWithData((CFDataRef)imgDate, nil), 0, nil);
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    Byte *data = (Byte *)calloc(width * height * 4, sizeof(Byte)); // rgba 4个字节
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGContextRelease(context);
    return data;
}


- (void)setupPineline {
    // 初始化pipelineState
    MTLRenderPipelineDescriptor *pinelineDesc = [MTLRenderPipelineDescriptor new];
    id <MTLLibrary> library = [_device newDefaultLibrary];
    pinelineDesc.vertexFunction = [library newFunctionWithName:@"ImageVertexShader"];
    pinelineDesc.fragmentFunction = [library newFunctionWithName:@"ImageFragmentShader"];
    pinelineDesc.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    self.pipelineState = [_device newRenderPipelineStateWithDescriptor:pinelineDesc error:nil];
    
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
        // 映射.metal文件的方法
        [renderEncoder setRenderPipelineState:self.pipelineState];
        // 设置顶点数据
        [renderEncoder setVertexBuffer:self.vertices offset:0 atIndex:0];
        // 设置纹理数据
        [renderEncoder setFragmentTexture:self.texture atIndex:0];
        // 开始绘制
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:self.numVertices];
        // 结束渲染
        [renderEncoder endEncoding];
        // 提交
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    self.viewportSize = (vector_uint2){size.width, size.height};
}

- (void)setupVertex:(MTLRenderPassDescriptor *)renderPassDescriptor {
    
    if (self.vertices) {
        return;
    }
    NSImage *image = self.image;
    float heightScaling = 1.0;
    float widthScaling = 1.0;
    CGSize drawableSize = CGSizeMake(renderPassDescriptor.colorAttachments[0].texture.width, renderPassDescriptor.colorAttachments[0].texture.height);
    CGRect bounds = CGRectMake(0, 0, drawableSize.width, drawableSize.height);
    CGRect insetRect = AVMakeRectWithAspectRatioInsideRect(image.size, bounds);
    
    HobenVertex vertices[] = {
        // 顶点坐标 x, y, z, w  --- 纹理坐标 x, y
        { {-widthScaling,  heightScaling, 0.0, 1.0}, {0.0, 0.0} },
        { { widthScaling,  heightScaling, 0.0, 1.0}, {1.0, 0.0} },
        { {-widthScaling, -heightScaling, 0.0, 1.0}, {0.0, 1.0} },
        { { widthScaling, -heightScaling, 0.0, 1.0}, {1.0, 1.0} },
    };
    
    self.vertices = [_device newBufferWithBytes:vertices length:sizeof(vertices) options:MTLResourceStorageModeShared];
    self.numVertices = sizeof(vertices) / sizeof(HobenVertex);
}



@end
