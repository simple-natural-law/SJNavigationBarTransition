//
//  UIViewController+Bar.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "UIViewController+Bar.h"
#import <objc/runtime.h>


static char * const navigationBarAlphaKey = "navigationBarAlphaKey";
static char * const navigationBarBackgroundColorKey = "navigationBarBackgroundColorKey";
static char * const navigationBarBackgroundImageKey = "navigationBarBackgroundImageKey";


@implementation UIViewController (Bar)


- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha
{
    objc_setAssociatedObject(self, navigationBarAlphaKey, @(navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)navigationBarAlpha
{
    id alpha = objc_getAssociatedObject(self, navigationBarAlphaKey);

    if (alpha == NULL)
    {
        return 1.0;
    }else
    {
        return [alpha floatValue];
    }
}

- (void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor
{
    objc_setAssociatedObject(self, navigationBarBackgroundColorKey, navigationBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarBackgroundColor
{
    UIColor *color = objc_getAssociatedObject(self, navigationBarBackgroundColorKey);
    
    if (color == NULL)
    {
        return [UIColor whiteColor];
    }else
    {
        return color;
    }
}

- (void)setNavigationBarBackgroundImage:(UIImage *)navigationBarBackgroundImage
{
    objc_setAssociatedObject(self, navigationBarBackgroundImageKey, navigationBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)navigationBarBackgroundImage
{
    UIImage *image = objc_getAssociatedObject(self, navigationBarBackgroundImageKey);
    
    if (image == NULL)
    {
        return nil;
    }else
    {
        return image;
    }
}

@end
