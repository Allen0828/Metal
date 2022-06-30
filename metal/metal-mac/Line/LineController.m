//
//  LineController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#import "LineController.h"
#import "LineRender.h"

@interface LineController ()

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) LineRender *render;

@end


@implementation LineController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 800, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     调用drawPrimitives进行线条绘制时 只能得到固定宽度为1 pixel的线条 不能进行宽度调整
     使用矩形模拟有宽度的线条的方法进行宽度可调的线条的绘制
     在绘制时 会用到一点几何数学
     绘制宽度为10的线段 A A的短边分别为 a1 a2
     已知a1和a2的x,y 和 线段A的宽度
     只需要绘制2个三角形即可
     */
    
    
}




@end
