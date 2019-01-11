//
//  ClassroomGestureView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomGestureView.h"
#import "ClassroomSeekPopupView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ClassroomGestureModel.h"

static const CGFloat ALYPVGestureViewBrightImageViewWidth        = 125;    //亮度view宽度
static const CGFloat ALYPVGestureViewBrightProgressHeight        = 20;     //亮度进度条高度
static const CGFloat ALYPVGestureViewBrightProgressLeft          = 15;     //亮度进度条 相对父试图左侧距离
static const CGFloat ALYPVGestureViewBrightProgressBottom        = 10;     //亮度进度条 距离父视图底边距离

@interface ClassroomGestureView()<UIGestureRecognizerDelegate,ClassroomGestureModelDelegate>
/*
 * 功能 ： 声音
 */
@property (nonatomic, assign) float systemVolume;
/*
 * 功能 ： 亮度
 */
@property (nonatomic, assign) float systemBrightness;
/*
 * 功能 ： 声音设置
 */
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
/*
 * 功能 ：亮度
 */
@property (nonatomic, strong) UIImageView *brightImageView;
@property (nonatomic, strong) UIProgressView *brightProgress;
/*
 * 功能 ：前进、后退
 */
@property (nonatomic, strong) ClassroomSeekPopupView *seekView;
/*
 * 功能 ：手势
 */
@property (nonatomic, strong) ClassroomGestureModel *gestureModel;

@end

@implementation ClassroomGestureView

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.brightImageView.image = [UIImage imageNamed:@"user-亮度"];
        [self addSubview:self.brightImageView];
        [self.brightImageView addSubview:self.brightProgress];
        
        [self.gestureModel setView: self];
        self.gestureModel.delegate = self;
    }
    return self;
}

#pragma mark - Layout SubViews

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.brightImageView.frame = CGRectMake((Screen_H-ALYPVGestureViewBrightImageViewWidth)/2,(Screen_W-ALYPVGestureViewBrightImageViewWidth)/2, ALYPVGestureViewBrightImageViewWidth, ALYPVGestureViewBrightImageViewWidth);
    self.brightImageView.center = CGPointMake(width/2, height/2);
    self.brightProgress.frame = CGRectMake(ALYPVGestureViewBrightProgressLeft,self.brightImageView.frame.size.height-ALYPVGestureViewBrightProgressBottom,self.brightImageView.frame.size.width-2*ALYPVGestureViewBrightProgressLeft,ALYPVGestureViewBrightProgressHeight);
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate

-(void)ClassroomGestureModel:(ClassroomGestureModel *)aliyunGestureModel state:(UIGestureRecognizerState)state moveOrientation:(ALYPVOrientation)moveOrientation{
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (moveOrientation == ALYPVOrientationHorizontal) {
                if (self.seekView.superview == nil) {
                    [self.seekView showWithParentView:self];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            if (moveOrientation == ALYPVOrientationVertical) {
                [UIView animateWithDuration:0.5f animations:^{
                    self.brightImageView.alpha =0.0f;
                }];
            }
            [self.seekView dismiss];
            break;
        }
        default:
            break;
    }
}

- (void)ClassroomGestureModel:(ClassroomGestureModel *)aliyunGestureModel volumeDirection:(UISwipeGestureRecognizerDirection)direction{
    
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        
        [self setVolumeUp];
    }else if (direction == UISwipeGestureRecognizerDirectionDown){
        
        [self setVolumeDown];
    }
}

- (void)ClassroomGestureModel:(ClassroomGestureModel *)aliyunGestureModel brightnessDirection:(UISwipeGestureRecognizerDirection)direction{
    
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        
        [self setBrightnessUp];
    }else if (direction == UISwipeGestureRecognizerDirectionDown){
        
        [self setBrightnessDown];
    }
}

- (void)horizontalOrientationMoveOffset:(float)moveOffset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalOrientationMoveOffset:)]) {
        [self.delegate horizontalOrientationMoveOffset:moveOffset];
    }
}

- (void)onDoubleClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDoubleClickedWithClassroomGestureView:)]) {
        [self.delegate onDoubleClickedWithClassroomGestureView:self];
    }
}

- (void)onSingleClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSingleClickedWithClassroomGestureView:)]) {
        [self.delegate onSingleClickedWithClassroomGestureView:self];
    }
}



#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setBrightnessUp{
    if ([UIScreen mainScreen].brightness >=1) {
        return;
    }
    [UIScreen mainScreen].brightness += 0.01;
    self.brightImageView.alpha = 1.0f;
    self.brightProgress.progress = [UIScreen mainScreen].brightness;
}

- (void)setBrightnessDown{
    if ([UIScreen mainScreen].brightness <=0) {
        return;
    }
    [UIScreen mainScreen].brightness -= 0.01;
    self.brightImageView.alpha = 1.0f;
    self.brightProgress.progress = [UIScreen mainScreen].brightness;
}

- (void)setVolumeUp{
    self.systemVolume = self.musicPlayer.volume;
    if (self.musicPlayer.volume >=1) {
        return;
    }
    self.systemVolume = _systemVolume+0.01;
    [self.musicPlayer setVolume:_systemVolume];
    self.musicPlayer.volume += 0.01;
}

- (void)setVolumeDown{
    self.systemVolume = self.musicPlayer.volume;
    if (_systemVolume <=0) {
        return;
    }
    self.systemVolume = self.systemVolume-0.01;
    [self.musicPlayer setVolume:self.systemVolume];
}


#pragma mark - Setters

- (void)setEnableGesture:(BOOL)enableGesture {
    [self.gestureModel setEnableGesture:enableGesture];
}

- (void)setSeekTime:(NSTimeInterval)time direction : (UISwipeGestureRecognizerDirection)direction{
    [self.seekView setSeekTime:time direction:direction];
}



#pragma mark - Getters
- (MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    }
    return _musicPlayer;
}

- (UIImageView *)brightImageView{
    if (!_brightImageView) {
        _brightImageView = [[UIImageView alloc] init];
        _brightImageView.alpha = 0.0;
    }
    return _brightImageView;
}

- (UIProgressView *)brightProgress{
    if (!_brightProgress) {
        _brightProgress = [[UIProgressView alloc] init];
        _brightProgress.backgroundColor = [UIColor clearColor];
        _brightProgress.trackTintColor = [UIColor blackColor];
        _brightProgress.progressTintColor = [UIColor whiteColor];
        _brightProgress.progress = [UIScreen mainScreen].brightness;
        _brightProgress.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    }
    return _brightProgress;
}

- (ClassroomSeekPopupView *)seekView{
    if (!_seekView) {
        _seekView = [[ClassroomSeekPopupView alloc] init];
    }
    return _seekView;
}

- (ClassroomGestureModel *)gestureModel{
    if (!_gestureModel) {
        _gestureModel = [[ClassroomGestureModel alloc] init];
    }
    return _gestureModel;
}


@end
