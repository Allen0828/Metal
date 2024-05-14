//
//  main.m
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#if defined(TARGET_IOS)
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#else
#import <Cocoa/Cocoa.h>
#endif

#if defined(TARGET_IOS)

int main(int argc, char * argv[])
{
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

#else

int main(int argc, const char * argv[])
{
    return NSApplicationMain(argc, argv);
}

#endif
