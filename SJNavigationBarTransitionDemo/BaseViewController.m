//
//  BaseViewController.m
//  SJNavigationBarTransition
//
//  Created by 如约科技 on 2017/9/27.
//  Copyright © 2017年 如约科技. All rights reserved.
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
    
    //NSLog(@"viewDidLoad");
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    NSLog(@"viewWillAppear");
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    NSLog(@"viewDidAppear");
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//    NSLog(@"viewWillDisappear");
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//
//    NSLog(@"viewDidDisappear");
//}


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
