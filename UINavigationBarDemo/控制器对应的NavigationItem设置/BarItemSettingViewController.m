//
//  BarItemSettingViewController.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/10/16.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "BarItemSettingViewController.h"

@interface BarItemSettingViewController ()

@end

@implementation BarItemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 显示默认的返回按钮，如果要修改返回按钮的文本，可以在上一个页面，修改其navigationItem的backBarButtonItem属性,设置想要显示的文本。统一在基础控制器中更改
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItems = @[closeItem];
    
    
    UIBarButtonItem *pushItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
    self.navigationItem.rightBarButtonItems = @[pushItem];
}

- (void)closeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushAction
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BarItemSettingViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
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
