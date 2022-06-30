//
//  BasicController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#import "BasicController.h"
#import "BasicRender.h"

@interface BasicController ()

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) BasicRender *render;

@end

@implementation BasicController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 800, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化View
    // 该对象需要一个对 Metal 设备对象的引用以便在内部创建资源 所以我们的第一步是将该视图的设备属性设置为现有的 MTLDevice 对象
    self.mtkView = [[MTKView alloc]initWithFrame:CGRectMake(200, 100, 400, 400) device:MTLCreateSystemDefaultDevice()];
    [self.view addSubview:self.mtkView];
    
    // 初始化视图中的所有内容时 我们可以通过设置其中的 clearColor 属性来实现背景颜色 使用MTLClearColorMake方法来设置这个颜色的RGBA通道数值。
    self.mtkView.clearColor = MTLClearColorMake(1, 0, 0, 1);
    // 如果不需要绘制任何的动态内容 可以将视图设置为仅在视图大小改变时等重要时刻进行更新
    self.mtkView.enableSetNeedsDisplay = YES;
    
    self.render = [[BasicRender alloc] initWithMetalView:self.mtkView];
    [self.render mtkView:self.mtkView drawableSizeWillChange:self.mtkView.drawableSize];
    
    
    // MTKView 会依靠程序向 Metal 发出指令来绘制内容 MTKView 使用委托的模式来在需要绘制的时候通知程序 ,如果我们要接收委托的回调,需要将视图的委托属性设置为符合 MTKViewDelegate 协议的对象
    self.mtkView.delegate = self.render;
    /*
     代理实现了两个方法
     1 视图会在视图大小产生变化时调用 mtkView:drawableSizeWillChange:方法 而这个回调会发生在渲染视图的窗口大小发生变化以及设备方向发生变化（iOS）时调用 这个方法允许我们的程序能够根据视图的大小来调整它所渲染的分辨率
     2 视图会在任何需要更新视图时调用 drawInMTKView:方法 在这个方法中 我们需要创建指令缓冲,编码指令来控制绘制的内容,告诉显示器何时以及排序指令缓冲中的指令来交由 GPU 执行. 而这一步我们有时称为“绘制一帧”. 我们可以把一帧想像为一张包含了我们所做的所有操作的画布,而这张画布最终会显示在屏幕上. 在某些可交互的程序中, 例如游戏,我们可能需要在每一帧中都绘制很多帧
     在这个demo中，我们创建一个名为 SquareRender 的类来实现这两个方法并承担绘制的工作 而视图控制器则会创建这个类的实例并将这个类设为是视图的代理
     */
    
}



@end
