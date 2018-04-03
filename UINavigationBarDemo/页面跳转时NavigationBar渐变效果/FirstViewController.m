//
//  FirstViewController.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "FirstViewController.h"
#import "UIViewController+Bar.h"

@interface FirstViewController ()


@end


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    int a = arc4random()%256;
    int b = arc4random()%256;
    int c = arc4random()%256;
    CGFloat r = a/255.0;
    CGFloat g = b/255.0;
    CGFloat blue = c/255.0;
    
    if (a%5 == 0)
    {
        self.navBarBackgroundImage = [UIImage imageNamed:@"bar"];
    }else
    {
        self.navBarBackgroundColor = [UIColor colorWithRed:r green:g blue:blue alpha:1.0];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:blue alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)popToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)pushNext:(id)sender
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
    int a = arc4random()%256;
    
    [self.navigationController pushViewController:vc animated:!(a%5 == 0)];
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
