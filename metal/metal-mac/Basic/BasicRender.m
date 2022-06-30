//
//  BasicRender.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#import "BasicRender.h"

@interface BasicRender ()

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

@end


@implementation BasicRender


- (instancetype)initWithMetalView:(MTKView*)mtkView {
    if (self=[super init]) {
        self.device = mtkView.device;
        // 创建一个与GPU交互的对象
        self.commandQueue = [_device newCommandQueue];
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
   
    // 为当前渲染的每个渲染传递创建一个新的命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    //  创建一个渲染 pass 的标识符
    // 当我们绘制时，GPU 会存储到纹理（Texture）中 而这是一组可供 GPU 访问的包含图像的内存块
    // MTKView 会创建所有我们需要绘制到视图里的纹理 这就允许我们创建出多张纹理, 从而使得我们可以在我们渲染当前纹理时还能显示另一张纹理
    // 我们需要创建一个渲染 pass 来进行绘制 而这是一组指令用于绘制多张纹理
    // 我们将渲染 pass 中用到的纹理称之为渲染目标（Render Target）
    // 如果我们需要创建一个渲染 pass 我们就需要创建一个渲染 pass 的标识符即 MTLRenderPassDescriptor 类的一个实例
    // 在SquareRender中 我们选择不配置我们自己的渲染 pass 标识符 而是使用 MetalKit 的 MTKView 对象来创建一个
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    /*
     该标识符带有一个颜色属性并指向视图的一个纹理。同标识符还会根据视图的其他属性来配置该渲染 pass
     一般来说 这表示在渲染 pass 开始时渲染目标会被刷成跟试图中的 clearColor 属性一致的颜色 并且这些改变会在渲染 pass 执行结束后保存会纹理中
     当然，渲染 pass 也会定义一些我们示例中没有用到的属性
     因为一个渲染 pass 的标识符可能为空 所以我们在创建一个真正的渲染 pass 前必须要检查我们是否真的创建了一个对应的标识符
     */
    if (renderPassDescriptor != nil) {
        /*
         我们可以通过使用 MTLRenderCommandEncoder 对象来将一个渲染 pass 编码到指令缓冲中
         我们可以调用指令缓冲的 renderCommandEncoderWithDescriptor: 方法并传入这个标识符来得到一个编码器
         */
        // 获取渲染 pass
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        // 其他渲染任务
        
        /*
         在SquareRender中 我们不需要编码任何的绘制指令 所以我们只需要编码清除纹理的指令即可
         */
        [renderEncoder endEncoding];
        /*
         当编码器结束之后,命令缓存区就会接受到2个命令.
         1) present
         2) commit
         因为GPU是不会直接绘制到屏幕上,因此你不给出去指令.是不会有任何内容渲染到屏幕上.
        */
        /*
         绘制一个纹理贴图并不会自动的讲内容展示到屏幕上 实际上只有某些纹理可以展示到屏幕上
         在 Metal 中 可显示在屏幕上的纹理是通过 drawable 对象来精心管理的
         当我们需要将会值得内容展示到屏幕上的时候 我们需要的是将 drawable 对象递交屏幕

         MTKView 对象会自动的创建一个 drawable 对象来管理他所有用的所有纹理
         我们要做的只是从 MTKView 对象中读取 currentDrawable 属性就能获得一个包含渲染目标纹理的 drawable 对象
         同时视图还会提供一个 CAMetalDrawable 对象来实现与 CoreAnimation 的连接
         id<MTLDrawable> drawable = view.currentDrawable;
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
