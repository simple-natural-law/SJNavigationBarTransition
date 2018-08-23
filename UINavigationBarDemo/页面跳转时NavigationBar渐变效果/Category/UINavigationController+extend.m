//
//  UINavigationController+extend.m
//  SJNavigationBar
//
//  Created by 讯心科技 on 2017/7/10.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "UINavigationController+extend.h"
#import <objc/runtime.h>


typedef NS_ENUM(NSInteger, UINavigationBarBackgroundAnimationType) {
    
    UINavigationBarBackgroundAnimationTypeNone = 0,
    UINavigationBarBackgroundAnimationTypePush = 1,
    UINavigationBarBackgroundAnimationTypePop  = 2
};


static char * const backgroundKey = "backgroundKey";


@interface UINavigationBar (extend)

@property (nonatomic, strong) UIImageView *background;

@end


@implementation UINavigationBar (extend)


- (void)installBackground
{
    self.background = [[UIImageView alloc] init];
    
    self.background.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *barBackgroundView = self.subviews.firstObject;
    
    [barBackgroundView insertSubview:self.background atIndex:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:barBackgroundView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    
    [barBackgroundView addConstraints:@[top, bottom, left, right]];
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

#pragma mark- Setter And Getter
- (void)setBackground:(UIImageView *)background
{
    objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)background
{
    return objc_getAssociatedObject(self, backgroundKey);
}

@end


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


static char * const navigationBarBackgroundDidChangedKey = "navigationBarBackgroundDidChangedKey";
static char * const animatedKey = "animatedKey";
static char * const isPushKey   = "isPushKey";
static char * const navigationBarAlphaKey = "navigationBarAlphaKey";
static char * const navigationBarColorKey = "navigationBarColorKey";
static char * const navigationBarImageKey = "navigationBarImageKey";

@interface UINavigationController  ()<UINavigationBarDelegate,UINavigationControllerDelegate>

/// 是否需要重新设置导航栏背景颜色或者背景图片
@property (nonatomic, assign) BOOL navigationBarBackgroundDidChanged;

/// 是否动画设置导航栏背景颜色或者背景图片
@property (nonatomic, assign) BOOL animated;

/// 当前呈现视图控制器的方式是否是`push`
@property (nonatomic, assign) BOOL isPush;

/// 导航栏透明度
@property (nonatomic, assign) CGFloat navigationBarAlpha;

/// 导航栏背景色
@property (nonatomic, strong) UIColor *navigationBarColor;

/// 导航栏背景图片
@property (nonatomic, strong) UIImage *navigationBarImage;

@end

@implementation UINavigationController (extend)

- (void)setNavigationBarBackgroundColor:(UIColor *)color
{
    [self setNavigationBarBackgroundColor:color backgroundAlpha:1.0];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color backgroundAlpha:(CGFloat)alpha
{
    self.navigationBarAlpha = alpha;
    
    self.navigationBarColor = color;
    
    self.navigationBarImage = nil;
    
    self.navigationBarBackgroundDidChanged = YES;
}

- (void)setNavigationBarBackgroundImage:(UIImage *)image
{
    self.navigationBarImage = image;
    
    self.navigationBarBackgroundDidChanged = YES;
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
    
    shadow.alpha = alpha;
}


#pragma mark- Method Swizzling
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
    SEL z_initWithCoder  = @selector(z_initWithCoder:);
    [self swizzleOriginalSelector:initWithCoder withCurrentSelector:z_initWithCoder];
    
    SEL initWithRootViewController    = @selector(initWithRootViewController:);
    SEL z_initWithRootViewController  = @selector(z_initWithRootViewController:);
    [self swizzleOriginalSelector:initWithRootViewController withCurrentSelector:z_initWithRootViewController];
    
    SEL popToViewController    = @selector(popToViewController:animated:);
    SEL z_popToViewController  = @selector(z_popToViewController:animated:);
    [self swizzleOriginalSelector:popToViewController withCurrentSelector:z_popToViewController];
    
    SEL popViewControllerAnimated    = @selector(popViewControllerAnimated:);
    SEL z_popViewControllerAnimated  = @selector(z_popViewControllerAnimated:);
    [self swizzleOriginalSelector:popViewControllerAnimated withCurrentSelector:z_popViewControllerAnimated];
    
    SEL popToRootViewControllerAnimated    = @selector(popToRootViewControllerAnimated:);
    SEL z_popToRootViewControllerAnimated  = @selector(z_popToRootViewControllerAnimated:);
    [self swizzleOriginalSelector:popToRootViewControllerAnimated withCurrentSelector:z_popToRootViewControllerAnimated];
    
    SEL pushViewController    = @selector(pushViewController:animated:);
    SEL z_pushViewController  = @selector(z_pushViewController:animated:);
    [self swizzleOriginalSelector:pushViewController withCurrentSelector:z_pushViewController];
    
    
    SEL shouldPopItem    = @selector(navigationBar:shouldPopItem:);
    SEL z_shouldPopItem  = @selector(z_navigationBar:shouldPopItem:);
    [self swizzleOriginalSelector:shouldPopItem withCurrentSelector:z_shouldPopItem];
}


#pragma mark- init
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


- (UIViewController *)z_popViewControllerAnimated:(BOOL)animated
{
    NSLog(@"z_popViewControllerAnimated");
    
    self.animated = animated;
    
    self.isPush = NO;
    
    return [self z_popViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)z_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"z_popToViewController");
    
    self.animated = animated;
    
    self.isPush = NO;
    
    return [self z_popToViewController:viewController animated:animated];
}


- (NSArray<UIViewController *> *)z_popToRootViewControllerAnimated:(BOOL)animated
{
    NSLog(@"z_popToRootViewControllerAnimated");
    
    self.animated = animated;
    
    self.isPush = NO;
    
    return [self z_popToRootViewControllerAnimated:animated];
}


- (void)z_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"z_pushViewController");
    
    self.animated = animated;
    
    self.isPush = YES;
    
    [self z_pushViewController:viewController animated:animated];
}




#pragma mark- UINavigationBarDelegate
// 官方已经实现了这个委托方法，这里使用方法交换来添加所需的额外操作。
- (BOOL)z_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    NSLog(@"shouldPopItem");
    
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


#pragma mark- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController");
    
    if (!self.navigationBar.background)
    {
        [self.navigationBar installBackground];
        
        self.navigationBar.background.image = self.navigationBarImage;
        
        self.navigationBar.background.backgroundColor = self.navigationBarColor;
        
        self.navigationBar.background.alpha = self.navigationBarAlpha;
        
    }else
    {
        if (self.animated)
        {
            if (self.navigationBarImage)
            {
                UIImageView *tempBackground = [[UIImageView alloc] initWithFrame:self.navigationBar.background.frame];
                
                CGAffineTransform transformA = CGAffineTransformMakeTranslation(tempBackground.frame.size.width, 0.0);
                
                CGAffineTransform transformB = CGAffineTransformMakeTranslation(-tempBackground.frame.size.width, 0.0);
                
                tempBackground.transform = self.isPush ? transformA : transformB;
                
                tempBackground.image = self.navigationBarImage;
                
                tempBackground.backgroundColor = self.navigationBarColor;
                
                tempBackground.alpha = self.navigationBarAlpha;
                
                [self.navigationBar.subviews.firstObject insertSubview:tempBackground atIndex:1];
                
                [self.topViewController.transitionCoordinator animateAlongsideTransitionInView:self.navigationBar animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    
                    tempBackground.transform = CGAffineTransformIdentity;
                    
                    self.navigationBar.background.transform = self.isPush ? transformB : transformA;
                    
                } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    
                    self.navigationBar.background.image = self.navigationBarImage;
                    
                    self.navigationBar.background.backgroundColor = self.navigationBarColor;
                    
                    self.navigationBar.background.alpha = self.navigationBarAlpha;
                    
                    self.navigationBar.background.transform = CGAffineTransformIdentity;
                    
                    [tempBackground removeFromSuperview];
                }];
                
            }else
            {
                UIView *tempBackground = [[UIView alloc] initWithFrame:self.navigationBar.background.frame];
                
                CGAffineTransform transformA = CGAffineTransformMakeTranslation(tempBackground.frame.size.width, 0.0);
                
                CGAffineTransform transformB = CGAffineTransformMakeTranslation(-tempBackground.frame.size.width, 0.0);
                
                tempBackground.transform = self.isPush ? transformA : transformB;
                
                tempBackground.backgroundColor = self.navigationBarColor;
                
                tempBackground.alpha = self.navigationBarAlpha;
                
                [self.navigationBar.subviews.firstObject insertSubview:tempBackground atIndex:1];
                
                [self.topViewController.transitionCoordinator animateAlongsideTransitionInView:self.navigationBar animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    
                    tempBackground.transform = CGAffineTransformIdentity;
                    
                    self.navigationBar.background.transform = self.isPush ? transformB : transformA;
                    
                } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    
                    self.navigationBar.background.image = self.navigationBarImage;
                    
                    self.navigationBar.background.backgroundColor = self.navigationBarColor;
                    
                    self.navigationBar.background.alpha = self.navigationBarAlpha;
                    
                    self.navigationBar.background.transform = CGAffineTransformIdentity;
                    
                    [tempBackground removeFromSuperview];
                }];
            }
        }else
        {
            self.navigationBar.background.image = self.navigationBarImage;
            
            self.navigationBar.background.backgroundColor = self.navigationBarColor;
            
            self.navigationBar.background.alpha = self.navigationBarAlpha;
        }
    }
}


#pragma mark-
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


#pragma mark- Setter And Getter
- (void)setNavigationBarBackgroundDidChanged:(BOOL)navigationBarBackgroundDidChanged
{
    objc_setAssociatedObject(self, navigationBarBackgroundDidChangedKey, @(navigationBarBackgroundDidChanged), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)navigationBarBackgroundDidChanged
{
    id navigationBarBackgroundDidChanged = objc_getAssociatedObject(self, navigationBarBackgroundDidChangedKey);
    
    return [navigationBarBackgroundDidChanged boolValue];
}

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

- (void)setNavigationBarColor:(UIColor *)navigationBarColor
{
    objc_setAssociatedObject(self, navigationBarColorKey, navigationBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarColor
{
    UIColor *color = objc_getAssociatedObject(self, navigationBarColorKey);
    
    if (color == NULL)
    {
        return [UIColor whiteColor];
    }else
    {
        return color;
    }
}

- (void)setNavigationBarImage:(UIImage *)navigationBarImage
{
    objc_setAssociatedObject(self, navigationBarImageKey, navigationBarImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)navigationBarImage
{
    UIImage *image = objc_getAssociatedObject(self, navigationBarImageKey);
    
    if (image == NULL)
    {
        return nil;
    }else
    {
        return image;
    }
}


@end
