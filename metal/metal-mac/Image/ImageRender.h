//
//  ImageRender.h
//  metal-mac
//
//  Created by allen0828 on 2022/6/30.
//

#import <Foundation/Foundation.h>

@import MetalKit;

@interface ImageRender : NSObject <MTKViewDelegate>


- (instancetype)initWithMetalView:(MTKView*)mtkView;

@end

