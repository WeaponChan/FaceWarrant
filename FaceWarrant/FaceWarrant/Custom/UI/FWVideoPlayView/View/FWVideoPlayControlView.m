//
//  FWVideoPlayControlView.m
//  FaceWarrant
//
//  Created by FW on 2018/10/23.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWVideoPlayControlView.h"

static const CGFloat ALYControlViewTopViewHeight    = 48;   //topView 高度
static const CGFloat ALYControlViewBottomViewHeight = 48;   //bottomView 高度
static const CGFloat ALYControlViewLockButtonLeft   = 20;   //lockButton 左侧距离父视图距离
static const CGFloat ALYControlViewLockButtonHeight = 40;   //lockButton 高度

@interface FWVideoPlayControlView()<ClassroomGestureViewDelegate,ClassroomPlayTopViewDelegate,ClassroomPlayBottomViewDelegate,ClassroomQualityListViewDelegate>

@property (nonatomic, strong) ClassroomPlayTopView *topView;             //topView
@property (nonatomic, strong) ClassroomPlayBottomView *bottomView;       //bottomView
@property (nonatomic, strong) ClassroomGestureView *guestureView;        //手势view

@property (nonatomic, assign) BOOL isHiddenView;                         //是否需要隐藏topView、bottomView
@end

@implementation FWVideoPlayControlView

#pragma mark - Life Cycle

- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.isHiddenView = NO;
        
//        self.guestureView.delegate = self;
//        [self addSubview:self.guestureView];
        
        self.topView.delegate = self;
        [self addSubview:self.topView];
        
        self.bottomView.delegate = self;
        [self addSubview:self.bottomView];
        
//        [self addSubview:self.playButton];

//        self.listView.delegate = self;
        
        [self addSubview:self.lockButton];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutSubviews{
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float topBarHeight = ALYControlViewTopViewHeight;
    float bottomBarHeight = ALYControlViewBottomViewHeight;
    float bottomBarY = height - bottomBarHeight;
    self.guestureView.frame = self.bounds;
    self.topView.frame = CGRectMake(0, 0, width, topBarHeight);
    self.bottomView.frame = CGRectMake(0, bottomBarY, width, bottomBarHeight);
    self.lockButton.frame = CGRectMake(ALYControlViewLockButtonLeft, (height-ALYControlViewLockButtonHeight)/2.0, 2*ALYControlViewLockButtonLeft, ALYControlViewLockButtonHeight);
    
    self.playButton.frame = CGRectMake((self.bounds.size.width/2) - 35, (self.bounds.size.height/2) - 35, 70, 70);
    
    float tempX = width - (ALYPVBottomViewFullScreenButtonWidth + ALYPVBottomViewQualityButtonWidth);
    float tempW = ALYPVBottomViewQualityButtonWidth;
    
    if (self.isProtrait) {
        self.lockButton.hidden = NO;
        self.listView.frame = CGRectMake(tempX, height-[self.listView estimatedHeight]-bottomBarHeight, tempW, [self.listView estimatedHeight]);
        return;
    }
    
    if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
        self.lockButton.hidden = YES;
        self.listView.hidden = YES;
    }else{
        self.lockButton.hidden = NO;
        self.listView.hidden = !self.bottomView.qualityButton.selected;
    }
    self.listView.frame = CGRectMake(tempX, height-[self.listView estimatedHeight]-bottomBarHeight, tempW, [self.listView estimatedHeight]);
}


#pragma mark - System Delegate


#pragma mark - Custom Delegate

#pragma mark - AliyunPVTopViewDelegate
- (void)onBackViewClickWithClassroomPlayTopView:(ClassroomPlayTopView *)topView{
    if (UIInterfaceOrientationPortrait != [[UIApplication sharedApplication] statusBarOrientation]) {
        [FWVideoPlayControlView setFullOrHalfScreen];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithClassroomPlayControView:)]) {
            [self.delegate onBackViewClickWithClassroomPlayControView:self];
        }
    }
}

- (void)onMoreViewClickedWithClassroomPlayTopView:(ClassroomPlayTopView *)topView{
    [self checkDelayHideMethod];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMoreViewClickedWithClassroomPlayControView:)]) {
        [self.delegate onMoreViewClickedWithClassroomPlayControView:self];
    }
}

#pragma mark - AliyunPVBottomViewDelegate
- (void)ClassroomPlayBottomView:(ClassroomPlayBottomView *)bottomView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event{
    switch (event) {
        case UIControlEventTouchDown:
        {
            //slider 手势按下时，不做隐藏操作
            self.isHiddenView = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
        }
            break;
        case UIControlEventValueChanged:
        {
            
        }
            break;
        case UIControlEventTouchUpInside:
        {
            //slider滑动结束后，
            self.isHiddenView = YES;
            [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
        }
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayControView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomPlayControView:self dragProgressSliderValue:progressValue event:event];
    }
}

- (void)ClassroomPlayBottomView:(ClassroomPlayBottomView *)bottomView qulityButton:(UIButton *)qulityButton{
    if (!qulityButton.selected) {
        self.listView.hidden = NO;
        [self addSubview:self.listView];
    } else {
        [self.listView removeFromSuperview];
    }
}

- (void)onClickedPlayButtonWithClassroomPlayBottomView:(ClassroomPlayBottomView *)bottomView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithClassroomPlayControView:)]) {
        [self.delegate onClickedPlayButtonWithClassroomPlayControView:self];
    }
}

- (void)onClickedfullScreenButtonWithClassroomPlayBottomView:(ClassroomPlayBottomView *)bottomView {
    [self.listView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedfullScreenButtonWithClassroomPlayControView:)]) {
        [self.delegate onClickedfullScreenButtonWithClassroomPlayControView:self];
    }
}

#pragma mark - AliyunPVGestureViewDelegate
- (void)onSingleClickedWithClassroomGestureView:(ClassroomGestureView *)gestureView {
    //单击界面 显示时，快速隐藏；隐藏时，快速展示，并延迟5秒后隐藏
    [self checkDelayHideMethod];
}

- (void)onDoubleClickedWithClassroomGestureView:(ClassroomGestureView *)gestureView {
    //[self.bottomView playButtonClicked:nil];
    [self playButtonClicked:nil];
}

- (void)horizontalOrientationMoveOffset:(float)moveOffset{
    UISwipeGestureRecognizerDirection direction = UISwipeGestureRecognizerDirectionLeft;
    if (moveOffset >= 0) {
        direction = UISwipeGestureRecognizerDirectionRight;
    }
    float x =  moveOffset;
    double duration = self.duration;
    float width = self.bounds.size.width;
    double seekTime = self.currentTime;
    
    if (duration > 3600) {
        seekTime += x / width * duration * 0.1;
    } else if (1800 < duration && duration <= 3600) {
        seekTime += x / width * duration * 0.2;
    } else if (600 < duration && duration <= 1800) {
        seekTime += x / width * duration * 0.34;
    } else if (240 < duration && duration <= 600) {
        seekTime += x / width * duration * 0.5;
    } else {
        seekTime += x / width * duration;
    }
    if (seekTime < 0) {
        seekTime = 0;
    } else if (seekTime > duration) {
        seekTime = duration;
    }
    
    [self.guestureView setSeekTime:seekTime direction:direction];
    
    self.bottomView.progress = seekTime/duration;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayControView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomPlayControView:self dragProgressSliderValue:seekTime/duration event:UIControlEventTouchUpInside];
    }
}

#pragma mark - AliyunPVQualityListViewDelegate
- (void)qualityListViewOnItemClick:(int)index {
    //        self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    //    NSArray *ary = @[@"流畅",
    //                     @"标清",
    //                     @"高清",
    //                     @"超清",
    //                     @"2K",
    //                     @"4K",
    //                     @"原画"
    //                     ];
    //        [self.bottomView.qualityButton setTitle:ary[index] forState:UIControlStateNormal];
    
    self.bottomView.qualityButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(ClassroomPlayControView:qualityListViewOnItemClick:)]) {
        [self.delegate ClassroomPlayControView:self qualityListViewOnItemClick:index];
    }
}

- (void)setQualityButtonTitle:(NSString *)title{
    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    [self.bottomView.qualityButton setTitle:title forState:UIControlStateNormal];
    self.bottomView.qualityButton.selected = NO;
}


- (void)qualityListViewOnDefinitionClick:(NSString*)videoDefinition {
    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    [self.bottomView.qualityButton setTitle:videoDefinition forState:UIControlStateNormal];
}

#pragma mark - Event Response

#pragma mark - 锁屏按钮 action
- (void)lockButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLockButtonClickedWithClassroomPlayControView:)]) {
        [self.delegate onLockButtonClickedWithClassroomPlayControView:self];
    }
}

- (void)playButtonClicked:(UIButton *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
    [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithClassroomPlayControView:)]) {
        [self.delegate onClickedPlayButtonWithClassroomPlayControView:self];
    }
}


#pragma mark - Network Requests


#pragma mark - Public Methods

+ (void)setFullOrHalfScreen {
    BOOL isFull = UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = isFull ? UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
}

- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state isScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    
    if (isScreenLocked || fixedPortrait) {
        [self.guestureView setEnableGesture:NO];
    }
    [self.bottomView updateViewWithPlayerState: state];
    
    switch (state) {
        case AliyunVodPlayerStateIdle:
        {
            [self.playButton setSelected:NO];
            self.playButton.hidden = YES;
            [self.guestureView setEnableGesture:NO];
        }
            break;
        case AliyunVodPlayerStateError:
        {
            [self.playButton setSelected:NO];
            self.playButton.hidden = YES;
            [self.guestureView setEnableGesture:YES];
        }
            break;
        case AliyunVodPlayerStatePrepared:
        {
            [self.playButton setSelected:NO];
            self.playButton.hidden = NO;
            [self.guestureView setEnableGesture:YES];
        }
            break;
        case AliyunVodPlayerStatePlay:
        {
            [self.playButton setSelected:YES];
            self.playButton.hidden = YES;
            [self.guestureView setEnableGesture:YES];
        }
            break;
        case AliyunVodPlayerStatePause:
        {
            [self.playButton setSelected:NO];
            self.playButton.hidden = NO;
            [self.guestureView setEnableGesture:YES];
            
            
        }
            break;
        case AliyunVodPlayerStateStop:
        {
            [self.playButton setSelected:NO];
            self.playButton.hidden = NO;
            [self.guestureView setEnableGesture:YES];
        }
            break;
        case AliyunVodPlayerStateLoading:
        {
            self.playButton.hidden = YES;
            [self.guestureView setEnableGesture:NO];
        }
            break;
        case AliyunVodPlayerStateFinish:
        {
            
            self.playButton.selected = NO;
            self.playButton.hidden = NO;
            [self.guestureView setEnableGesture:YES];
        }
            break;
        default:
            break;
    }
}

/*
 * 功能 ：更新进度条
 */
- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime durationTime : (NSTimeInterval)durationTime{
    self.currentTime = currentTime;
    self.duration = durationTime;
    [self.bottomView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality{
    [self.listView setCurrentQuality:quality];
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition{
    [self.listView setCurrentDefinition:videoDefinition];
}

/*
 * 功能 ：是否禁用手势（双击、滑动)
 */
- (void)setEnableGesture:(BOOL)enableGesture{
    [self.guestureView setEnableGesture:enableGesture];
}

/*
 * 功能 ：隐藏topView、bottomView
 */
- (void)hiddenView{
    self.isHiddenView = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    self.listView.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
}

/*
 * 功能 ：展示topView、bottomView
 */
- (void)showView{
    self.isHiddenView = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    
    if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
        self.listView.hidden = YES;
    }else{
        self.listView.hidden = !self.bottomView.qualityButton.selected;
    }
    
    [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
}
/*
 * 功能 ：锁屏
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    [self.bottomView lockScreenWithIsScreenLocked:isScreenLocked fixedPortrait:fixedPortrait];
    if (!isScreenLocked) {
        
        [self.lockButton setImage:[UIImage imageNamed:@"user-不锁屏"] forState:UIControlStateNormal];
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        self.listView.hidden= NO;
        [self setEnableGesture:YES];
        
    }else{
        
        [self.lockButton setImage:[UIImage imageNamed:@"user-锁屏"] forState:UIControlStateNormal];
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.listView.hidden= YES;
        [self setEnableGesture:NO];
        //锁屏 大的播放也隐藏
        self.playButton.hidden = YES;
    }
}

/*
 * 功能 ：取消锁屏
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    if (isScreenLocked||fixedPortrait) {
        [self.bottomView cancelLockScreenWithIsScreenLocked:isScreenLocked fixedPortrait:fixedPortrait];
        [self.lockButton setImage:[UIImage imageNamed:@"user-不锁屏"] forState:UIControlStateNormal];
        self.lockButton.selected = NO;
        self.topView.hidden = NO;
        self.listView.hidden= NO;
        [self setEnableGesture:YES];
    }
}

#pragma mark - Private Methods
- (void)delayHideControlLayer{
    [self hiddenView];
}
- (void)checkDelayHideMethod{
    if (self.isHiddenView) {
        [self showView];
    }else{
        [self hiddenView];
    }
}


#pragma mark - Setters
- (void)setIsProtrait:(BOOL)isProtrait{
    _isProtrait = isProtrait;
    self.bottomView.isPortrait = isProtrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.topView setTopTitle:title];
}

- (void)setVideoInfo:(AliyunVodPlayerVideo *)videoInfo{
    _videoInfo = videoInfo;
    self.bottomView.videoInfo = videoInfo;
    [self.listView removeFromSuperview];
    self.listView = nil;
    self.listView = [[ClassroomQualityListView alloc] init];
    self.listView.allSupportQualities = videoInfo.allSupportQualitys;
    self.listView.delegate = self;
    self.bottomView.qualityButton.selected = NO;
    [self setNeedsLayout];
}

- (void)setLoadTimeProgress:(float)loadTimeProgress{
    _loadTimeProgress = loadTimeProgress;
    self.bottomView.loadTimeProgress = loadTimeProgress;
}

#pragma mark - Getters

- (ClassroomPlayTopView *)topView{
    if (!_topView) {
        _topView = [[ClassroomPlayTopView alloc] init];
    }
    return _topView;
}

- (ClassroomPlayBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ClassroomPlayBottomView alloc] init];
    }
    return _bottomView;
}

- (ClassroomGestureView *)guestureView{
    if (!_guestureView) {
        _guestureView = [[ClassroomGestureView alloc] init];
    }
    return _guestureView;
}

- (UIButton *)lockButton{
    if (!_lockButton) {
        _lockButton = [[UIButton alloc] init];
        [_lockButton setImage:[UIImage imageNamed:@"user-锁屏"] forState:UIControlStateNormal];
        [_lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockButton;
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        _playButton.hidden = YES;
        [_playButton setBackgroundImage:[UIImage imageNamed:@"user-big播放"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"user-big暂停"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

@end
