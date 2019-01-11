//
//  UIColor+Hex.h
//  testDemo1
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//


/*********************************************************************************/
/*
    从十六进制字符串获取颜色，
    color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
/*********************************************************************************/


#import <UIKit/UIKit.h>

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface UIColor (JSHex)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
