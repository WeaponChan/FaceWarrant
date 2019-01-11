//
//  UIAlertController+JSAlert.h
//  MeiyaoniJS
//
//  Created by Jason on 16/12/22.
//  Copyright © 2016年 ainisi. All rights reserved.
//


/*********************************************************************************/
/*
    封装了UIAlertController最基础的两种弹窗的使用，免去繁琐的创建步骤
 */
/*********************************************************************************/


#import <UIKit/UIKit.h>

@interface UIAlertController (JSAlert)
//@property (nonatomic, copy) HandlerBlock handler;


/**
 创建只有一个默认action的alertView
 */
+ (void)js_alertAviewWithTarget:(id)target
                  andAlertTitle:(NSString *)aTitle
                     andMessage:(NSString *)message
          andDefaultActionTitle:(NSString *)dTitle
                        Handler:(void(^)(UIAlertAction *action))handler
                     completion:(void(^)(void))completion;


/**
 创建有一个 default 和 cancel 的alertView
 */
+ (void)js_alertAviewWithTarget:(id)target
                  andAlertTitle:(NSString *)aTitle
                     andMessage:(NSString *)message
          andDefaultActionTitle:(NSString *)dTitle
                       dHandler:(void(^)(UIAlertAction *action))dhandler
           andCancelActionTitle:(NSString *)cTitle
                       cHandler:(void(^)(UIAlertAction *action))chandler
                     completion:(void(^)(void))completion;


@end
