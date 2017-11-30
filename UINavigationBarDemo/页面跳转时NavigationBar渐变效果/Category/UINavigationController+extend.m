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


@interface BarBackgroundView : UIView

@property (nonatomic, strong) UIView *background;

@end



@implementation BarBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.background = [[UIView alloc] initWithFrame:frame];
        
        self.background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:self.background];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.background.backgroundColor = backgroundColor;
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    
    self.background.alpha = alpha;
}

@end



static const char *backgroundViewKey = "backgroundViewKey";

@interface UINavigationBar (extend)

@property (nonatomic, strong) BarBackgroundView *backgroundView;

@end


@implementation UINavigationBar (extend)

- (BarBackgroundView *)backgroundView
{
    return objc_getAssociatedObject(self, backgroundViewKey);
}

- (void)setBackgroundView:(BarBackgroundView *)backgroundView
{
    objc_setAssociatedObject(self, backgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UINavigationController (extend)

- (void)setNavigationBarBackgroundColor:(UIColor *)color
{
    if (self.navigationBar.backgroundView == nil)
    {
        self.navigationBar.backgroundView = [[BarBackgroundView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationBar.subviews.firstObject.bounds), CGRectGetHeight(self.navigationBar.subviews.firstObject.bounds))];
        
        self.navigationBar.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.navigationBar.subviews.firstObject insertSubview:self.navigationBar.backgroundView atIndex:0];
    }
    
    self.navigationBar.backgroundView.backgroundColor = color;
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
    self.navigationBar.backgroundView.alpha = alpha;
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
        
        if (self == [UINavigationController class])
        {
            SEL originalSelector1  = NSSelectorFromString(@"_updateInteractiveTransition:");
            SEL swizzledSelector1  = NSSelectorFromString(@"z_updateInteractiveTransition:");
            [self swizzleOriginalSelector:originalSelector1 withCurrentSelector:swizzledSelector1];
            
            SEL originalSelector2  = @selector(popToRootViewControllerAnimated:);
            SEL swizzledSelector2  = NSSelectorFromString(@"z_popToRootViewControllerAnimated:");
            [self swizzleOriginalSelector:originalSelector2 withCurrentSelector:swizzledSelector2];
            
            SEL originalSelector3  = @selector(initWithCoder:);
            SEL swizzledSelector3  = NSSelectorFromString(@"z_initWithCoder:");
            [self swizzleOriginalSelector:originalSelector3 withCurrentSelector:swizzledSelector3];
            
            SEL originalSelector4  = @selector(initWithRootViewController:);
            SEL swizzledSelector4  = NSSelectorFromString(@"z_initWithRootViewController:");
            [self swizzleOriginalSelector:originalSelector4 withCurrentSelector:swizzledSelector4];
        }
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

- (void)z_updateInteractiveTransition:(CGFloat)percentComplete
{
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
        
        [self setNavigationBarBackgroundColor:newColor];
        
        [self setNavigationBarAlpha:alpha];
        
        [self updateStatusBarStyleWithViewController:toVC];
    }
    
    [self z_updateInteractiveTransition:percentComplete];
}


- (NSArray<UIViewController *> *)z_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<UIViewController *> *poppedViewControllers = [self z_popToRootViewControllerAnimated:animated];
    
    if (self.topViewController.barAlpha == 1.0)
    {
        [self addBarBackgroundLayerTransitionWithType:1];
    }
    
    [self updateBarAppearenceWithViewController:self.topViewController];
    
    return poppedViewControllers;
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
    
    if (self.topViewController.barAlpha == 1.0)
    {
        [self addBarBackgroundLayerTransitionWithType:1];
    }

    [self updateBarAppearenceWithViewController:popToVC];
    
    return YES;
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    if (self.topViewController.barAlpha == 1.0)
    {
        [self addBarBackgroundLayerTransitionWithType:0];
    }

    [self updateBarAppearenceWithViewController:self.topViewController];
    
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers.firstObject)
    {
        self.delegate = nil;
        [self updateBarAppearenceWithViewController:viewController];
    }
}


#pragma mark- Methods
/// type:0-->push 1-->pop
- (void)addBarBackgroundLayerTransitionWithType:(NSInteger)type
{
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.35;
    if (type == 0)
    {
        transition.type     = kCATransitionReveal;
        transition.subtype  = kCATransitionFromRight;
    }else
    {
        transition.type     = kCATransitionReveal;
        transition.subtype  = kCATransitionFromLeft;
    }
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [self.navigationBar.backgroundView.background.layer addAnimation:transition forKey:@"ColorFade"];
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
