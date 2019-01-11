//
//  UIBarButtonItem+JSCustomItem.h
//  MeiyaoniKH
//
//  Created by Jason on 16/10/18.
//  Copyright © 2016年 ainisi. All rights reserved.
//

/*********************************************************************************/
/*
   快速创建UIBarButtonItem，免去繁琐的创建步骤
 */
/*********************************************************************************/


#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JSCustomItem)

/**
 设置图片按钮

 @param image 常规图片
 @param highImage 高亮图片
 @param target 点击事件接受者，一般是控制器
 @param action 点击事件方法名
 @return instance
 */
+ (instancetype)js_itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;


/**
 设置文字按钮
 
 @param title 按钮文字
 @param target 点击事件接受者，一般是控制器
 @param action 点击事件方法名
 @return instance
 */
+ (instancetype)js_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
