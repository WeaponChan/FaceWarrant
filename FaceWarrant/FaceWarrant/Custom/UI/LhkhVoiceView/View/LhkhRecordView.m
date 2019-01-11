//
//  LhkhRecordView.m
//  FaceWarrant
//
//  Created by FW on 2018/11/1.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "LhkhRecordView.h"
#import "CircularProgressBar.h"
#import "LGAudioKit.h"
#import "LGMessageModel.h"
#import "OSSUploadFileManager.h"
#import <AVFoundation/AVFoundation.h>
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@interface LhkhRecordView()
<UIGestureRecognizerDelegate,CircularProgressDelegate,LGSoundRecorderDelegate,UIAlertViewDelegate>
{
    CircularProgressBar *m_circularProgressBar;
}
@property (strong, nonatomic) UILabel *anLab;
@property (strong, nonatomic) UIView *bgImgView;
@property (strong, nonatomic) UIImageView *voiceImage;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (weak, nonatomic)   NSTimer *timerOf60Second;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation LhkhRecordView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_White;
        [self addSubview:self.timeLab];
        [self addSubview:self.anLab];
        [self addSubview:self.bgImgView];
//        [self addSubview:self.cancelBtn];
        m_circularProgressBar = [[CircularProgressBar alloc] initWithFrame:CGRectZero type:@"record"];
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
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.width.offset(20);
//        make.top.equalTo(self).offset(15);
//        make.right.equalTo(self).offset(-15);
//    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self).offset(50);
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
        make.width.offset(40);
        make.height.offset(40);
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




/**
 *  开始录音
 */
- (void)startRecordVoice{
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //        //停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //        //开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopAndSendVedio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    if ([[LGSoundRecorder shareInstance] soundRecordTime] == 0) {
        [self cancelRecordVoice];
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:self];
        return;//60s自动发送后，松开手走这里
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    [self sendSound];
    [[LGSoundRecorder shareInstance] stopSoundRecord:self];
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [[LGSoundRecorder shareInstance] soundRecordFailed:self];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self];
}

- (void)sixtyTimeStopAndSendVedio {
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= 60 && [[LGSoundRecorder shareInstance] soundRecordTime] <= 60 + 1) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        //        [self.recordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

- (void)sendSound {
    LGMessageModel *messageModel = [[LGMessageModel alloc] init];
    NSString *wavFilePath = [[LGSoundRecorder shareInstance] soundFilePath];
    NSData *amrData = [[LGSoundRecorder shareInstance] convertCAFtoAMR:wavFilePath];
    // 将amr数据data写入到文件中
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"amrSoundFile"];
    NSString *fileName = [NSString stringWithFormat:@"/voice-%5.2f.amr", [[NSDate date] timeIntervalSince1970] ];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
    }
    NSString *amrfilePath = [filePath stringByAppendingPathComponent:fileName];
    [amrData writeToFile:amrfilePath atomically:YES];
    
    NSLog(@"-------%@",amrfilePath);
    messageModel.soundFilePath = amrfilePath;
    messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    [self.dataArray addObject:messageModel];
    DLog(@"423423424====%f",messageModel.seconds);
    [[OSSUploadFileManager sharedOSSManager] asyncOSSUploadAudio:amrfilePath complete:^(NSString *audioUrl, UploadImageState state) {
        DLog(@"---->%@--55555---%f",audioUrl,[[LGSoundRecorder shareInstance] soundRecordTime]);
        if ([self.delegate respondsToSelector:@selector(LhkhRecordViewDelegateAudio:audioTime:)]) {
            [self.delegate LhkhRecordViewDelegateAudio:audioUrl audioTime:[NSString stringWithFormat:@"%f",messageModel.seconds]];
        }
    }];
}

#pragma mark - LGSoundRecorderDelegate

- (void)showSoundRecordFailed{
    //    [[SoundRecorder shareInstance] soundRecordFailed:self];
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

- (void)didStopSoundRecord {
    
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
                    [self start];
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
                [self start];
            }
        }
    }
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self cancel];
    }
}

- (void)start{
    DLog(@"start");
    NSString *voiceTime = [USER_DEFAULTS objectForKey:UD_RecordingTimeLimit];
    [m_circularProgressBar setTotalSecondTime:voiceTime.intValue];
    [m_circularProgressBar startTimer];
    [self startRecordVoice];
}

- (void)cancel
{
    [self confirmRecordVoice];
    [self CircularProgressEnd];
    self.timeLab.text = @"00:00";
}

- (void)cancelClick
{
    if ([self.delegate respondsToSelector:@selector(LhkhRecordViewDelegateCancelClick)]) {
        [self.delegate LhkhRecordViewDelegateCancelClick];
    }
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setUpAlertViewWithMessage:(NSString *)Message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:Message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - Setters
- (UIButton*)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancelBtn setImage:Image(@"close") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
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
        _anLab.text = @"按住录音";
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
//        _voiceImage.image = [UIImage imageNamed:@"q_mic"];
        _voiceImage.layer.cornerRadius = 20.f;
        _voiceImage.layer.masksToBounds = YES;
        _voiceImage.backgroundColor = Color_Theme_Pink;
        _voiceImage.userInteractionEnabled = YES;
    }
    return _voiceImage;
}

#pragma mark - Getters



@end
