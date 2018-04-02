//
//  UIViewController+Bar.h
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Bar)

@property (nonatomic, strong) UIView *navBar;

/// 视图控制器对应的导航栏透明度
@property (nonatomic, assign) CGFloat barAlpha;

/// 视图控制器对应的导航栏背景色
@property (nonatomic, strong) UIColor *navBarBackgroundColor;

/// 视图控制器对应的导航栏背景色
@property (nonatomic, strong) UIImage *navBarBackgroundImage;

@end
