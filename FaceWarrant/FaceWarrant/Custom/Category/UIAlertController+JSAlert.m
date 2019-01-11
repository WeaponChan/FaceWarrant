//
//  UIAlertController+JSAlert.m
//  MeiyaoniJS
//
//  Created by Jason on 16/12/22.
//  Copyright © 2016年 ainisi. All rights reserved.
//

#import "UIAlertController+JSAlert.h"

@implementation UIAlertController (JSAlert)


+ (void)js_alertAviewWithTarget:(id)target andAlertTitle:(NSString *)aTitle andMessage:(NSString *)message andDefaultActionTitle:(NSString *)dTitle dHandler:(void (^)(UIAlertAction *))dhandler andCancelActionTitle:(NSString *)cTitle cHandler:(void (^)(UIAlertAction *))chandler completion:(void (^)(void))completion
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:aTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a = [UIAlertAction actionWithTitle:dTitle style:UIAlertActionStyleDefault handler:dhandler];
    [alertC addAction:a];
    
    UIAlertAction *c = [UIAlertAction actionWithTitle:cTitle style:UIAlertActionStyleCancel handler:chandler];
    [alertC addAction:c];
    
    [target presentViewController:alertC animated:YES completion:completion];
}



+ (void)js_alertAviewWithTarget:(id)target andAlertTitle:(NSString *)aTitle andMessage:(NSString *)message andDefaultActionTitle:(NSString *)dTitle Handler:(void (^)(UIAlertAction *))handler completion:(void (^)(void))completion
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:aTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a = [UIAlertAction actionWithTitle:dTitle style:UIAlertActionStyleDefault handler:handler];
    [alertC addAction:a];
    
    [target presentViewController:alertC animated:YES completion:completion];
}

@end
