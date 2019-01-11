//
//  FWVoiceView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWVoiceView.h"
#import "LhkhIFlyMSCManager.h"
#import "CircularProgressBar.h"
#import <AVFoundation/AVFoundation.h>
@interface FWVoiceView()<UIGestureRecognizerDelegate,CircularProgressDelegate,UIAlertViewDelegate>
{
    CircularProgressBar *m_circularProgressBar;
}
@property (strong, nonatomic)UILabel *voiceLab;
@property (strong, nonatomic)UILabel *anLab;
@property (strong, nonatomic)UIView *bgImgView;
@property (strong, nonatomic)UIImageView *voiceImage;
@property (strong, nonatomic)UILabel *timeLab;
@end

@implementation FWVoiceView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_White;
        [self addSubview:self.voiceLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.anLab];
        [self addSubview:self.bgImgView];
        
        
        m_circularProgressBar = [[CircularProgressBar alloc] initWithFrame:CGRectZero];
        m_circularProgressBar.delegate = self;
        [m_circularProgressBar setTotalSecondTime:0];
        [self.bgImgView addSubview:m_circularProgressBar];
        [self.bgImgView addSubview:self.voiceImage];
        //实例化长按手势监听
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.5;
        [self.voiceImage addGestureRecognizer:longPress];
        [self layoutCustomViews];
        
    }
    return self;
}



#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.voiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.voiceLab.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(90);
        make.top.equalTo(self.timeLab.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [m_circularProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bgImgView);
    }];
    
    [self.voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(33);
        make.height.offset(52);
        make.centerY.equalTo(self.bgImgView.mas_centerY);
        make.centerX.equalTo(self.bgImgView.mas_centerX);
    }];
    
    [self.anLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.left.right.equalTo(self);
        make.top.equalTo(self.bgImgView.mas_bottom).offset(5);
    }];
}


#pragma mark - System Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - Custom Delegate

#pragma mark - progress bar delegate
- (void)CircularProgressEnd {
    [m_circularProgressBar stopTimer];
}

- (void)CircularProgress:(NSString *)time
{
    self.timeLab.text = time;
}

#pragma mark - Event Response


- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state ==  UIGestureRecognizerStateBegan) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (status == AVAuthorizationStatusNotDetermined) {
           [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                        // 授权成功
                        DLog(@"允许");
                        [self startClick:nil];
                    }else{
                        // 授权失败
                        DLog(@"拒绝");
                        [self setUpAlertViewWithMessage:@"麦克风已被禁止使用，为了您更好的体验，是否去重新设置？"];
                    }
            }];
        }else{
            if (status != AVAuthorizationStatusAuthorized) {
                [self setUpAlertViewWithMessage:@"麦克风已被禁止使用，为了您更好的体验，是否去重新设置？"];
            }else{
                [self startClick:nil];
            }
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self cancelClick:nil];
    }
    
}


- (void)startClick:(id)sender {
    DLog(@"start");
    NSString *voiceTime = [USER_DEFAULTS objectForKey:UD_VoiceTimeLimit];
    
    [m_circularProgressBar setTotalSecondTime:voiceTime.intValue];
    [m_circularProgressBar startTimer];
//    [[LhkhIFlyMSCManager shareManager] recognitionBlock:^(NSString *result) {
//        DLog(@"---voice--->%@",result);
//
//        if (self.voiceLab.text == nil || [self.voiceLab.text isEqualToString:@""]) {
//            self.voiceLab.text= result;
//        }else{
//            self.voiceLab.text=[NSString stringWithFormat:@"%@%@",self.voiceLab.text,result];
//        }
//
//        if (self.voiceLab.text == nil || self.voiceLab.text.length == 0 || [self.voiceLab.text isEqualToString:@""]) {
//            [MBProgressHUD showTips:@"请重新录入"];
//        }else{
//            if ([self.delegate respondsToSelector:@selector(FWVoiceViewDelegateWithText:)]) {
//                [self.delegate FWVoiceViewDelegateWithText:self.voiceLab.text];
//                self.voiceLab.text= @"";
//            }
//        }
//    }];
    
    [[LhkhIFlyMSCManager shareManager] recognitionBlock:^(NSString *result) {
        DLog(@"---voice--->%@",result);
        
//        if (self.voiceLab.text == nil || [self.voiceLab.text isEqualToString:@""]) {
//            self.voiceLab.text= result;
//        }else{
//            self.voiceLab.text=[NSString stringWithFormat:@"%@%@",self.voiceLab.text,result];
//        }
        
        if (result != nil && result.length != 0 && ![result isEqualToString:@""]) {
            if ([self.delegate respondsToSelector:@selector(FWVoiceViewDelegateWithText:)]) {
                [self.delegate FWVoiceViewDelegateWithText:result];
            }
        }
    } vctype:self.vctype];
}

- (void)cancelClick:(id)sender {
    
    [[LhkhIFlyMSCManager shareManager] stopRecognition];
    [self CircularProgressEnd];
    self.timeLab.text = @"00:00";
}

#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setUpAlertViewWithMessage:(NSString *)Message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:Message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


#pragma mark - Setters

- (UILabel*)voiceLab
{
    if (_voiceLab == nil) {
        _voiceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _voiceLab.textColor = Color_MainText;
        _voiceLab.font = systemFont(12);
        _voiceLab.numberOfLines = 0;
    }
    return _voiceLab;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.text = @"00:00";
        _timeLab.textColor = Color_MainText;
        _timeLab.font = systemFont(12);
        
    }
    return _timeLab;
}

- (UILabel*)anLab
{
    if (_anLab == nil) {
        _anLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _anLab.textColor = Color_SubText;
        _anLab.font = systemFont(12);
        _anLab.text = @"按住说话";
        _anLab.textAlignment = NSTextAlignmentCenter;
    }
    return _anLab;
}

- (UIView*)bgImgView
{
    if (_bgImgView == nil) {
        _bgImgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgImgView.backgroundColor = Color_White;
        _bgImgView.layer.cornerRadius = 45.f;
        _bgImgView.layer.masksToBounds = YES;
    }
    return _bgImgView;
}

- (UIImageView*)voiceImage
{
    if (_voiceImage == nil) {
        _voiceImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _voiceImage.image = [UIImage imageNamed:@"q_mic"];
        _voiceImage.userInteractionEnabled = YES;
    }
    return _voiceImage;
}



#pragma mark - Getters



@end
