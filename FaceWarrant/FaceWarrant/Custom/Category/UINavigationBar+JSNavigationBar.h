//
//  UINavigationBar+JSNavigationBar.h
//  MeiyaoniKH
//
//  Created by Jason on 16/8/28.
//  Copyright © 2016年 ainisi. All rights reserved.
//


/*********************************************************************************/
/*
 导航栏的相关设置
 */
/*********************************************************************************/


#import <UIKit/UIKit.h>

@interface UINavigationBar (JSNavigationBar)

/**
 设置全局导航栏样式
 */
- (void)js_setCustomNavigationBarStyle;


/**
 设置导航栏透明
 */
- (void)js_setNavigationBarTransparent;


/**
 隐藏导航栏
 */
- (void)js_hideNavigationBar;


/**
 在导航栏的位置添加一个相同大小的背景view
 */
+ (UIView *)js_addNVBarMaskViewWithSuperView:(UIView *)superView viewColor:(UIColor *)color alpha:(CGFloat)alpha;

@end
