//
//  InputSystem.h
//  metal
//
//  Created by allen on 2022/10/27.
//

#import <Foundation/Foundation.h>



@interface InputSystem : NSObject
{
    @public
    CGPoint mouseDelta;
    CGPoint mouseScroll;
}

+ (id)shareInstance;


@end


