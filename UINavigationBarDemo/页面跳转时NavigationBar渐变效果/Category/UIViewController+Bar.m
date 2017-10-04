//
//  UIViewController+Bar.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "UIViewController+Bar.h"
#import <objc/runtime.h>

static const char *barAlphaKey = "barAlphaKey";
static const char *navBarTintColorKey = "navBarTintColorKey";

@implementation UIViewController (Bar)

- (void)setBarAlpha:(CGFloat)barAlpha
{
    objc_setAssociatedObject(self, barAlphaKey, @(barAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)barAlpha
{
    id alpha = objc_getAssociatedObject(self, barAlphaKey);

    if (alpha == NULL)
    {
        return 1.0;
    }else
    {
        return [alpha floatValue];
    }
}

- (void)setNavBarTintColor:(UIColor *)navBarTintColor
{
    objc_setAssociatedObject(self, navBarTintColorKey, navBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    [self.navigationController.navigationBar setBackgroundImage:[self backgroundImageWithColor:barTintColor] forBarMetrics:UIBarMetricsDefault];
//
//    if(barTintColor == [UIColor clearColor])
//    {
//        [self.navigationController.navigationBar setShadowImage:[self shadowImageWithColor:barTintColor]];
//    }else
//    {
//        [self.navigationController.navigationBar setShadowImage:nil];
//    }
}

- (UIColor *)navBarTintColor
{
    UIColor *color = objc_getAssociatedObject(self, navBarTintColorKey);
    
    if (color == NULL)
    {
        return self.navigationController.navigationBar.barStyle == UIBarStyleDefault ? [UIColor whiteColor] : [UIColor blackColor];
    }else
    {
        return color;
    }
}

- (UIImage *)backgroundImageWithColor:(UIColor *)color
{
    return [self imageWithColor:color rect:CGRectMake(0.0, 0.0, self.view.frame.size.width, 64.0)];
}

- (UIImage *)shadowImageWithColor:(UIColor *)color
{
    return [self imageWithColor:color rect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}

- (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
