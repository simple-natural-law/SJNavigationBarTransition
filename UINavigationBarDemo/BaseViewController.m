//
//  BaseViewController.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/27.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc
{
    NSLog(@"dealloc: %@",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // 设置默认的返回按钮的文本
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
