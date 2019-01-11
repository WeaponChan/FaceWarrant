//
//  UINavigationBar+JSNavigationBar.m
//  MeiyaoniKH
//
//  Created by Jason on 16/8/28.
//  Copyright © 2016年 ainisi. All rights reserved.
//

#import "UINavigationBar+JSNavigationBar.h"
#import "UIColor+Hex.h"
#import "UIView+JSFrame.h"
#import "Macro_Device.h"

@implementation UINavigationBar (JSNavigationBar)

- (void)js_setCustomNavigationBarStyle
{
    //代码绘制纯色image
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, NavigationBar_H);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"f7f7f7"] colorWithAlphaComponent:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置backgroundImage
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   
    
    self.translucent = YES;
  
    
    //设置标题字体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#333333"];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
 
    [self setTitleTextAttributes:dict];
    
    [self setShadowImage:[UIImage new]];
}



- (void)js_setNavigationBarTransparent
{
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
}


- (void)js_hideNavigationBar
{
    [self setHidden:YES];
}



+ (UIView *)js_addNVBarMaskViewWithSuperView:(UIView *)superView viewColor:(UIColor *)color alpha:(CGFloat)alpha
{
    CGPoint winPoint = CGPointMake(0, 0);
    winPoint = [[UIApplication sharedApplication].keyWindow.window convertPoint:winPoint toView:superView];
    
    for (UIView *subview in superView.subviews) {
        if (subview.tag == 100) {
            return nil;
        }
    }
    
    
    UIView *navigationBarTmpMaskView = [[UIView alloc] initWithFrame:CGRectMake(winPoint.x, winPoint.y, Screen_W, NavigationBar_H)];
    [navigationBarTmpMaskView setBackgroundColor:color];
    navigationBarTmpMaskView.alpha = alpha;
    navigationBarTmpMaskView.tag = 100;
    
    [superView addSubview:navigationBarTmpMaskView];

    return navigationBarTmpMaskView;
}

@end
