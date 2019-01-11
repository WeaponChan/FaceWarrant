//
//  WaterRippleView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterRippleView : UIView
@property (nonatomic, strong)UIColor *mainRippleColor;//主波填充颜色
@property (nonatomic, strong)UIColor *minorRippleColor;//次波填充颜色
@property (nonatomic, assign)CGFloat mainRippleoffsetX;//主波偏移量
@property (nonatomic, assign)CGFloat minorRippleoffsetX;//次波偏移量
@property (nonatomic, assign)CGFloat rippleSpeed;//波浪速度
@property (nonatomic, assign)CGFloat ripplePosition;//波浪Y轴位置
@property (nonatomic, assign)float rippleAmplitude;//波浪振幅


/**
  初始化水纹波浪View  单个波浪

 @param frame 设置frame
 @param mainRippleColor 主波填充颜色
 @param minorRippleColor 次波填充颜色
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame mainRippleColor:(UIColor *)mainRippleColor minorRippleColor:(UIColor *)minorRippleColor;

/**
 初始化水纹波浪View  两个波浪

 @param frame 设置frame
 @param mainRippleColor 主波填充颜色
 @param minorRippleColor 次波填充颜色
 @param mainRippleoffsetX 主波偏移量
 @param minorRippleoffsetX 次波偏移量
 @param rippleSpeed 波浪速度
 @param ripplePosition 波浪Y轴位置
 @param rippleAmplitude 波浪振幅
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame mainRippleColor:(UIColor *)mainRippleColor minorRippleColor:(UIColor *)minorRippleColor mainRippleoffsetX:(float)mainRippleoffsetX minorRippleoffsetX:(float)minorRippleoffsetX rippleSpeed:(float)rippleSpeed ripplePosition:(float)ripplePosition rippleAmplitude:(float)rippleAmplitude;
@end

