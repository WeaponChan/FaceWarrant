//
//  WaterRippleView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "WaterRippleView.h"

@interface WaterRippleView(){
    float _currentLinePointY;
}
@property (nonatomic, strong)CADisplayLink *rippleDisplayLink;//苹果的垂直同步
@property (nonatomic, strong)CAShapeLayer *mainRippleLayer;//主波图层
@property (nonatomic, strong)CAShapeLayer *minorRippleLayer;//次波图层
@property (nonatomic, assign)CGFloat rippleWidth;//波浪宽度
@end
@implementation WaterRippleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //以下为默认设置
        self.backgroundColor = [UIColor redColor];
        self.mainRippleColor = [UIColor colorWithRed:255/255.0f green:127/255.0f blue:80/255.0f alpha:1];
        self.minorRippleColor = [UIColor whiteColor];
        self.mainRippleoffsetX = 1;
        self.minorRippleoffsetX = 2;
        self.rippleSpeed = .5f;
        self.rippleWidth = frame.size.width;
        self.ripplePosition = frame.size.height-40.0f;
        self.rippleAmplitude = 5;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame mainRippleColor:(UIColor *)mainRippleColor minorRippleColor:(UIColor *)minorRippleColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        self.mainRippleColor = mainRippleColor;
        self.minorRippleColor = minorRippleColor;
        self.mainRippleoffsetX = 1;
        self.minorRippleoffsetX = 2;
        self.rippleSpeed = 1.0f;
        self.rippleWidth = frame.size.width;
        self.ripplePosition = frame.size.height-40.0f;
        self.rippleAmplitude = 5;
        [self drawSingleWaterRipple];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame mainRippleColor:(UIColor *)mainRippleColor minorRippleColor:(UIColor *)minorRippleColor mainRippleoffsetX:(float)mainRippleoffsetX minorRippleoffsetX:(float)minorRippleoffsetX rippleSpeed:(float)rippleSpeed ripplePosition:(float)ripplePosition rippleAmplitude:(float)rippleAmplitude{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.mainRippleColor = mainRippleColor;
        self.minorRippleColor = minorRippleColor;
        self.mainRippleoffsetX = mainRippleoffsetX;
        self.minorRippleoffsetX = minorRippleoffsetX;
        self.rippleSpeed = rippleSpeed;
        self.rippleWidth = frame.size.width;
        self.ripplePosition = frame.size.height-ripplePosition;
        self.rippleAmplitude = rippleAmplitude;
        [self drawWaterRipple];
    }
    return self;
}

/*
 *CADispayLink相当于一个定时器 会一直绘制曲线波纹 看似在运动，其实是一直在绘画不同位置点的余弦函数曲线
 *CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。
 *我们在应用中创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
 */

//创建单个波纹
- (void)drawSingleWaterRipple
{
    self.mainRippleLayer = [CAShapeLayer layer];
    self.mainRippleLayer.fillColor = self.mainRippleColor.CGColor;
    [self.layer addSublayer:self.mainRippleLayer];
    self.rippleDisplayLink = [CADisplayLink displayLinkWithTarget:self
                                                         selector:@selector(getSingleRipple)];
    [self.rippleDisplayLink addToRunLoop:[NSRunLoop mainRunLoop]
                                 forMode:NSRunLoopCommonModes];
}

- (void)getSingleRipple
{
    self.mainRippleoffsetX += self.rippleSpeed;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, self.ripplePosition);
    CGFloat y = 0.f;
    for (float x = 0.f; x <= self.rippleWidth ; x++) {
        y = self.rippleAmplitude * sin(1.2 *  M_PI/ self.rippleWidth  * x   - self.mainRippleoffsetX *M_PI/180) + self.ripplePosition;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, self.rippleWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    self.mainRippleLayer.path = path;
    CGPathRelease(path);
}


//创建两个波纹
- (void)drawWaterRipple
{
    self.mainRippleLayer = [CAShapeLayer layer];
    self.mainRippleLayer.fillColor = self.mainRippleColor.CGColor;
    [self.layer addSublayer:self.mainRippleLayer];
    
    self.minorRippleLayer = [CAShapeLayer layer];
    self.minorRippleLayer.fillColor = self.minorRippleColor.CGColor;
    [self.layer addSublayer:self.minorRippleLayer];
    
    self.rippleDisplayLink = [CADisplayLink displayLinkWithTarget:self
                                                         selector:@selector(getWaterRipple)];
    [self.rippleDisplayLink addToRunLoop:[NSRunLoop mainRunLoop]
                                 forMode:NSRunLoopCommonModes];
}

- (void)getWaterRipple
{
    self.mainRippleoffsetX += self.rippleSpeed;
    CGMutablePathRef mainPath = CGPathCreateMutable();
    CGPathMoveToPoint(mainPath, nil, 0, self.ripplePosition);
    CGFloat mainY = 0.f;
    for (float x = 0.f; x <= self.rippleWidth ; x++) {
        mainY = self.rippleAmplitude * sin(1.2 *  M_PI/ self.rippleWidth  * x   - self.mainRippleoffsetX *M_PI/180) + self.ripplePosition;
        CGPathAddLineToPoint(mainPath, nil, x, mainY);
    }
    CGPathAddLineToPoint(mainPath, nil, self.rippleWidth, self.frame.size.height);
    CGPathAddLineToPoint(mainPath, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(mainPath);
    self.mainRippleLayer.path = mainPath;
    CGPathRelease(mainPath);
    
    self.minorRippleoffsetX += self.rippleSpeed+0.1f;
    CGMutablePathRef minorPath = CGPathCreateMutable();
    CGPathMoveToPoint(minorPath, nil, 0, self.ripplePosition);
    CGFloat minorY = 0.f;
    for (float x = 0.f; x <= self.rippleWidth ; x++) {
        minorY = self.rippleAmplitude * sin(1.2 *  M_PI/ self.rippleWidth  * x   - self.minorRippleoffsetX*M_PI/360 ) + self.ripplePosition;
        CGPathAddLineToPoint(minorPath, nil, x, minorY);
    }
    CGPathAddLineToPoint(minorPath, nil, self.rippleWidth, self.frame.size.height);
    CGPathAddLineToPoint(minorPath, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(minorPath);
    self.minorRippleLayer.path = minorPath;
    CGPathRelease(minorPath);
}


@end
