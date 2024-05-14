//
//  AppDelegate.m
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

#if defined(TARGET_IOS)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

#else

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#endif

@end
