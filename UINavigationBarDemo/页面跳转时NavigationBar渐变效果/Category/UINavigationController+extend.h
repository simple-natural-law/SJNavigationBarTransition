//
//  UINavigationController+extend.h
//  RYTaxiClient
//
//  Created by 讯心科技 on 2017/7/10.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (extend)<UINavigationBarDelegate>


/**
 设置导航栏透明度

 @param alpha 透明度
 */
- (void)setNavigationBarAlpha:(CGFloat)alpha;

@end
