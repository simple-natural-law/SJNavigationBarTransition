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
    self.navigationBar.translucent = !(alpha == 1.0);// iOS 11.0，translucent为NO时,由于导航栏新添加了large Title，会在viewWillAppear方法中将_UIBarBackground的alpha重置为1，会导致我们设置了透明但却没有效果.而translucent为YES，改变_backgroundEffectView的alpha值，不会被重置。
    
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
    //NSLog(@"z_updateInteractiveTransition");
    if (self.topViewController != nil)
    {
        id<UIViewControllerTransitionCoordinator> coor = self.topViewController.transitionCoordinator;
        
        UIViewController *fromVC = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC   = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // alpha
        CGFloat fromAlpha = fromVC.barAlpha;
        CGFloat toAlpha   = toVC.barAlpha;
        CGFloat alpha     = fromAlpha + (toAlpha - fromAlpha)*percentComplete;
        // tint color
        UIColor *newColor = [self getColorWithFromColor:fromVC.navBarTintColor toColor:toVC.navBarTintColor percentComplete:percentComplete];
        
        self.navigationBar.barTintColor = newColor;
        
        [self setNavigationBarAlpha:alpha];
        
        [self updateStatusBarStyleWithViewController:toVC];
    }
    
    [self z_updateInteractiveTransition:percentComplete];
}

- (UIViewController *)z_popViewControllerAnimated:(BOOL)animated
{
    //NSLog(@"z_popViewControllerAnimated");
    
    if (self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIViewController *popedVC = [self z_popViewControllerAnimated:animated];
        
        self.navigationBar.barTintColor = self.topViewController.navBarTintColor;
        
        return popedVC;
    }else
    {
        UIViewController *popedVC = [self z_popViewControllerAnimated:animated];
        
        [self addBarBackgroundLayerTransition];
        
        [self updateBarAppearenceWithViewController:self.topViewController];
        
        return popedVC;
    }
}


- (NSArray<UIViewController *> *)z_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"z_popToViewController");
    
    NSArray<UIViewController *> *poppedViewControllers = [self z_popToViewController:viewController animated:animated];
    
    [self addBarBackgroundLayerTransition];
    
    [self updateBarAppearenceWithViewController:viewController];
    
    return poppedViewControllers;
}

- (NSArray<UIViewController *> *)z_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<UIViewController *> *poppedViewControllers = [self z_popToRootViewControllerAnimated:animated];
    
    [self addBarBackgroundLayerTransition];
    
    UIViewController *popToVC = self.viewControllers.firstObject;
    
    [self updateBarAppearenceWithViewController:popToVC];
    
    return poppedViewControllers;
}

#pragma mark- UINavigationBarDelegate
// 点击返回
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    //NSLog(@"======");
    
    BOOL interactive = [self.topViewController.transitionCoordinator initiallyInteractive];
    
    if (self.topViewController && self.topViewController.transitionCoordinator && interactive)
    {
        if (@available(iOS 10.0, *))
        {
            [self.topViewController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                [self dealInteractionChanges:context];
            }];
        } else
        {
            [self.topViewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                [self dealInteractionChanges:context];
            }];
        }
       
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    
    UIViewController *popToVC = self.viewControllers[itemCount - 2];
    
    [self popToViewController:popToVC animated:YES];
    
    return YES;
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    [self addBarBackgroundLayerTransition];
    
    [self updateBarAppearenceWithViewController:self.topViewController];

    return YES;
}


#pragma mark- Methods

- (void)addBarBackgroundLayerTransition
{
    UIView *background = self.navigationBar.subviews[0];
    [background.layer removeAnimationForKey:@"ColorFade"];

    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.35;
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [background.layer addAnimation:transition forKey:@"ColorFade"];
}


- (void)updateBarAppearenceWithViewController:(UIViewController *)viewController
{
    self.navigationBar.barTintColor = viewController.navBarTintColor;
    
    [self setNavigationBarAlpha:viewController.barAlpha];
    
    [self updateStatusBarStyleWithViewController:viewController];
}


- (void)updateStatusBarStyleWithViewController:(UIViewController *)viewController
{
    if (viewController.barAlpha == 0)
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
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
}


- (CGFloat)colorBrigntness:(UIColor*)aColor
{
    CGFloat hue, saturation, brigntness, alpha;
    [aColor getHue:&hue saturation:&saturation brightness:&brigntness alpha:&alpha];
    return brigntness;
}


- (UIColor *)getColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percentComplete:(CGFloat)percentComplete
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
    CGFloat newColorAlpha = fromColorAlpha + (toColorAlpha - fromColorAlpha) * percentComplete;
    
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newColorAlpha];
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context
{
    if ([context isCancelled]) // 自动取消了返回手势
    {
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [UIView animateWithDuration:cancelDuration animations:^{
            
            [self updateBarAppearenceWithViewController:fromVC];
        }];
    }else
    {
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1.0 - [context percentComplete]);
        
        UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [UIView animateWithDuration:finishDuration animations:^{
            
            [self updateBarAppearenceWithViewController:toVC];
        }];
    }
}

@end
