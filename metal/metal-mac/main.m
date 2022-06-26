//
//  main.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/NSApplication.h>
#import <Metal/Metal.h>


int main(int argc, const char * argv[]) {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    NSLog(@"GPU name = %@", device.name);
    
    return NSApplicationMain(argc, argv);
}
