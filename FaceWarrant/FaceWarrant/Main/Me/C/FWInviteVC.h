//
//  FWInviteVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/12.
//  Copyright © 2018年 LHKH. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface WebviewProgressLine : UIView
//进度条颜色
@property (nonatomic,strong) UIColor  *lineColor;
//开始加载
-(void)startLoadingAnimation;
//结束加载
-(void)endLoadingAnimation;
@end


#import "FWBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSObjectDelegate <JSExport>
//-(void)OC_JSClick:(NSString*)flag;//原生调用js方法
-(void)JS_OCClick:(NSString*)flag;//js调用原生方法
@end
@interface FWInviteVC : FWBaseViewController
@property(copy, nonatomic)NSString *name;
@property(copy, nonatomic)NSString *point;
@end
