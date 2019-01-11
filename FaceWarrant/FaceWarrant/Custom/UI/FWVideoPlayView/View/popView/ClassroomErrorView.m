//
//  ClassroomErrorView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/12.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomErrorView.h"
#define kALYPVColorBlue                          [UIColor colorWithRed:(0 / 255.0) green:(193 / 255.0) blue:(222 / 255.0) alpha:1]
#define kALYPVColorTextNomal                     [UIColor colorWithRed:(231 / 255.0) green:(231 / 255.0) blue:(231 / 255.0) alpha:1]
#define kALYPVPopErrorViewBackGroundColor        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

static const CGFloat AliyunPlayerViewErrorViewWidth         = 220; //宽度
static const CGFloat AliyunPlayerViewErrorViewHeight        = 120; //高度
static const CGFloat AliyunPlayerViewErrorViewTextMarginTop = 30;  //text距离顶部距离
static const CGFloat ALYPVErrorButtonWidth       = 82;  //button宽度
static const CGFloat ALYPVErrorButtonHeight      = 30;  //button高度
static const CGFloat ALYPVErrorButtonMarginLeft  = 68;  //button左侧距离父类距离
static const CGFloat AliyunPlayerViewErrorViewRadius        = 4;   //半径

@interface ClassroomErrorView()

@property (nonatomic, strong) UILabel *textLabel;               //错误界面，文本提示
@property (nonatomic, strong) UIButton *button;                 //界面中 点击按钮
@property (nonatomic, strong) NSString *errorButtonEventType; //按钮中，提示信息（重播、重试等）

@end

@implementation ClassroomErrorView

#pragma mark - Life Cycle

- (instancetype)init{
    CGRect defaultFrame = CGRectMake(0, 0, AliyunPlayerViewErrorViewWidth, AliyunPlayerViewErrorViewHeight);
    return [self initWithFrame:defaultFrame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
        [self addSubview:self.button];
    }
    return self;
}



#pragma mark - Layout SubViews
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = AliyunPlayerViewErrorViewWidth;
    CGFloat height = AliyunPlayerViewErrorViewHeight;
    self.textLabel.frame = CGRectMake(0, AliyunPlayerViewErrorViewTextMarginTop, width, height);
    self.button.frame = CGRectMake(ALYPVErrorButtonMarginLeft, AliyunPlayerViewErrorViewTextMarginTop/2.0,
                                   ALYPVErrorButtonWidth,
                                   ALYPVErrorButtonHeight);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [ClassroomErrorView drawFillRoundRect:rect radius:[ClassroomErrorView convertPixelToPoint:4] color:kALYPVPopErrorViewBackGroundColor context:context];
    CGContextRestoreGState(context);
}

#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)onClick:(UIButton *)sender {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorViewClickedWithType:)]) {
        [self.delegate onErrorViewClickedWithType:self.type];
    }
}



#pragma mark - Network requests




#pragma mark - Public Methods

/*
 * 功能 ：展示错误页面偏移量
 * 参数 ：parent 插入的界面
 */
- (void)showWithParentView:(UIView *)parent {
    if (!parent) {
        return;
    }
    parent.hidden = NO;
    [parent addSubview:self];
    self.center = CGPointMake(parent.frame.size.width / 2, parent.frame.size.height / 2);
    self.backgroundColor = [UIColor clearColor];
}

/*
 * 功能 ：是否展示界面
 */
- (BOOL)isShowing {
    return self.superview != nil;
}

/*
 * 功能 ：是否删除界面
 */
- (void)dismiss {
    [self removeFromSuperview];
}



#pragma mark - Private Methods

+ (float)convertPixelToPoint:(float)pixel {
    if (pixel < 0) {
        return 0;
    }
    return pixel / 2;
}

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



#pragma mark - Setters

- (void)setMessage:(NSString *)message {
    _message = message;
    self.textLabel.text = message;
    int width = AliyunPlayerViewErrorViewWidth;
    NSDictionary *dic = @{NSFontAttributeName : self.textLabel.font};
    CGRect infoRect = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    self.textLabel.frame = CGRectMake(0, self.frame.size.width/2.0, width, infoRect.size.height);
    [self setNeedsLayout];
}

/*
 "Retry" = "重试";
 "Replay" = "重播";
 "Play" = "播放";
 */
- (void)setType:(ALYPVErrorType)type{
    _type = type;
    NSString *str = @"";
    NSBundle *resourceBundle = [NSBundle mainBundle];
    switch (type) {
        case ALYPVErrorTypeUnknown:
            str = NSLocalizedStringFromTableInBundle(@"Retry", nil, resourceBundle, nil);
            break;
        case ALYPVErrorTypeRetry:
            str = NSLocalizedStringFromTableInBundle(@"Retry", nil, resourceBundle, nil);
            break;
        case ALYPVErrorTypeReplay:
            str = NSLocalizedStringFromTableInBundle(@"Replay", nil, resourceBundle, nil);
            break;
        case ALYPVErrorTypePause:
            str = NSLocalizedStringFromTableInBundle(@"Play", nil, resourceBundle, nil);
            break;
            
        default:
            break;
    }
    [_button setTitle:str forState:UIControlStateNormal];
}



#pragma mark - Getters

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTextColor:kALYPVColorTextNomal];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        _textLabel.numberOfLines = 999;
    }
    return _textLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"user-视频错误框"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"user-视频重试"] forState:UIControlStateNormal];
        _button.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
        [_button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


@end
