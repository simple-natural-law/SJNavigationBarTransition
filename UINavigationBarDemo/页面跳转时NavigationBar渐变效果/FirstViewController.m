//
//  FirstViewController.m
//  UINavigationBarDemo
//
//  Created by 如约科技 on 2017/9/29.
//  Copyright © 2017年 如约科技. All rights reserved.
//

#import "FirstViewController.h"
#import "SJNavigationBarTransition.h"

@interface FirstViewController ()
{
    int a;
    int b;
    int c;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
}

@end


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    a = arc4random()%256;
    b = arc4random()%256;
    c = arc4random()%256;
    red   = a/255.0;
    green = b/255.0;
    blue  = c/255.0;
    
    //self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (a%5 == 0)
    {
        [self.navigationController setNavigationBarBackgroundImage:[UIImage imageNamed:@"bar"]];
    }else
    {
        [self.navigationController setNavigationBarBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
    }
}

- (IBAction)popToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)pushNext:(id)sender
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
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
