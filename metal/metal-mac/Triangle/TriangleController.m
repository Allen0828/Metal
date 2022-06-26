//
//  TriangleController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import <MetalKit/MetalKit.h>

#import "TriangleController.h"
#import "TriangleRender.h"


@interface TriangleController ()

@property (nonatomic,strong) MTKView *mtkView;
@property (nonatomic,strong) TriangleRender *render;


@end

@implementation TriangleController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc]initWithFrame:CGRectMake(0, 0, 800, 600) device:MTLCreateSystemDefaultDevice()];

    [self.view addSubview:self.mtkView];

    self.render = [[TriangleRender alloc] initWithMetalView:self.mtkView];
    [self.render mtkView:self.mtkView drawableSizeWillChange:self.mtkView.drawableSize];

    self.mtkView.delegate = self.render;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenResize) name:NSWindowDidResizeNotification object:nil];
}

- (void)screenResize {
    self.mtkView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
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

- (void)dealloc {
    
    NSLog(@"---dealloc");
}


@end
