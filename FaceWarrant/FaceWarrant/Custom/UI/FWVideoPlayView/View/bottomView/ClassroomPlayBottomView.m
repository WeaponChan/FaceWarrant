//
//  ClassroomPlayBottomView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomPlayBottomView.h"

static const CGFloat ALYPVBottomViewPlayButtonWidth         = 52;                         //播放按钮宽度
static const CGFloat ALYPVBottonViewFullScreenTimeWidth     = 80 + 40;                    //全屏时间宽度
static const CGFloat ALYPVBottomViewTextSizeFont            = 12.0f;                      //字体字号
static NSString * const ALYPVBottomViewDefaultTime          = @"00:00:00";                //默认时间样式

#define kALYPVColorTextNomal                     [UIColor colorWithRed:(231 / 255.0) green:(231 / 255.0) blue:(231 / 255.0) alpha:1]
#define kALYPVColorTextGray                      [UIColor colorWithRed:(158 / 255.0) green:(158 / 255.0) blue:(158 / 255.0) alpha:1]
#define kALYPVColorBlue                          [UIColor colorWithRed:(0 / 255.0) green:(193 / 255.0) blue:(222 / 255.0) alpha:1]
@interface ClassroomPlayBottomView()<ClassroomProgressViewDelegate>

@property (nonatomic, strong) UIImageView *bottomBarBG;             //背景图片
@property (nonatomic, strong) UIButton *playButton;                 //播放按钮
@property (nonatomic, strong) UILabel *leftTimeLabel;               //左侧时间
@property (nonatomic, strong) UILabel *rightTimeLabel;              //右侧时间
@property (nonatomic, strong) UILabel *fullScreenTimeLabel;         //全屏时时间
@property (nonatomic, strong) UIButton *fullScreenButton;           //全屏按钮
@property (nonatomic, strong) ClassroomProgressView *progressView;  //进度条

@end

@implementation ClassroomPlayBottomView

#pragma mark - Life Cycle

- (instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.bottomBarBG];
    [self addSubview:self.playButton];
    [self addSubview:self.leftTimeLabel];
    [self addSubview:self.rightTimeLabel];
    [self addSubview:self.fullScreenTimeLabel];
    [self addSubview:self.qualityButton];
    //    [self.qualityButton setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.fullScreenButton];
    self.progressView.delegate = self;
    self.fullScreenButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.progressView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.bottomBarBG.frame = self.bounds;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.playButton.frame = CGRectMake(0, 0,ALYPVBottomViewPlayButtonWidth, height);
    self.fullScreenButton.frame = CGRectMake(width - ALYPVBottomViewFullScreenButtonWidth, 0,ALYPVBottomViewFullScreenButtonWidth, height);
    
    if (self.isPortrait) {
        self.fullScreenButton.selected = YES;
        self.qualityButton.hidden = NO;
        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;
        
        int qualityWidth = ALYPVBottomViewQualityButtonWidth;
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
            qualityWidth = 0;
        }
        
        self.progressView.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth, height,
                                             width - (ALYPVBottomViewPlayButtonWidth + ALYPVBottomViewFullScreenButtonWidth+qualityWidth),
                                             height);
        
        CGRect progressFrame = self.progressView.frame;
        self.leftTimeLabel.frame = CGRectMake(progressFrame.origin.x, height/2, progressFrame.size.width/2, height/2);
        self.rightTimeLabel.frame = CGRectMake(progressFrame.origin.x + progressFrame.size.width/2,height/2, progressFrame.size.width/2, height/2);
        return;
    }
    
    if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
        self.fullScreenButton.selected = NO;
        self.qualityButton.hidden = YES;
        self.qualityButton.selected = NO;
        
        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;
        
        self.progressView.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth, 0,
                                             width - (ALYPVBottomViewPlayButtonWidth + ALYPVBottomViewFullScreenButtonWidth),
                                             height);
        
        CGRect progressFrame = self.progressView.frame;
        self.leftTimeLabel.frame = CGRectMake(progressFrame.origin.x, height/2, progressFrame.size.width/2, height/2);
        self.rightTimeLabel.frame = CGRectMake(progressFrame.origin.x + progressFrame.size.width/2,height/2, progressFrame.size.width/2, height/2);
        
    } else {
        self.fullScreenButton.selected = YES;
        self.qualityButton.hidden = NO;
        //        self.qualityButton.selected = NO;
        
        self.leftTimeLabel.hidden = YES;
        self.rightTimeLabel.hidden = YES;
        self.fullScreenTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth, 0,ALYPVBottonViewFullScreenTimeWidth, height);
        
        int qualityWidth = ALYPVBottomViewQualityButtonWidth;
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
            qualityWidth = 0;
        }
        self.qualityButton.frame = CGRectMake(width - (ALYPVBottomViewQualityButtonWidth + ALYPVBottomViewFullScreenButtonWidth), 0, ALYPVBottomViewQualityButtonWidth, height);
        self.progressView.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth + ALYPVBottonViewFullScreenTimeWidth + ALYPVBottomViewMargin, 0, width - (ALYPVBottomViewPlayButtonWidth + ALYPVBottonViewFullScreenTimeWidth + 2 * ALYPVBottomViewMargin  + qualityWidth + ALYPVBottomViewFullScreenButtonWidth), height);
    }
}



#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate

- (void)ClassroomProgressView:(ClassroomProgressView *)progressView dragProgressSliderValue:(float)value event:(UIControlEvents)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayBottomView:dragProgressSliderValue:event:)]) {
        [self.delegate ClassroomPlayBottomView:self dragProgressSliderValue:value event:event];
    }
}

#pragma mark - Event Response


- (void)fullScreenButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedfullScreenButtonWithClassroomPlayBottomView:)]) {
        [self.delegate onClickedfullScreenButtonWithClassroomPlayBottomView:self];
    }
}

- (void)qualityButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayBottomView:qulityButton:)]) {
        [self.delegate ClassroomPlayBottomView:self qulityButton:sender];
        sender.selected = !sender.isSelected;
    }
}

#pragma mark - Network requests




#pragma mark - Public Methods

+ (NSBundle *)languageBundle {
    NSBundle *resourceBundle = [NSBundle mainBundle];
    return resourceBundle;
}

/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime{
    
    //左右全屏时间
    NSString *curTimeStr = [ClassroomPlayBottomView timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [ClassroomPlayBottomView timeformatFromSeconds:roundf(durationTime)];
    self.rightTimeLabel.text = totalTimeStr;
    self.leftTimeLabel.text = curTimeStr;
    NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
    [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextNomal range:NSMakeRange(0, curTimeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextGray range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
    self.fullScreenTimeLabel.attributedText = str;
    
    //进度条
    [self.progressView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
    
    //
    //    NSLog(@"playtimetest当前播放时间:%f",currentTime);
    //
    //    NSLog(@"playtimetest当前播放时间字符串:%@",curTimeStr);
    //
    //    NSLog(@"playtimetest总时间:%f",durationTime);
    //
    //    NSLog(@"playtimetest总时间字符串:%@",totalTimeStr);
}

/*
 * 功能 ：根据播放器状态，改变状态
 * 参数 ：state 播放器状态
 */
- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state {
    switch (state) {
        case AliyunVodPlayerStateIdle:
        {
            [self.playButton setSelected:NO];
            //            [self.qualityButton setUserInteractionEnabled:NO];
            //            [self.progressView setUserInteractionEnabled:NO];
        }
            break;
        case AliyunVodPlayerStateError:
        {
            [self.playButton setSelected:NO];
            //cai 错误也应该让用户点击按钮重试
            //            [self.playButton setUserInteractionEnabled:NO];
            //            [self.progressView setUserInteractionEnabled:NO];
        }
            break;
        case AliyunVodPlayerStatePrepared:
        {
            [self.playButton setSelected:NO];
            [self.qualityButton setUserInteractionEnabled:YES];
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStatePlay:
        {
            [self.playButton setSelected:YES];
            [self.qualityButton  setUserInteractionEnabled:YES];
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStatePause:
        {
            [self.playButton setSelected:NO];
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStateStop:
        {
            [self.playButton setSelected:NO];
            [self.qualityButton setUserInteractionEnabled:NO];
            [self.progressView setUserInteractionEnabled:NO];
            
        }
            break;
        case AliyunVodPlayerStateLoading:
        {
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStateFinish:
        {
             [self.playButton setSelected:NO];
            [self.progressView setUserInteractionEnabled:NO];
        }
            break;
            
        default:
            break;
    }
}

/*
 * 功能 ：锁屏状态
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    if (!isScreenLocked) {
        self.playButton.hidden = NO;
        self.fullScreenButton.hidden = NO;
        self.fullScreenTimeLabel.hidden = NO;
        self.qualityButton.hidden = NO;
        if (fixedPortrait) {
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = NO;
        }else{
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = YES;
        }
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
        }
        self.progressView.hidden = NO;
    }else{
        self.playButton.hidden = YES;
        self.fullScreenButton.hidden = YES;
        self.fullScreenTimeLabel.hidden = YES;
        self.qualityButton.hidden = YES;
        self.progressView.hidden = YES;
        self.leftTimeLabel.hidden = YES;
        self.rightTimeLabel.hidden = YES;
    }
}

/*
 * 功能 ：取消锁屏
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    if (isScreenLocked||fixedPortrait) {
        if (fixedPortrait) {
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = NO;
        }else{
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = YES;
        }
        self.fullScreenButton.hidden =  NO;
        self.fullScreenTimeLabel.hidden = NO;
        self.qualityButton.hidden = NO;
        self.playButton.hidden = NO;
        
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
        }
        self.progressView.hidden = NO;
    }
}



#pragma mark - Private Methods

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

- (void)setVideoInfo:(AliyunVodPlayerVideo *)videoInfo{
    _videoInfo = videoInfo;
    NSArray *ary =@[@"流畅",
                    @"普清",
                    @"标清",
                    @"高清",
                    @"2K",
                    @"4K",
                    @"原画"
                    ];
    if (videoInfo) {
        if ((int)videoInfo.videoQuality < 0) {
            [self.qualityButton setTitle:videoInfo.videoDefinition forState:UIControlStateNormal];
        }else{
            [self.qualityButton setTitle:ary[videoInfo.videoQuality] forState:UIControlStateNormal];
        }
        self.qualityButton.hidden = NO;
    }
    [self setNeedsLayout];
}

- (void)setProgress:(float)progress{
    _progress = progress;
    self.progressView.progress = progress;
}

- (void)setLoadTimeProgress:(float)loadTimeProgress{
    _loadTimeProgress = loadTimeProgress;
    self.progressView.loadTimeProgress = loadTimeProgress;
}

- (void)setIsPortrait:(BOOL)isPortrait{
    _isPortrait = isPortrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Getters

- (UIImageView *)bottomBarBG{
    if (!_bottomBarBG) {
        _bottomBarBG = [[UIImageView alloc] init];
        _bottomBarBG.image = [UIImage imageNamed:@"user-视频bottom"];
    }
    return _bottomBarBG;
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"user-small播放"]forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"user-small暂停"]forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)playButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithClassroomPlayBottomView:)]) {
        [self.delegate onClickedPlayButtonWithClassroomPlayBottomView:self];
    }
}

- (UILabel *)leftTimeLabel{
    if (!_leftTimeLabel) {
        _leftTimeLabel = [[UILabel alloc] init];
        _leftTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_leftTimeLabel setFont:[UIFont systemFontOfSize:ALYPVBottomViewTextSizeFont]];
        [_leftTimeLabel setTextColor:kALYPVColorTextNomal];
        _leftTimeLabel.text = ALYPVBottomViewDefaultTime;
    }
    return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel{
    if (!_rightTimeLabel) {
        _rightTimeLabel = [[UILabel alloc] init];
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        [_rightTimeLabel setFont:[UIFont systemFontOfSize:ALYPVBottomViewTextSizeFont]];
        [_rightTimeLabel setTextColor:kALYPVColorTextNomal];
        _rightTimeLabel.text = ALYPVBottomViewDefaultTime;
    }
    return _rightTimeLabel;
}

- (UILabel *)fullScreenTimeLabel{
    if (!_fullScreenTimeLabel) {
        _fullScreenTimeLabel = [[UILabel alloc] init];
        _fullScreenTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_fullScreenTimeLabel setFont:[UIFont systemFontOfSize:ALYPVBottomViewTextSizeFont]];
        NSString *curTimeStr = @"00:00:00";
        NSString *totalTimeStr = @"00:00:00";
        NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
        [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextNomal range:NSMakeRange(0, curTimeStr.length)];
        [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextGray range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
        [_fullScreenTimeLabel setAttributedText:str];
    }
    return _fullScreenTimeLabel;
}

- (UIButton *)qualityButton{
    if (!_qualityButton) {
        _qualityButton = [[UIButton alloc] init];
        [_qualityButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_qualityButton setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        [_qualityButton setTitleColor:kALYPVColorBlue forState:UIControlStateSelected];
        [_qualityButton setTag:1003];
        [_qualityButton addTarget:self action:@selector(qualityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qualityButton;
}



- (UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setTag:1004];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreenButton setImage:[UIImage imageNamed:@"user-全屏"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"user-全屏"] forState:UIControlStateSelected];
    }
    return _fullScreenButton;
}


- (ClassroomProgressView *)progressView{
    if (!_progressView){
        _progressView = [[ClassroomProgressView alloc] init];
    }
    return _progressView;
}






@end
