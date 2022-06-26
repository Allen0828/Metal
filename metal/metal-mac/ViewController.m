//
//  ViewController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import "ViewController.h"

#import "SquareController.h"
#import "TriangleController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton *btn = [NSButton buttonWithTitle:@"click" target:self action:@selector(btnClicked)];
    btn.frame = CGRectMake(0, 0, 100, 50);
    [btn setTitle:@"click"];
    
    [self.view addSubview:btn];
    
    NSButton *btn1 = [NSButton buttonWithTitle:@"click" target:self action:@selector(btnClicked1)];
    btn1.frame = CGRectMake(0, 100, 100, 50);
    [btn1 setTitle:@"click"];
    
    [self.view addSubview:btn1];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenResize) name:NSWindowDidResizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(willEnterFull:) name:NSWindowWillEnterFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFull:) name:NSWindowWillExitFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willClose:) name:NSWindowWillCloseNotification object:nil];

}

- (void)btnClicked {
    
    NSWindow *win = [NSWindow windowWithContentViewController:[SquareController new]];
    win.title = @"正方形";
    
//    NSWindow *win = [NSWindow windowWithContentViewController:[TriangleController new]];
//    win.title = @"三角形";
    
    
    
    NSWindowController *winVC = [[NSWindowController alloc]init];
    winVC.window = win;
    [winVC showWindow:nil];
}

- (void)btnClicked1 {
    NSWindow *win = [NSWindow windowWithContentViewController:[TriangleController new]];
    win.title = @"变幻三角形";
    NSWindowController *winVC = [[NSWindowController alloc]init];
    winVC.window = win;
    [winVC showWindow:nil];
}


- (void)screenResize {
    NSLog(@"观察窗口拉伸");
    NSLog(@"%.2f===%.2f",self.view.bounds.size.width,self.view.bounds.size.height);
}
- (void)willEnterFull:(NSNotification*)notification {
    NSLog(@"即将全屏");
}
- (void)willExitFull:(NSNotification*)notification {
    NSLog(@"即将推出全屏");
}
- (void)willClose:(NSNotification*)notification {
    NSLog(@"窗口关闭");
}

- (void)viewWillAppear {
    [super viewWillAppear];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(800, 600)];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
