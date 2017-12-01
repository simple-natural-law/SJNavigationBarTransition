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

@property (strong, nonatomic) UIColor *barColor;

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
    
    self.barColor = [UIColor colorWithRed:r green:g blue:blue alpha:1.0];
    
    self.navBarTintColor = self.barColor;
    
    self.view.backgroundColor = self.barColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)popToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushNext:(id)sender
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
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
