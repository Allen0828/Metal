//
//  ViewController.m
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

#import "InputSystem.h"


@interface ViewController () <MTKViewDelegate>

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) Renderer *renderer;


@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(1, 1, 1, 1);
    [self.view addSubview:self.mtkView];

    self.renderer = [[Renderer alloc] initWithMTKView:self.mtkView];
//    transform = matrix_identity_float3x3;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (void)scrollWheel:(NSEvent *)event {
    InputSystem *input = [InputSystem shareInstance];
    input->mouseScroll.x = event.deltaX;
    input->mouseScroll.y = event.deltaY;
}

- (void)mouseDragged:(NSEvent *)event {
    InputSystem *input = [InputSystem shareInstance];
    input->mouseDelta.x = event.deltaX;
    input->mouseDelta.y = event.deltaY;
}


- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    [self.renderer drawInMTKView:view];
}


@end
