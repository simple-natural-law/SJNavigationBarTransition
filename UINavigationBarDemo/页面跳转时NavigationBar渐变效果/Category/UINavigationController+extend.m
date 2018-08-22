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


typedef NS_ENUM(NSInteger, UINavigationBarBackgroundAnimationType) {
    
    UINavigationBarBackgroundAnimationTypeNone = 0,
    UINavigationBarBackgroundAnimationTypePush = 1,
    UINavigationBarBackgroundAnimationTypePop  = 2
};


static char * const backgroundKey = "backgroundKey";
//static char * const transitionBackgroundKey = "transitionBackgroundKey";


@interface UINavigationBar (extend)

@property (nonatomic, strong) UIImageView *background;

//@property (nonatomic, strong) UIImageView *transitionBackground;

@end


@implementation UINavigationBar (extend)

- (void)setBackground:(UIImageView *)background
{
    objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)background
{
    return objc_getAssociatedObject(self, backgroundKey);
}

//- (void)setTransitionBackground:(UIImageView *)transitionBackground
//{
//    objc_setAssociatedObject(self, transitionBackgroundKey, transitionBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UIImageView *)transitionBackground
//{
//    return objc_getAssociatedObject(self, transitionBackgroundKey);
//}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
//        self.transitionBackground = [[UIImageView alloc] init];
//
//        self.transitionBackground.hidden = YES;
//
//        self.transitionBackground.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
//
//        [self.subviews.firstObject insertSubview:self.transitionBackground atIndex:1];
    }
    
    return self;
}

- (void)setBackgroundImage:(UIImage *)image andAlpha:(CGFloat)alpha withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)transitionCoordinator animation:(UINavigationBarBackgroundAnimationType)animation
{
    switch (animation)
    {
        case UINavigationBarBackgroundAnimationTypeNone:
        {

        }
            break;
            
        case UINavigationBarBackgroundAnimationTypePush:
        {
            
            [transitionCoordinator animateAlongsideTransitionInView:self.subviews.firstObject animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                
                
            } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
              
            }];
        }
            break;
            
        case UINavigationBarBackgroundAnimationTypePop:
        {
            
        }
            break;
            
        default:
            break;
    }
}


- (void)setBackgroundImage:(UIImage *)image alpha:(CGFloat)alpha withAnimation:(UINavigationBarBackgroundAnimationType)animation
{
    switch (animation)
    {
        case UINavigationBarBackgroundAnimationTypeNone:
        {
            
        }
            break;
            
        case UINavigationBarBackgroundAnimationTypePush:
        {
            
        }
            break;
            
        case UINavigationBarBackgroundAnimationTypePop:
        {
            
        }
            break;
            
        default:
            break;
    }
}

@end


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


static char * const animatedKey = "animatedKey";
static char * const isPushKey = "isPushKey";
static char * const navigationBarAlphaKey = "navigationBarAlphaKey";
static char * const navigationBarBackgroundColorKey = "navigationBarBackgroundColorKey";
static char * const navigationBarBackgroundImageKey = "navigationBarBackgroundImageKey";

@interface UINavigationController  ()<UINavigationBarDelegate,UINavigationControllerDelegate>

/// 是否动画设置导航栏背景颜色或者背景图片
@property (nonatomic, assign) BOOL animated;

/// 当前呈现视图控制器的方式是否是`push`
@property (nonatomic, assign) BOOL isPush;

/// 导航栏透明度
@property (nonatomic, assign) CGFloat navigationBarAlpha;

/// 导航栏背景色
@property (nonatomic, strong) UIColor *navigationBarBackgroundColor;

/// 导航栏背景图片
@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;

@end

@implementation UINavigationController (extend)

- (void)setNavigationBarBackgroundColor:(UIColor *)color animated:(BOOL)animated
{
    [self setNavigationBarBackgroundColor:color backgroundAlpha:1.0 animated:animated];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color backgroundAlpha:(CGFloat)alpha animated:(BOOL)animated
{
    self.navigationBarAlpha = alpha;
    
    self.navigationBarBackgroundColor = color;
    
    self.navigationBarBackgroundImage = nil;
    
    self.animated = animated;
}

- (void)setNavigationBarBackgroundImage:(UIImage *)image animated:(BOOL)animated
{
    self.navigationBarBackgroundImage = image;
    
    self.animated = animated;
}


- (void)setNavigationBarBackgroundAlpha:(CGFloat)alpha
{
    UIView *barBgView = self.navigationBar.subviews.firstObject;
    
    barBgView.alpha = alpha;
    
    if (self.navigationBar.translucent)
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
    
    UIView *shadow = [self.navigationBar.subviews.firstObject valueForKey:@"_shadowView"];
    
    shadow.hidden = (alpha == 0.0);
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
    SEL initWithCoder    = @selector(initWithCoder:);
    SEL z_initWithCoder  = NSSelectorFromString(@"z_initWithCoder:");
    [self swizzleOriginalSelector:initWithCoder withCurrentSelector:z_initWithCoder];
    
    SEL initWithRootViewController    = @selector(initWithRootViewController:);
    SEL z_initWithRootViewController  = NSSelectorFromString(@"z_initWithRootViewController:");
    [self swizzleOriginalSelector:initWithRootViewController withCurrentSelector:z_initWithRootViewController];
    
    SEL shouldPopItem    = @selector(navigationBar:shouldPopItem:);
    SEL z_shouldPopItem  = NSSelectorFromString(@"z_navigationBar:shouldPopItem:");
    [self swizzleOriginalSelector:shouldPopItem withCurrentSelector:z_shouldPopItem];
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


#pragma mark- UINavigationBarDelegate
// 官方已经实现了这个委托方法，这里使用方法交换来添加所需的额外操作。
- (BOOL)z_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    NSLog(@"shouldPopItem");
    
    self.isPush = NO;
    
    BOOL shouldPop = [self z_navigationBar:navigationBar shouldPopItem:item];
    
    if (self.topViewController.transitionCoordinator.interactive)
    {
        if (@available(iOS 10.0, *))
        {
            [self.topViewController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                [self dealInteractionChanges:context];
            }];
            
        }else
        {
            [self.topViewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                
                [self dealInteractionChanges:context];
            }];
        }
    }
    
    return shouldPop;
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    NSLog(@"shouldPushItem");
    
    self.isPush = YES;
    
    return YES;
}


#pragma mark- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController");
    
    if (!self.navigationBar.background)
    {
        self.navigationBar.background = [[UIImageView alloc] init];
        
        self.navigationBar.background.image = self.navigationBarBackgroundImage;
        
        self.navigationBar.background.backgroundColor = self.navigationBarBackgroundColor;
        
        self.navigationBar.background.alpha = self.navigationBarAlpha;
        
        self.navigationBar.background.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *barBackgroundView = self.navigationBar.subviews.firstObject;
        
        [barBackgroundView insertSubview:self.navigationBar.background atIndex:0];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.navigationBar.background attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.navigationBar.background attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.navigationBar.background attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.navigationBar.background attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        
        [barBackgroundView addConstraints:@[top, bottom, left, right]];
        
    }else
    {
        
    }
}


#pragma mark- Methods
- (void)updateStatusBarStyleWithViewController:(UIViewController *)viewController
{
    if (viewController.navigationBarAlpha == 0)
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
        if ([self colorBrigntness:viewController.navigationBarBackgroundColor] > 0.5)
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

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context
{
    if ([context isCancelled])
    {
        UIViewController *vc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        
    }
}


#pragma mark- setter and getter
- (void)setAnimated:(BOOL)animated
{
    objc_setAssociatedObject(self, animatedKey, @(animated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)animated
{
    id animated = objc_getAssociatedObject(self, animatedKey);
    
    return [animated boolValue];
}

- (void)setIsPush:(BOOL)isPush
{
    objc_setAssociatedObject(self, isPushKey, @(isPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPush
{
    id isPush = objc_getAssociatedObject(self, isPushKey);
    
    return [isPush boolValue];
}

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
