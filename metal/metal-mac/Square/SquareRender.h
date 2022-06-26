//
//  SquareRender.h
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import <Foundation/Foundation.h>

@import MetalKit;
NS_ASSUME_NONNULL_BEGIN

@interface SquareRender : NSObject <MTKViewDelegate>

- (instancetype)initWithMetalView:(MTKView*)mtkView;

@end

NS_ASSUME_NONNULL_END
