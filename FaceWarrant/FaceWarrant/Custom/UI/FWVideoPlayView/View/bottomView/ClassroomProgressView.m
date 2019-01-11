//
//  ClassroomProgressView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomProgressView.h"

static const CGFloat AliyunPlayerViewProgressViewLoadtimeViewLeft      = 2 ;  //loadtimeView 左侧距离父视图距离
static const CGFloat AliyunPlayerViewProgressViewLoadtimeViewTop       = 23 ; //loadtimeView 顶部距离父视图距离
static const CGFloat AliyunPlayerViewProgressViewLoadtimeViewHeight    = 2 ;  //loadtimeView 高度
static const CGFloat AliyunPlayerViewProgressViewPlaySliderTop         = 12 ; //playSlider 顶部距离父视图距离
static const CGFloat AliyunPlayerViewProgressViewPlaySliderHeight      = 24 ; //playSlider 高度

@interface ClassroomProgressView()<ClassroomProgressSliderDelegate>

@property (nonatomic, strong) ClassroomProgressSlider * playSlider;  //进度条，currentTime
@property (nonatomic, strong) UIProgressView *loadtimeView; //缓冲条，loadTime
@end

@implementation ClassroomProgressView

#pragma mark - Life Cycle


- (instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.loadtimeView];
        
        self.playSlider.delegate = self;
        [self addSubview:self.playSlider];
    }
    return self;
}

#pragma mark - Layout SubViews

- (void)layoutSubviews{
    self.loadtimeView.frame = CGRectMake(AliyunPlayerViewProgressViewLoadtimeViewLeft,AliyunPlayerViewProgressViewLoadtimeViewTop, self.bounds.size.width-2*AliyunPlayerViewProgressViewLoadtimeViewLeft, AliyunPlayerViewProgressViewLoadtimeViewHeight);
    self.playSlider.frame = CGRectMake(0,AliyunPlayerViewProgressViewPlaySliderTop, self.bounds.size.width, AliyunPlayerViewProgressViewPlaySliderHeight);
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response
#pragma mark - slider action
- (void)progressSliderDownAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomProgressView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomProgressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchDown];
    }
}

- (void)updateProgressSliderAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomProgressView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomProgressView:self dragProgressSliderValue:sender.value event:UIControlEventValueChanged];
    }
}

- (void)progressSliderUpAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomProgressView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomProgressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchUpInside];
    }
}

- (void)updateProgressUpOUtsideSliderAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomProgressView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomProgressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchUpOutside];
    }
}

- (void)cancelProgressSliderAction:(UISlider *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomProgressView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomProgressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchCancel];
    }
}


- (void)aliyunPlayerViewSlider:(ClassroomProgressView *)slider clickedSlider:(float)sliderValue{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomProgressView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomProgressView:self dragProgressSliderValue:sliderValue event:UIControlEventTouchDownRepeat]; //实际是点击事件
    }
}


#pragma mark - Network requests




#pragma mark - Public Methods
/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime{
    [self.playSlider setValue:currentTime/durationTime animated:YES];
}

#pragma mark - Private Methods




#pragma mark - Setters

- (void)setProgress:(float)progress{
    _progress = progress;
    [self.playSlider setValue:progress animated:YES];
}

- (void)setLoadTimeProgress:(float)loadTimeProgress{
    _loadTimeProgress = loadTimeProgress;
    [self.loadtimeView setProgress:loadTimeProgress];
}


#pragma mark - Getters
- (ClassroomProgressSlider *)playSlider{
    if (!_playSlider) {
        _playSlider = [[ClassroomProgressSlider alloc] init];
        _playSlider.value = 0.0;
        //thumb左侧条的颜色
        _playSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"00c1de"];
        _playSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        //thumb图片
        [_playSlider setThumbImage:[UIImage imageNamed:@"user-播放进度"] forState:UIControlStateNormal];
        //手指落下
        [_playSlider addTarget:self action:@selector(progressSliderDownAction:) forControlEvents:UIControlEventTouchDown];
        //手指抬起
        [_playSlider addTarget:self action:@selector(progressSliderUpAction:) forControlEvents:UIControlEventTouchUpInside];
        //value发生变化
        [_playSlider addTarget:self action:@selector(updateProgressSliderAction:) forControlEvents:UIControlEventValueChanged];
        
        [_playSlider addTarget:self action:@selector(cancelProgressSliderAction:) forControlEvents:UIControlEventTouchCancel];
        //手指在外面抬起
        [_playSlider addTarget:self action:@selector(updateProgressUpOUtsideSliderAction:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _playSlider;
}

- (UIProgressView *)loadtimeView{
    if (!_loadtimeView) {
        _loadtimeView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _loadtimeView.progress = 0.0;
        //设置它的风格，为默认的
        _loadtimeView.trackTintColor= [UIColor clearColor];
        //设置轨道的颜色
        _loadtimeView.progressTintColor= [UIColor whiteColor];
    }
    return _loadtimeView;
}


@end
