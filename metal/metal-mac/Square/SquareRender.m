//
//  SquareRender.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import "SquareRender.h"

@interface SquareRender ()
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
}

@end


@implementation SquareRender

- (instancetype)initWithMetalView:(MTKView*)mtkView {
    if (self=[super init]) {
        _device = mtkView.device;
        // 创建一个与GPU交互的对象
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    // 设置view的颜色
    view.clearColor = MTLClearColorMake(1, 0, 0, 1);
    // 为当前渲染的每个渲染传递创建一个新的命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommand";

    // 获取渲染管道
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        // 创建MTLRenderCommandEncoder 对象
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";
        // 其他渲染任务
        
        // 渲染结束
        [renderEncoder endEncoding];
        /*
         当编码器结束之后,命令缓存区就会接受到2个命令.
         1) present
         2) commit
         因为GPU是不会直接绘制到屏幕上,因此你不给出去指令.是不会有任何内容渲染到屏幕上.
        */
        // 清除的可绘制的屏幕
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    // 完成渲染并将命令缓冲区提交给GPU
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {

}



@end
