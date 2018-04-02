//
//  UIViewController+Bar.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "UIViewController+Bar.h"
#import <objc/runtime.h>

static char * const navBarKey = "navBarKey";
static char * const barAlphaKey = "barAlphaKey";
static char * const navBarBackgroundColorKey = "navBarBackgroundColorKey";
static char * const navBarBackgroundImageKey = "navBarBackgroundImageKey";

@implementation UIViewController (Bar)

- (void)setNavBar:(UIView *)navBar
{
    objc_setAssociatedObject(self, navBarKey, navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)navBar
{
    return objc_getAssociatedObject(self, navBarKey);
}

- (void)setBarAlpha:(CGFloat)barAlpha
{
    objc_setAssociatedObject(self, barAlphaKey, @(barAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navBar.alpha = barAlpha;
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

- (void)setNavBarBackgroundColor:(UIColor *)navBarBackgroundColor
{
    objc_setAssociatedObject(self, navBarBackgroundColorKey, navBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navBar.backgroundColor = navBarBackgroundColor;
}

- (UIColor *)navBarBackgroundColor
{
    UIColor *color = objc_getAssociatedObject(self, navBarBackgroundColorKey);
    
    if (color == NULL)
    {
        return [UIColor whiteColor];
    }else
    {
        return color;
    }
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage
{
    objc_setAssociatedObject(self, navBarBackgroundImageKey, navBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)navBarBackgroundImage
{
    UIImage *image = objc_getAssociatedObject(self, navBarBackgroundImageKey);
    
    if (image == NULL)
    {
        return nil;
    }else
    {
        return image;
    }
}

@end
