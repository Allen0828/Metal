//
//  TriangleRender.h
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#include <simd/simd.h>




@interface TriangleRender : NSObject <MTKViewDelegate>

- (instancetype)initWithMetalView:(MTKView*)mtkView;

@end


