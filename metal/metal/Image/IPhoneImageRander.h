//
//  IPhoneImageRander.h
//  metal
//
//  Created by allen0828 on 2022/6/30.
//

#import <Foundation/Foundation.h>

@import MetalKit;

@interface IPhoneImageRander : NSObject <MTKViewDelegate>

@property (nonatomic,strong) UIImage *img;

- (instancetype)initWithMetalKitView:(MTKView*)mtkView;
- (void)update;

@end


