//
//  BarAppearanceViewController.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/27.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "BarAppearanceViewController.h"

@interface BarAppearanceViewController ()

@end

@implementation BarAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.navigationController.navigationBar.layer.shadowPath = NULL;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
    self.navigationController.navigationBar.layer.shadowOffset  = CGSizeMake(0, -3);
}


#pragma mark- target action
// 设置navigationBar风格, UIBarStyleDefault- 背景为白色，title颜色为黑色。UIBarStyleBlack- 背景为黑色，title颜色为白色。
- (IBAction)defaultBarStyle:(id)sender
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
- (IBAction)blackBarStyle:(id)sender
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

// 设置navigationBar是否透明
- (IBAction)translucentYes:(id)sender
{
    self.navigationController.navigationBar.translucent = YES;
}
- (IBAction)translucentNo:(id)sender
{
    self.navigationController.navigationBar.translucent = NO;
}

// 设置navigationBar背景颜色
- (IBAction)whiteBarTintColor:(id)sender
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (IBAction)grennBarTintColor:(id)sender
{
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
}

// 设置navigationBar的tintColor可以控制UIBarButtonItem的图片和文字颜色
- (IBAction)blackTintColor:(id)sender
{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
- (IBAction)whiteTintColor:(id)sender
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

// 设置navigationBar的title文本属性(颜色，字体，大小等)
- (IBAction)changeTitleTextAttributes:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
    }else
    {
        UIColor *color = self.navigationController.navigationBar.barStyle == UIBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor];
        
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
    }
}

// 根据navigationBar状态调整navigationBar的title在垂直方向上的偏移量(当屏幕旋转时，navigationBar的状态会改变，默认状态为UIBarMetricsDefault)
- (IBAction)changeTitleVerticalPosition:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:10.0 forBarMetrics:UIBarMetricsDefault];
    }else
    {
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0.0 forBarMetrics:UIBarMetricsDefault];
    }
}

// 根据navigationBar状态设置背景图片来自定义导航栏外观
- (IBAction)changeBackgroundImage:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar"] forBarMetrics:UIBarMetricsDefault];
    }else
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
}

// 设置底部阴影图片(底部分割线)
- (IBAction)changeShadowImage:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [self.navigationController.navigationBar setShadowImage:[self imageWithColor:[UIColor cyanColor]]];
    }else
    {
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}

// 给NavgationBar底部添加设置阴影
- (IBAction)changeShadow:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        self.navigationController.navigationBar.layer.shadowOffset  = CGSizeMake(0, 2);
        self.navigationController.navigationBar.layer.shadowOpacity = 0.3;
        self.navigationController.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.navigationBar.bounds].CGPath;
    }else
    {
        self.navigationController.navigationBar.layer.shadowPath = NULL;
        self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
        self.navigationController.navigationBar.layer.shadowOffset  = CGSizeMake(0, -3);
    }
}

#pragma mark- Methods
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 0.5f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
