//
//  UIImage+JSRenderingMode.h
//  testDemo1
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JSRenderingMode)
/** 禁止系统渲染图片 */
+ (UIImage *)js_renderingModelOriginalWithImageName:(NSString *)imageName;
+ (UIImage *)js_renderingModelOriginalWithImage:(UIImage *)image;
@end
