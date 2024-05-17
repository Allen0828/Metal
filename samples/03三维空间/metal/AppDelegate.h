//
//  AppDelegate.h
//  metal
//
//  Created by allen0828 on 2022/10/26.
//


#if defined(TARGET_IOS)

#import <UIKit/UIKit.h>
#define PlatformAppDelegate UIResponder <UIApplicationDelegate>
#else

#import <AppKit/AppKit.h>
#define PlatformAppDelegate NSObject<NSApplicationDelegate>
#endif

@interface AppDelegate : PlatformAppDelegate

#if defined(TARGET_IOS)
@property (strong, nonatomic) UIWindow *window;
#endif

@end
