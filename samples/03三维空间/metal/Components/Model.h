//
//  Model.h
//  metal
//
//  Created by Allen on 2024/5/16.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface Model : NSObject

- (instancetype)initWithModelName:(NSString*)name;

- (void)render:(id<MTLRenderCommandEncoder>)encoder;

@end


