//
//  Pipeline.h
//  metal
//
//  Created by Allen on 2024/5/14.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface Pipeline : NSObject

// 渲染背景的管线
+ (MTLRenderPipelineDescriptor*)newPipelineState:(MTLPixelFormat)format;
// 渲染其他物体的管线
+ (MTLRenderPipelineDescriptor*)newMainPipelineState:(MTLPixelFormat)format;

@end


