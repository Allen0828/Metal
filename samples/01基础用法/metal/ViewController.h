//
//  ViewController.h
//  metal
//
//  Created by allen0828 on 2022/10/26.
//

#if defined(TARGET_IOS)
#import  <UIKit/UIKit.h>
#define PlatformViewController UIViewController
#else
#import <AppKit/AppKit.h>
#define PlatformViewController NSViewController
#endif

#import <MetalKit/MetalKit.h>

// The view controller
@interface ViewController : PlatformViewController

@end


