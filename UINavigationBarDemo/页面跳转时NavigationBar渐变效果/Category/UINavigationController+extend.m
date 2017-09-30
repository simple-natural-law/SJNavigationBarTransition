//
//  UINavigationController+extend.m
//  RYTaxiClient
//
//  Created by 讯心科技 on 2017/7/10.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "UINavigationController+extend.h"
#import "UIViewController+Bar.h"
#import <objc/runtime.h>


@implementation UINavigationController (extend)


+ (void)swizzleOriginalSelector:(SEL)originalSelector withCurrentSelector:(SEL)currentSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, currentSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            currentSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (self == [UINavigationController class])
        {
            SEL originalSelector1  = NSSelectorFromString(@"_updateInteractiveTransition:");
            SEL swizzledSelector1  = NSSelectorFromString(@"z_updateInteractiveTransition:");
            [self swizzleOriginalSelector:originalSelector1 withCurrentSelector:swizzledSelector1];
            
            SEL originalSelector2  = @selector(popToViewController:animated:);
            SEL swizzledSelector2  = NSSelectorFromString(@"z_popToViewController:animated:");
            [self swizzleOriginalSelector:originalSelector2 withCurrentSelector:swizzledSelector2];
            
            SEL originalSelector3  = @selector(popToRootViewControllerAnimated:);
            SEL swizzledSelector3  = NSSelectorFromString(@"z_popToRootViewControllerAnimated:");
            [self swizzleOriginalSelector:originalSelector3 withCurrentSelector:swizzledSelector3];
            
            SEL originalSelector4  = @selector(popViewControllerAnimated:);
            SEL swizzledSelector4  = NSSelectorFromString(@"z_popViewControllerAnimated:");
            [self swizzleOriginalSelector:originalSelector4 withCurrentSelector:swizzledSelector4];
        }
    });
}

/// 设置导航栏透明度
- (void)setNavigationBarAlpha:(CGFloat)alpha
{
    self.navigationBar.translucent = !(alpha == 1.0);// iOS 11.0 translucent为YES时Bar才能透明
    
    UIView *barBgView = self.navigationBar.subviews[0];
    
    UIView *shadowView = [barBgView valueForKey:@"_shadowView"];
    
    if (shadowView)
    {
        shadowView.alpha  = alpha;
        shadowView.hidden = alpha == 0.0;
    }
    
    if (self.navigationBar.isTranslucent)
    {
        if (@available(iOS 10.0, *))
        {
            UIView *bgEffectView = [barBgView valueForKey:@"_backgroundEffectView"];
            if (bgEffectView && [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] == nil)
            {
                barBgView.alpha = alpha;// 解决手势返回时，透明Bar页面与不透明bar页面切换会闪烁的问题.
                bgEffectView.alpha = alpha;
                return;
            }
        }else
        {
            UIView *adaptiveBackDrop = [barBgView valueForKey:@"_adaptiveBackdrop"];
            UIView *backDropEffectView = [adaptiveBackDrop valueForKey:@"_backdropEffectView"];
            if (adaptiveBackDrop && backDropEffectView)
            {
                barBgView.alpha = alpha;// 解决手势返回时，透明Bar页面与不透明bar页面切换会闪烁的问题.
                backDropEffectView.alpha = alpha;
                return;
            }
        }
    }
    barBgView.alpha = alpha;
}

- (void)z_updateInteractiveTransition:(CGFloat)percentComplete
{
    if (self.topViewController != nil)
    {
        id<UIViewControllerTransitionCoordinator> coor = self.topViewController.transitionCoordinator;
        
        if (coor != nil)
        {
            UIViewController *fromVC = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC   = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
            // alpha
            CGFloat fromAlpha = fromVC.barAlpha;
            CGFloat toAlpha   = toVC.barAlpha;
            CGFloat alpha     = fromAlpha + (toAlpha - fromAlpha)*percentComplete;
            [self setNavigationBarAlpha:alpha];
            // tint color
            UIColor *newColor = [self getColorWithFromColor:fromVC.navBarTintColor toColor:toVC.navBarTintColor fromAlpha:fromAlpha toAlpha:toAlpha percentComplete:percentComplete];
            self.navigationBar.barTintColor = newColor;
            
            if (toVC.barAlpha == 0.0)
            {
                if ([self colorBrigntness:toVC.view.backgroundColor] > 0.5)
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            } else
            {
                if ([self colorBrigntness:newColor] > 0.5)
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
        }
    }
    
    [self z_updateInteractiveTransition:percentComplete];
}

- (UIViewController *)z_popViewControllerAnimated:(BOOL)animated
{
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    
    [self setNavigationBarAlpha:popToVC.barAlpha];
    
    self.navigationBar.barTintColor = popToVC.navBarTintColor;
    
    if (popToVC.barAlpha == 0.0)
    {
        if ([self colorBrigntness:popToVC.view.backgroundColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else
    {
        if ([self colorBrigntness:popToVC.navBarTintColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    
    return [self z_popViewControllerAnimated:animated];;
}


- (NSArray<UIViewController *> *)z_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setNavigationBarAlpha:viewController.barAlpha];
    
    self.navigationBar.barTintColor = viewController.navBarTintColor;
    
    if (viewController.barAlpha == 0.0)
    {
        if ([self colorBrigntness:viewController.view.backgroundColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else
    {
        if ([self colorBrigntness:viewController.navBarTintColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    
    return [self z_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)z_popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController *popToVC = self.viewControllers.firstObject;
    
    [self setNavigationBarAlpha:popToVC.barAlpha];
    
    self.navigationBar.barTintColor = popToVC.navBarTintColor;
    
    if (popToVC.barAlpha == 0.0)
    {
        if ([self colorBrigntness:popToVC.view.backgroundColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else
    {
        if ([self colorBrigntness:popToVC.navBarTintColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    
    return [self z_popToRootViewControllerAnimated:animated];
}

- (CGFloat)colorBrigntness:(UIColor*)aColor
{
    CGFloat hue, saturation, brigntness, alpha;
    [aColor getHue:&hue saturation:&saturation brightness:&brigntness alpha:&alpha];
    return brigntness;
}


- (UIColor *)getColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percentComplete:(CGFloat)percentComplete
{
    CGFloat fromRed        = 0.0;
    CGFloat fromGreen      = 0.0;
    CGFloat fromBlue       = 0.0;
    CGFloat fromColorAlpha = 0.0;
    CGFloat toRed        = 0.0;
    CGFloat toGreen      = 0.0;
    CGFloat toBlue       = 0.0;
    CGFloat toColorAlpha = 0.0;
    
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromColorAlpha];
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toColorAlpha];
    
    CGFloat newRed        = fromRed + (toRed - fromRed) * percentComplete;
    CGFloat newGreen      = fromGreen + (toGreen - fromGreen) * percentComplete;
    CGFloat newBlue       = fromBlue + (toBlue - fromBlue) * percentComplete;
    CGFloat newColorAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
    
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newColorAlpha];
}


#pragma mark- UINavigationBarDelegate
// 点击返回
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil)
    {
        if (@available(iOS 10.0, *)) {
            [self.topViewController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                [self dealInteractionChanges:context];
            }];
        } else {
            // Fallback on earlier versions
            [self.topViewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                [self dealInteractionChanges:context];
            }];
        }
       
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    
    [self popToViewController:popToVC animated:YES];
    
    return YES;
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    id<UIViewControllerTransitionCoordinator> coordinator = self.topViewController.transitionCoordinator;
    CGFloat duration = coordinator.transitionDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve: coordinator.completionCurve];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:duration];
    
    self.navigationBar.barTintColor = self.topViewController.navBarTintColor;
    
    if (self.topViewController.barAlpha == 0)
    {
        if ([self colorBrigntness:self.topViewController.view.backgroundColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else
    {
        if ([self colorBrigntness:self.topViewController.navBarTintColor] > 0.5)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    
    [self setNavigationBarAlpha:self.topViewController.barAlpha];
    
    [UIView commitAnimations];
    
    return YES;
}


- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context
{
    if ([context isCancelled]) // 自动取消了返回手势
    {
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        
        UIViewController *formVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [UIView animateWithDuration:cancelDuration animations:^{
            
            CGFloat alpha = formVC.barAlpha;
            
            [self setNavigationBarAlpha:alpha];
            
            self.navigationBar.barTintColor = formVC.navBarTintColor;
            
            if (formVC.barAlpha == 0)
            {
                if ([self colorBrigntness:formVC.view.backgroundColor] > 0.5)
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            } else
            {
                if ([self colorBrigntness:formVC.navBarTintColor] > 0.5)
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
        }];
    }else
    {
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1.0 - [context percentComplete]);
        
        UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [UIView animateWithDuration:finishDuration animations:^{
            
            CGFloat alpha = toVC.barAlpha;
            
            [self setNavigationBarAlpha:alpha];
            
            self.navigationBar.barTintColor = toVC.navBarTintColor;
            
            if (toVC.barAlpha == 0)
            {
                if ([self colorBrigntness:toVC.view.backgroundColor] > 0.5)
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            } else
            {
                if ([self colorBrigntness:toVC.navBarTintColor] > 0.5)
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                } else
                {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                }
            }
        }];
    }
}

@end
