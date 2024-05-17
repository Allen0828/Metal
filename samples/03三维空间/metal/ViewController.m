//
//  ViewController.m
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"



@interface ViewController () <MTKViewDelegate>

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) Renderer *renderer;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#if defined(TARGET_IOS)
    self.mtkView = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
#else
    self.mtkView = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
#endif
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(1, 1, 1, 1);
    [self.view addSubview:self.mtkView];

    self.renderer = [[Renderer alloc] initWithMTKView:self.mtkView];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    [self.renderer drawInMTKView:view];
}


@end
