//
//  MBProgressHUD+JASON.h
//  MeiyaoniKH
//
//  Created by Jason on 17/5/5.
//  Copyright © 2017年 ainisi. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (JASON)

//显示图标与信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showSuccess:(NSString *)succes;
+ (void)showError:(NSString *)error;


//只显示提示信息
+ (void)showTips:(NSString *)tips toView:(UIView *)view;
+ (void)showTips:(NSString *)tips;



//显示加载动画
+ (MBProgressHUD *)showHUDwithMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showHUDwithMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

- (void)hide;

@end
