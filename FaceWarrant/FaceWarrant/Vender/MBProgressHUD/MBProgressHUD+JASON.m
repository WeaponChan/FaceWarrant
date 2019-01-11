//
//  MBProgressHUD+JASON.m
//  MeiyaoniKH
//
//  Created by Jason on 17/5/5.
//  Copyright © 2017年 ainisi. All rights reserved.
//

#import "MBProgressHUD+JASON.h"

@implementation MBProgressHUD (JASON)

static const MBProgressHUD *hud;

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        
        for(UIWindow *window in [windows reverseObjectEnumerator]) {
            
            if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
                
                view = window;
            }
        }
        
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    // 快速显示一个提示信息
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    if (icon == nil) {
        hud.margin = 15;
    }

    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15.0];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    [hud hideAnimated:YES afterDelay:2];
}



+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"warning.png" view:view];
}

+ (void)showSuccess:(NSString *)succes
{
    [self showSuccess:succes toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}



+ (void)showTips:(NSString *)tips toView:(UIView *)view
{
    [self show:tips icon:nil view:view];
    
    CGFloat offsetY = -(Screen_H*0.5 - 300);
    
    
    [hud setOffset:CGPointMake(0.f, offsetY)];
}

+ (void)showTips:(NSString *)tips
{
    [self showTips:tips toView:nil];
}



+ (MBProgressHUD *)showHUDwithMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        
        for(UIWindow *window in [windows reverseObjectEnumerator]) {
            
            if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
                
                view = window;
            }
        }
        
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    hud.userInteractionEnabled = YES;
    return hud;
}

+ (MBProgressHUD *)showHUDwithMessage:(NSString *)message
{
    return [self showHUDwithMessage:message toView:nil];
}



+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

- (void)hide
{
    [self hideAnimated:YES];
}

@end
