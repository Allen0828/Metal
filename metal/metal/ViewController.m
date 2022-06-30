//
//  ViewController.m
//  metal
//
//  Created by allen0828 on 2022/6/26.
//

#import "ViewController.h"
#import "IPhoneImageController.h"  // IOS12 验证通过


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[IPhoneImageController new] animated:true];
}


@end
