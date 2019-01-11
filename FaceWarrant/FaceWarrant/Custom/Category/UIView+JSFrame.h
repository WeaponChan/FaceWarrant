//
//  UIView+JSFrame.h
//  MeiyaoniKH
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 ainisi. All rights reserved.
//


/*********************************************************************************/
/*
    这个分类的作用，用于简化frame相关属性的访问和设置
 */
/*********************************************************************************/

#import <UIKit/UIKit.h>

@interface UIView (JSFrame)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, readonly) CGFloat bottom;
@end
