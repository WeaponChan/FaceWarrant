//
//  ClassroomSeekPopupView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomSeekPopupView.h"
static const CGFloat ALYPVSeekPopupViewRadius          = 8;   //弧度
static const CGFloat ALYPVSeekPopupViewWidth           = 155; //view 宽度
static const CGFloat ALYPVSeekPopupViewWidthHeight     = 155; //view 高度
static const CGFloat ALYPVSeekPopupViewImageWidth      = 75;  //imageView 宽度
static const CGFloat ALYPVSeekPopupViewImageHeight     = 75;  //imageView 高度
static const CGFloat ALYPVSeekViewImageTop             = 25;  //imageView origin.y
static const CGFloat ALYPVSeekPopupViewTextSize        = 29;  //文字font
static const CGFloat ALYPVSeekPopupViewLabelMargin     = 18;  //显示时间，与图片的间隙

#define kALYPVSeekPopupViewBackGroundColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]
#define kALYPVPopSeekTextColor                   [UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:1]
@interface ClassroomSeekPopupView()
@property (nonatomic, strong) UIImage *forwardImg;      //快进图片
@property (nonatomic, strong) UIImage *backwardImg;     //后退图片
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSMutableParagraphStyle *textStyle;

//seek手势方向
@property (nonatomic, assign) UISwipeGestureRecognizerDirection direction;

//seekTo 时间
@property (nonatomic, assign) NSTimeInterval time;
@end

@implementation ClassroomSeekPopupView

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0,ALYPVSeekPopupViewWidth,ALYPVSeekPopupViewWidthHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _forwardImg = [UIImage imageNamed:@"user-快进"];
        _backwardImg = [UIImage imageNamed:@"user-快退"];
        _textFont = [UIFont systemFontOfSize:ALYPVSeekPopupViewTextSize];
        _textStyle = [[NSMutableParagraphStyle alloc] init];
        _textStyle.alignment = kCTTextAlignmentRight;
        _textStyle.lineBreakMode = NSLineBreakByClipping;
        _direction = UISwipeGestureRecognizerDirectionRight;
        _time = 0.0;
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [ClassroomSeekPopupView drawFillRoundRect:rect radius:ALYPVSeekPopupViewRadius color:kALYPVSeekPopupViewBackGroundColor context:context];
    float imgWidth = ALYPVSeekPopupViewImageWidth;
    float imgHeight = ALYPVSeekPopupViewImageHeight;
    float imgX = (rect.size.width - imgWidth)/2;
    float imgY = ALYPVSeekViewImageTop;
    
    if (self.direction == UISwipeGestureRecognizerDirectionRight) {
        [_forwardImg drawInRect:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    }else if (self.direction == UISwipeGestureRecognizerDirectionLeft){
        [_backwardImg drawInRect:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    }
    NSString *time = [ClassroomSeekPopupView timeformatFromSeconds:self.time];
    if (time && _textStyle) {
        [time drawInRect:CGRectMake(0, imgY + imgHeight + ALYPVSeekPopupViewLabelMargin, rect.size.width, ALYPVSeekPopupViewTextSize) withAttributes:@{NSFontAttributeName:_textFont, NSForegroundColorAttributeName:kALYPVPopSeekTextColor, NSParagraphStyleAttributeName:_textStyle}];
    }
    CGContextRestoreGState(context);
}

#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods
/*
 * 功能 ： 当前时间点的滑动方向，并展示
 * 参数 ： time：当前播放时间，秒
 direciton ： 滑动方向，左右
 */
- (void)setSeekTime:(NSTimeInterval)time direction :(UISwipeGestureRecognizerDirection)direciton{
    self.time = time;
    self.direction = direciton;
    [self setNeedsDisplay];
}

/*
 * 功能 ： 展示view
 */
- (void)showWithParentView:(UIView *)parent {
    if (!parent) {
        return;
    }
    [parent addSubview:self];
    self.center = parent.center;
}

/*
 * 功能 ： 1秒后移除 view
 */
- (void)dismiss {
    if (self) {
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0f];
    }
}



#pragma mark - Private Methods

+ (void)drawFillRoundRect:(CGRect)rect radius:(CGFloat)radius color:(UIColor *)color context:(CGContextRef)context {
    CGContextSetAllowsAntialiasing(context, TRUE);
    CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
    //    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

+ (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long) seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long) (seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", (long) seconds % 60];
    //format of time
    NSString *format_time = nil;
    if (seconds / 3600 <= 0) {
        format_time = [NSString stringWithFormat:@"00:%@:%@", str_minute, str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    }
    return format_time;
}
#pragma mark - Setters




#pragma mark - Getters



@end
