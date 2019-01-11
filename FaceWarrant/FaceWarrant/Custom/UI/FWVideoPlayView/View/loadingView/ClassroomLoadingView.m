//
//  ClassroomLoadingView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/12.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomLoadingView.h"
#import <Foundation/NSBundle.h>
#import "ClassroomGifView.h"
static const CGFloat AlilyunViewLoadingViewGifViewWidth   = 28;   //gifView 宽度
static const CGFloat AlilyunViewLoadingViewGifViewHeight  = 28;   //gifView 高度
static const CGFloat AlilyunViewLoadingViewMargin         = 2;    //间隙

#define kALYPVColorTextNomal                     [UIColor colorWithRed:(231 / 255.0) green:(231 / 255.0) blue:(231 / 255.0) alpha:1]

@interface ClassroomLoadingView()

@property (nonatomic, strong) ClassroomGifView *gifView;
@property (nonatomic, strong) UILabel *tipLabelView;

@end

@implementation ClassroomLoadingView

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:YES];
        [self addSubview:self.gifView];
        [self addSubview:self.tipLabelView];
    }
    return self;
}

#pragma mark - Layout SubViews

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float margin = AlilyunViewLoadingViewMargin;
    float textHeight = 14;
    float messageViewY = (width - textHeight) / 2;
    self.tipLabelView.frame = CGRectMake(0, messageViewY, width, textHeight);
    float gifWidth = AlilyunViewLoadingViewGifViewWidth;
    float gifHeight = AlilyunViewLoadingViewGifViewHeight;
    self.gifView.frame = CGRectMake((width - gifWidth) / 2, messageViewY - gifHeight - margin, gifWidth, gifWidth);
    [self.gifView startAnimation];
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods

- (void)show {
    if (![self isHidden]) {
        return;
    }
    [self.gifView startAnimation];
    [self setHidden:NO];
}

- (void)dismiss {
    if ([self isHidden]) {
        return;
    }
    [self.gifView stopAnimation];
    [self setHidden:YES];
}


#pragma mark - Private Methods




#pragma mark - Setters




#pragma mark - Getters
- (ClassroomGifView *)gifView{
    if (!_gifView) {
        _gifView = [[ClassroomGifView alloc] init];
        [_gifView setGifImageWithName:@"user-视频加载"];
    }
    return _gifView;
}

- (UILabel *)tipLabelView{
    if (!_tipLabelView) {
        NSBundle *resourceBundle = [NSBundle mainBundle];
        NSString *str = NSLocalizedStringFromTableInBundle(@"loading", nil, resourceBundle, nil);
        _tipLabelView = [[UILabel alloc] init];
        [_tipLabelView setText:str];
        [_tipLabelView setTextColor:kALYPVColorTextNomal];
        [_tipLabelView setFont:[UIFont systemFontOfSize:14]];
        [_tipLabelView setTextAlignment:NSTextAlignmentCenter];
    }
    return _tipLabelView;
}



@end
