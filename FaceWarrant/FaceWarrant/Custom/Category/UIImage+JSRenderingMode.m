//
//  UIImage+JSRenderingMode.m
//  testDemo1
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIImage+JSRenderingMode.h"

@implementation UIImage (JSRenderingMode)

+ (UIImage *)js_renderingModelOriginalWithImageName:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+ (UIImage *)js_renderingModelOriginalWithImage:(UIImage *)image
{
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


@end
