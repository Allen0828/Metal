//
//  main.m
//  metal
//
//  Created by allen0828 on 2022/6/26.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Metal/Metal.h>

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        // Apple iOS simulator GPU
        NSLog(@"GPU name = %@", device.name);
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
