//
//  ViewController.m
//  metal-mac
//
//  Created by allen0828 on 2022/6/26.
//

#import "ViewController.h"


#import "BasicController.h"
#import "SquareController.h"
#import "TriangleController.h"
#import "ImageController.h"

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary *dataDict;
@property (nonatomic,strong) NSTableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     1 使用MTKView 设置背景颜色
     初次使用
     2 使用CAMetalLayer 设置背景颜色
     对比 MTKView和CAMetalLayer的区别 后续直接使用CAMetalLayer来作为展示
     3 绘制一个三角形
     三角形可以这样说 如果呈现在屏幕上的图像是一座宫殿 那么三角形就是宫殿的支撑物
     介绍shader {
        VertexData数据，比如以数组的形式传递 3 个 3D 坐标用来表示一个三角形。顶点数据是一系列顶点的集合。顶点着色器主要的目的是把 3D 坐标转为另一种 3D 坐标，同时顶点着色器可以对顶点属性进行一些基本处理
     }
     对于绘制的几何图形来讲 三角形是最简单的图形
     并介绍顶点坐标和坐标范围 (需要一张简单图来介绍坐标的计算)
     ------1.0------
     |      |       |
     |      |       |
     -1.0   0       1.0
     |      |       |
     |      |       |
     -------1.0------
     光栅化阶段(Rasterization Stage)：根据几何着色器的输出，把图元映射为最终屏幕上相应的像素，生成供片段着色器(Fragment Shader)使用的片段(Fragment)
     
     Fragment片段着色器 主要目的是计算一个像素的最终颜色
     4 渲染一个二维正方形
     了解几何数学 绘制正方形实际是绘制2个三角形
     并介绍drawPrimitives方法的使用
     5 在update中变化颜色
     介绍 drawInMTKView: 方法 如何高效利用GPU
     6 创建一个MTLBuffer 并设置内容
     不使用系统的默认buffer 自由度高
     7 将图片渲染到MTKView
     图片坐标的转换 手动申请buffer的size
     8 绘制一组二维形状
     9 成组二维图形的动态变换

     */
    
    
    self.dataDict = [NSMutableDictionary dictionaryWithDictionary:
                     @{@"0正方形":@0, @"1变幻三角形":@0, @"2渲染图片":@0}];

    
    
    NSScrollView *scrollView = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller = YES;
    scrollView.frame = CGRectMake(0, 0, 800, 600);
    [self.view addSubview:scrollView];
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
    [self.tableView addTableColumn:column];
    [self.tableView reloadData];
    scrollView.contentView.documentView = self.tableView;

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenResize) name:NSWindowDidResizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(willEnterFull:) name:NSWindowWillEnterFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFull:) name:NSWindowWillExitFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willClose:) name:NSWindowWillCloseNotification object:nil];

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.dataDict.allKeys.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSArray *keysArray = [self.dataDict allKeys];
    NSArray *sortedArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortedArray[row];
}



- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([notification object] != self.tableView) {
        return;
    }
    NSTableView *table = [notification object];
    switch (table.selectedRow) {
        case 0: {
            NSString *key = @"0正方形";
            NSNumber *value = [self.dataDict objectForKey:key];
            if (value.intValue == 0) {
                // BasicController
                NSWindow *win = [NSWindow windowWithContentViewController:[SquareController new]];
                win.title = key;
                NSWindowController *winVC = [[NSWindowController alloc]init];
                winVC.window = win;
                [winVC showWindow:nil];
                [self.dataDict setValue:@1 forKey:key];
            }
            break;
        }
        case 1: {
            NSString *key = @"1变幻三角形";
            NSNumber *value = [self.dataDict objectForKey:key];
            if (value.intValue == 0) {
                NSWindow *win = [NSWindow windowWithContentViewController:[TriangleController new]];
                win.title = key;
                NSWindowController *winVC = [[NSWindowController alloc]init];
                winVC.window = win;
                [winVC showWindow:nil];
                [self.dataDict setValue:@1 forKey:key];
            }
            break;
        }
        case 2: {
            NSString *key = @"2渲染图片";
            NSNumber *value = [self.dataDict objectForKey:key];
            if (value.intValue == 0) {
                NSWindow *win = [NSWindow windowWithContentViewController:[ImageController new]];
                win.title = key;
                NSWindowController *winVC = [[NSWindowController alloc]init];
                winVC.window = win;
                [winVC showWindow:nil];
                [self.dataDict setValue:@1 forKey:key];
            }
            break;
        }
            
            
            
            
        default: break;
    }
    
}


- (void)screenResize {
    NSLog(@"观察窗口拉伸");
//    NSLog(@"%.2f===%.2f",self.view.bounds.size.width,self.view.bounds.size.height);
}
- (void)willEnterFull:(NSNotification*)notification {
    NSLog(@"即将全屏");
}
- (void)willExitFull:(NSNotification*)notification {
    NSLog(@"即将推出全屏");
}
- (void)willClose:(NSNotification*)notification {
    NSWindow *win = notification.object;
    NSNumber *value = [self.dataDict objectForKey:win.title];
    if (value.intValue == 1) {
        [self.dataDict setValue:@0 forKey:win.title];
    }
    NSLog(@"窗口关闭-%d-%@", value.intValue, win.title);
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


- (NSTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[NSTableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 66;
        [_tableView setHeaderView:nil];
        _tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
    }
    return _tableView;
}

@end
