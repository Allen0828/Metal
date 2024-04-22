//
//  InputSystem.m
//  metal
//
//  Created by allen on 2022/10/27.
//

#import "InputSystem.h"
#import <GameController/GameController.h>


static id _instance = nil;

@implementation InputSystem

+ (id)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self=[super init]) {
        mouseDelta = CGPointZero;
        mouseScroll = CGPointZero;
    }
    return self;
}


@end
