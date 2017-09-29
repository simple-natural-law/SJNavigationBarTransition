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

@implementation UIViewController (Bar)

- (void)setBarAlpha:(CGFloat)barAlpha
{
    objc_setAssociatedObject(self, barAlphaKey, @(barAlpha), OBJC_ASSOCIATION_ASSIGN);
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

@end
