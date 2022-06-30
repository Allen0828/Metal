//
//  IPhoneImageController.m
//  metal
//
//  Created by allen0828 on 2022/6/30.
//

#import "IPhoneImageController.h"
#import <MetalKit/MetalKit.h>


#import "IPhoneImageRander.h"




@interface IPhoneImageController () {

    MTKView *_mtkView;
    IPhoneImageRander *_render;
    UILabel *_tip;
}


@end

@implementation IPhoneImageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mtkView = [[MTKView alloc] init];
    _mtkView.device = MTLCreateSystemDefaultDevice();
    [self.view addSubview:_mtkView];
    
    _render = [[IPhoneImageRander alloc] initWithMetalKitView:_mtkView];
    _render.img = [UIImage imageNamed:@"test_img0"];
    [_render mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];
    _mtkView.delegate = _render;
    
    _tip = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 200, 50)];
    _tip.text = @"点击屏幕切换图片";
    [self.view addSubview:_tip];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mtkView.frame = self.view.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_render.img == [UIImage imageNamed:@"test_img1"]) {
        _render.img = [UIImage imageNamed:@"test_img0"];
    } else {
        _render.img = [UIImage imageNamed:@"test_img1"];
    }
    [_render update];
}


@end
