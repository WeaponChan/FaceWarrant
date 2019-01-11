//
//  ClassroomPlayMoreView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomPlayMoreView.h"

#import <MediaPlayer/MediaPlayer.h>

@interface ClassroomPlayMoreView()
@property (nonatomic, strong) UIView *containsView;

@property (nonatomic, strong) UIImageView *leftVolumeIV;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIImageView *rightVolumeIV;

@property (nonatomic, strong) UIImageView *leftBrightIV;
@property (nonatomic, strong) UISlider *brightSlider;
@property (nonatomic, strong) UIImageView *rightBrightIV;

/*
 * 功能 ： 声音设置
 */
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

@property (nonatomic, strong) UILabel *tipLabel;        //提示信息
@end

@implementation ClassroomPlayMoreView

#pragma mark - Life Cycle
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self addSubview:self.tipLabel];
        [self addSubview:self.containsView];
        [self.containsView addSubview:self.leftVolumeIV];
        [self.containsView addSubview:self.volumeSlider];
        [self.containsView addSubview:self.rightVolumeIV];
        [self.containsView addSubview:self.leftBrightIV];
        [self.containsView addSubview:self.brightSlider];
        [self.containsView addSubview:self.rightBrightIV];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutSubviews{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat containsViewWidth = 300;
    
    if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
        self.hidden = YES;
    }
    
    if (_containsView.frame.origin.x == width) {
        return;
    }
    
    _containsView.frame = CGRectMake(width-containsViewWidth, 0, containsViewWidth, height);
    
    _leftVolumeIV.frame = CGRectMake(30, self.bounds.size.height/2 - 40, 30, 30);
    _volumeSlider.frame = CGRectMake(CGRectGetMaxX(_leftVolumeIV.frame)+10, self.bounds.size.height/2 - 15, containsViewWidth-2*30-2*10-2*30, 30);
    
    [_volumeSlider addTarget:self action:@selector(volumeSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    _rightVolumeIV.frame = CGRectMake(containsViewWidth-30-30,self.bounds.size.height/2 - 40,30,30);
    
    _leftBrightIV.frame = CGRectMake(30, CGRectGetMaxY(_rightVolumeIV.frame)+20, 30, 30);
    _brightSlider.frame = CGRectMake(CGRectGetMaxX(_leftBrightIV.frame)+10, CGRectGetMaxY(_rightVolumeIV.frame)+20, containsViewWidth-2*30-2*10-2*30, 30);
    
    [_brightSlider addTarget:self action:@selector(brightSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    _rightBrightIV.frame = CGRectMake(containsViewWidth-30-30,CGRectGetMaxY(_rightVolumeIV.frame)+20,30,30);
    
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)volumeSliderChangeValue:(UISlider *)sender{
    self.musicPlayer.volume = sender.value;
}

- (void)brightSliderChangeValue:(UISlider *)sender{
    [UIScreen mainScreen].brightness = sender.value;
}


#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = touches.anyObject;
    if ([touch.view isKindOfClass:[ClassroomPlayMoreView class]]) {
        self.hidden = YES;
    }
}

//倍速播放界面 入场动画
- (void)showSpeedViewMoveInAnimate{
    
    [UIView animateWithDuration:0.3 animations:^{
        if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {//竖屏
            self.hidden = YES;
        }else{//横屏
            self.hidden = NO;
            CGRect frame = self.containsView.frame;
            frame.origin.x = self.frame.size.width-300;
            self.containsView.frame = frame;
        }
    } completion:^(BOOL finished) {
    }];
}

//倍速播放界面  退场动画
- (void)showSpeedViewPushInAnimate{
    if (!self.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
                
            }else{
                CGRect frame = self.containsView.frame;
                frame.origin.x = Screen_W;
                self.containsView.frame = frame;
            }
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

#pragma mark - Setters




#pragma mark - Getters

- (UIView *)containsView{
    if (!_containsView) {
        _containsView = [[UIView alloc] init];
        _containsView.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:31.0/255.0 blue:33.0/255.0 alpha:0.90];
    }
    return _containsView;
}

- (UIImageView *)leftVolumeIV{
    if (!_leftVolumeIV) {
        _leftVolumeIV = [[UIImageView alloc] init];
        _leftVolumeIV.image = [UIImage imageNamed:@"avcSmallSound"];
    }
    return _leftVolumeIV;
}

- (UISlider *)volumeSlider{
    if (!_volumeSlider) {
        _volumeSlider = [[UISlider alloc] init];
        [_volumeSlider setThumbImage:[UIImage imageNamed:@"smallDots"] forState:UIControlStateNormal];
        [_volumeSlider setThumbImage:[UIImage imageNamed:@"smallDots"] forState:UIControlStateHighlighted];
        [_volumeSlider setValue:self.musicPlayer.volume];
        [_volumeSlider setMinimumTrackTintColor:[UIColor colorWithHexString:@"00c1de"]];
        
    }
    return _volumeSlider;
}

- (UIImageView *)rightVolumeIV{
    if (!_rightVolumeIV) {
        _rightVolumeIV = [[UIImageView alloc] init];
        _rightVolumeIV.image = [UIImage imageNamed:@"avcBigSound"];
    }
    return _rightVolumeIV;
}

- (UIImageView *)leftBrightIV{
    if (!_leftBrightIV) {
        _leftBrightIV = [[UIImageView alloc] init];
        _leftBrightIV.image = [UIImage imageNamed:@"smallBrightness"];
    }
    return _leftBrightIV;
}

- (UISlider *)brightSlider{
    if (!_brightSlider) {
        _brightSlider = [[UISlider alloc] init];
        [_brightSlider setThumbImage:[UIImage imageNamed:@"smallDots"] forState:UIControlStateNormal];
        [_brightSlider setThumbImage:[UIImage imageNamed:@"smallDots"] forState:UIControlStateHighlighted];
        [_brightSlider setValue:[UIScreen mainScreen].brightness];
        [_brightSlider setMinimumTrackTintColor:[UIColor colorWithHexString:@"00c1de"]];
        
    }
    return _brightSlider;
}

- (UIImageView *)rightBrightIV{
    if (!_rightBrightIV) {
        _rightBrightIV = [[UIImageView alloc] init];
        _rightBrightIV.image = [UIImage imageNamed:@"bigBrightness"];
    }
    return _rightBrightIV;
}


- (MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    }
    return _musicPlayer;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
        _tipLabel.backgroundColor = [UIColor blackColor];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

@end
