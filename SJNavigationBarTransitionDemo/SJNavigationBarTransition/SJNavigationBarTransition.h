//
//  SJNavigationBarTransition.h
//  SJNavigationBarTransition
//
//  Created by 如约科技 on 2017/7/10.
//  Copyright © 2017年 如约科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (z_extend)

/// 设置全局导航栏背景颜色
- (void)setNavigationBarBackgroundColor:(UIColor *)color;

/// 设置全局导航栏背景颜色和透明度
- (void)setNavigationBarBackgroundColor:(UIColor *)color backgroundAlpha:(CGFloat)alpha;

/// 设置全局导航栏背景图片
- (void)setNavigationBarBackgroundImage:(UIImage *)image;

/// 实时更新导航栏透明度
- (void)updateNavigationBarBackgroundAlpha:(CGFloat)alpha;

@end

