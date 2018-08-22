//
//  UINavigationController+extend.h
//  RYTaxiClient
//
//  Created by 讯心科技 on 2017/7/10.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (extend)

- (void)setNavigationBarBackgroundColor:(UIColor *)color animated:(BOOL)animated;

- (void)setNavigationBarBackgroundColor:(UIColor *)color backgroundAlpha:(CGFloat)alpha animated:(BOOL)animated;

- (void)setNavigationBarBackgroundImage:(UIImage *)image animated:(BOOL)animated;

- (void)setNavigationBarBackgroundAlpha:(CGFloat)alpha;

@end

