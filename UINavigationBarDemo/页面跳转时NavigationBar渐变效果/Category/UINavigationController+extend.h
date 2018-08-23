//
//  UINavigationController+extend.h
//  SJNavigationBar
//
//  Created by 讯心科技 on 2017/7/10.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (extend)

- (void)setNavigationBarBackgroundColor:(UIColor *)color;

- (void)setNavigationBarBackgroundColor:(UIColor *)color backgroundAlpha:(CGFloat)alpha;

- (void)setNavigationBarBackgroundImage:(UIImage *)image;

- (void)setNavigationBarBackgroundAlpha:(CGFloat)alpha;

@end

