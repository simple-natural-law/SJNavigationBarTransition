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


static char * const backgroundKey = "backgroundKey";

static char * const tempBackgroundKey = "tempBackgroundViewKey";

@interface UINavigationBar (extend)

@property (nonatomic, strong) UIImageView *background;

@property (nonatomic, strong) UIImageView *tempBackground;

@end


@implementation UINavigationBar (extend)

- (UIImageView *)background
{
    return objc_getAssociatedObject(self, backgroundKey);
}

- (void)setBackground:(UIImageView *)background
{
    objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)tempBackground
{
    return objc_getAssociatedObject(self, tempBackgroundKey);
}

- (void)setTempBackground:(UIImageView *)tempBackground
{
    objc_setAssociatedObject(self, tempBackgroundKey, tempBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UINavigationController (extend)

- (void)setNavigationBarBackgroundImage:(UIImage *)image
{
    if (self.navigationBar.background == nil)
    {
        self.navigationBar.background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationBar.subviews.firstObject.bounds), CGRectGetHeight(self.navigationBar.subviews.firstObject.bounds))];
        
        self.navigationBar.background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.navigationBar.subviews.firstObject insertSubview:self.navigationBar.background atIndex:0];
        
        self.navigationBar.tempBackground = [[UIImageView alloc] initWithFrame:self.navigationBar.background.frame];
        
        self.navigationBar.tempBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    self.navigationBar.background.image = image;
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color
{
    if (self.navigationBar.background == nil)
    {
        self.navigationBar.background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationBar.subviews.firstObject.bounds), CGRectGetHeight(self.navigationBar.subviews.firstObject.bounds))];
        
        self.navigationBar.background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.navigationBar.subviews.firstObject insertSubview:self.navigationBar.background atIndex:0];
        
        self.navigationBar.tempBackground = [[UIImageView alloc] initWithFrame:self.navigationBar.background.frame];
        
        self.navigationBar.tempBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    self.navigationBar.background.backgroundColor = color;
}

/// 设置导航栏透明度
- (void)setNavigationBarAlpha:(CGFloat)alpha
{
    self.navigationBar.translucent = !(alpha == 1.0);
    
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
                bgEffectView.alpha = alpha;
            }
        }else
        {
            UIView *adaptiveBackDrop = [barBgView valueForKey:@"_adaptiveBackdrop"];
            UIView *backDropEffectView = [adaptiveBackDrop valueForKey:@"_backdropEffectView"];
            if (adaptiveBackDrop && backDropEffectView)
            {
                backDropEffectView.alpha = alpha;
            }
        }
    }
    self.navigationBar.background.alpha = alpha;
    barBgView.alpha = alpha; // 解决手势返回时，透明Bar页面与不透明bar页面切换会闪烁的问题.
}


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
        
            SEL originalSelector1  = @selector(popToRootViewControllerAnimated:);
            SEL swizzledSelector1  = NSSelectorFromString(@"z_popToRootViewControllerAnimated:");
            [self swizzleOriginalSelector:originalSelector1 withCurrentSelector:swizzledSelector1];
            
            SEL originalSelector2  = @selector(initWithCoder:);
            SEL swizzledSelector2  = NSSelectorFromString(@"z_initWithCoder:");
            [self swizzleOriginalSelector:originalSelector2 withCurrentSelector:swizzledSelector2];
            
            SEL originalSelector3  = @selector(initWithRootViewController:);
            SEL swizzledSelector3  = NSSelectorFromString(@"z_initWithRootViewController:");
            [self swizzleOriginalSelector:originalSelector3 withCurrentSelector:swizzledSelector3];
            
            SEL originalSelector4  = @selector(pushViewController:animated:);
            SEL swizzledSelector4  = NSSelectorFromString(@"z_pushViewController:animated:");
            [self swizzleOriginalSelector:originalSelector4 withCurrentSelector:swizzledSelector4];
    });
}


- (instancetype)z_initWithCoder:(NSCoder *)aDecoder
{
    UINavigationController *nav = [self z_initWithCoder:aDecoder];
    
    nav.delegate = nav;
    
    return nav;
}

- (instancetype)z_initWithRootViewController:(UIViewController *)rootViewController
{
    UINavigationController *nav = [self z_initWithRootViewController:rootViewController];
    
    nav.delegate = nav;
    
    return nav;
}


- (NSArray<UIViewController *> *)z_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<UIViewController *> *poppedViewControllers = [self z_popToRootViewControllerAnimated:animated];
    
    [self updateBarAppearenceWithViewController:self.topViewController];
    
    if ([self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey].barAlpha == 1.0 && [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey].barAlpha == 1.0)
    {
        [self addBarBackgroundTransitionWithType:1];
    }else
    {
        self.navigationBar.backgroundView.background.backgroundColor = self.navigationBar.backgroundView.backgroundColor;
    }
    
    return poppedViewControllers;
}

- (void)z_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self z_pushViewController:viewController animated:YES];
    
    if ([self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey].barAlpha == 1.0 && [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey].barAlpha == 1.0)
    {
        [self addBarBackgroundTransitionWithType:0];
    }
}

#pragma mark- UINavigationBarDelegate
// 点击返回
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    BOOL interactive = [self.topViewController.transitionCoordinator initiallyInteractive];
    
    if (interactive)         // 交互式pop
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

    // 非交互式pop
    NSUInteger itemCount = self.navigationBar.items.count;

    UIViewController *popToVC = self.viewControllers[itemCount - 2];
    
    [self popToViewController:popToVC animated:YES];
    
    [self updateBarAppearenceWithViewController:popToVC];
    
    if ([self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey].barAlpha == 1.0 && [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey].barAlpha == 1.0)
    {
        [self addBarBackgroundTransitionWithType:1];
    }else
    {
        self.navigationBar.backgroundView.background.backgroundColor = self.navigationBar.backgroundView.backgroundColor;
    }
    
    return YES;
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    [self updateBarAppearenceWithViewController:self.topViewController];
    
    if ([self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey].barAlpha != 1.0 || [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey].barAlpha != 1.0)
    {
        self.navigationBar.backgroundView.background.backgroundColor = self.navigationBar.backgroundView.backgroundColor;
    }
    
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers.firstObject)
    {
        self.delegate = nil;
        
        [self updateBarAppearenceWithViewController:viewController];
        
        self.navigationBar.backgroundView.background.backgroundColor = self.navigationBar.backgroundView.backgroundColor;
    }
}


#pragma mark- Methods
/// type:0-->push 1-->pop
- (void)addBarBackgroundTransitionWithType:(NSInteger)type
{
    [self.topViewController.transitionCoordinator animateAlongsideTransitionInView:self.navigationBar.backgroundView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        self.navigationBar.backgroundView.background.transform = type ? CGAffineTransformMakeTranslation(self.navigationBar.backgroundView.frame.size.width, 0) : CGAffineTransformMakeTranslation(-self.navigationBar.backgroundView.frame.size.width, 0);
        
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        self.navigationBar.backgroundView.background.backgroundColor = self.navigationBar.backgroundView.backgroundColor;
        
        self.navigationBar.backgroundView.background.transform = CGAffineTransformIdentity;
    }];
}


- (void)updateBarAppearenceWithViewController:(UIViewController *)viewController
{
    [self setNavigationBarBackgroundColor:viewController.navBarTintColor];
    
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
            
        } else
        {
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
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [self updateBarAppearenceWithViewController:fromVC];
            
        self.navigationBar.backgroundView.background.backgroundColor = fromVC.navBarTintColor;
        
    }else
    {
        UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [self updateBarAppearenceWithViewController:toVC];
            
        self.navigationBar.backgroundView.background.backgroundColor = toVC.navBarTintColor;
    }
}

@end
