//
//  ImageController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#import "ImageController.h"
#import "ImageRender.h"


@interface ImageController ()

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) ImageRender *render;

@end

@implementation ImageController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 800, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc]initWithFrame:CGRectMake(200, 100, 400, 400) device:MTLCreateSystemDefaultDevice()];
    [self.view addSubview:self.mtkView];
    
    self.mtkView.clearColor = MTLClearColorMake(1, 0, 0, 1);
    self.mtkView.enableSetNeedsDisplay = YES;
    self.render = [[ImageRender alloc] initWithMetalView:self.mtkView];
    [self.render mtkView:self.mtkView drawableSizeWillChange:self.mtkView.drawableSize];
    self.mtkView.delegate = self.render;
    
}


@end
