//
//  UIButton+Lhkh.m
//  UEHTML
//
//  Created by LHKH on 2017/10/2.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "UIButton+Lhkh.h"
@implementation UIButton (Lhkh)
//居中
- (void)centerImageAndTitleWithSpace:(float)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = imageSize.height + titleSize.height + space;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0, 0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

//左右调换
- (void)changeImageAndTitle {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width-10);
    self.titleEdgeInsets = UIEdgeInsetsMake(0 , -imageSize.width , 0 ,imageSize.width);
}


- (void)centerImageAndTitle {
    const int DEFAULT_SPACE = 0.0f;
    [self centerImageAndTitleWithSpace:DEFAULT_SPACE];
}


- (void)lhkh_setButtonImageWithUrl:(NSString *)urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    // 根据图片的url下载图片数据
    dispatch_queue_t xrQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(xrQueue, ^{
        
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        UIImage *targetImage = [self originImage:img scaleToSize:CGSizeMake(15, 15)];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:targetImage forState:UIControlStateNormal];
        });
    });
}

-(UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
