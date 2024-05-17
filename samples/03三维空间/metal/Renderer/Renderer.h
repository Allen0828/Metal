//
//  Renderer.h
//  metal
//
//  Created by Allen on 2024/5/14.
//

#import <Foundation/Foundation.h>

@class MTKView;


@interface Renderer : NSObject

+ (id)device;
+ (id)library;

- (instancetype)initWithMTKView:(MTKView*)view;
- (void)drawInMTKView:(MTKView*)view;

@end


