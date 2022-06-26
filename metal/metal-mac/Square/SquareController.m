//
//  SquareController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import <MetalKit/MetalKit.h>

#import "SquareController.h"
#import "SquareRender.h"



@interface SquareController ()

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) SquareRender *render;
@end

@implementation SquareController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 800, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc]initWithFrame:CGRectMake(200, 100, 400, 400) device:MTLCreateSystemDefaultDevice()];

    [self.view addSubview:self.mtkView];

    self.render = [[SquareRender alloc] initWithMetalView:self.mtkView];
    [self.render mtkView:self.mtkView drawableSizeWillChange:self.mtkView.drawableSize];

    self.mtkView.delegate = self.render;
}

@end
