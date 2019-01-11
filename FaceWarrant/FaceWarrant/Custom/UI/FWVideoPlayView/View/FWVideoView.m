//
//  FWVideoView.m
//  FaceWarrant
//
//  Created by FW on 2018/10/23.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWVideoView.h"
#import "FWVideoPlayControlView.h"

#import "ClassroomPopView.h"
#import "ClassroomPlayMoreView.h"
#import "ClassroomLoadingView.h"
#import "ClassroomErrorView.h"

#import "PlayAuthModel.h"

#import "AliyunReachability.h"
#import "AliyunLog.h"
#import "NSString+AlivcHelper.h"


static const CGFloat AlilyunViewLoadingViewWidth  = 130;
static const CGFloat AlilyunViewLoadingViewHeight = 120;

@interface FWVideoView()<AliyunVodPlayerDelegate,FWVideoPlayControlViewDelegate,ClassroomPopViewDelegate,ClassroomPlayBottomViewDelegate>
@property (nonatomic, strong) AliyunVodPlayer *aliPlayer;               //点播播放器
@property (nonatomic, strong) UIImageView *coverImageView;              //封面
@property (nonatomic, strong) FWVideoPlayControlView *controlView;      //各种交互控制界面
@property (nonatomic, strong) ClassroomPlayMoreView *moreView;          //更多界面
@property (nonatomic, strong) ClassroomPopView *popLayer;               //弹出的提示界面
@property (nonatomic, strong) ClassroomLoadingView *loadingView;        //loading

#pragma mark - data
@property (nonatomic, strong) AliyunReachability *reachability;         //网络监听
@property (nonatomic, assign) CGRect saveFrame;                         //记录竖屏时尺寸,横屏时为全屏状态。
@property (nonatomic, weak  ) NSTimer *timer;                           //计时器
@property (nonatomic, assign) NSTimeInterval currentDuration;           //记录播放时长
@property (nonatomic, copy  ) NSString *currentMediaTitle;              //设置标题，如果用户已经设置自己标题，不在启用请求获取到的视频标题信息。
@property (nonatomic, assign) BOOL isProtrait;                          //是否是竖屏
@property (nonatomic, assign) BOOL isRerty;                             //default：NO
@property (nonatomic, assign) float saveCurrentTime;                    //保存重试之前的播放时间
@property (nonatomic, assign) BOOL mProgressCanUpdate;                  //进度条是否更新，默认是NO
@property (nonatomic, strong) AliyunLog *playerViewLog;                 //日志
@property (nonatomic, assign) AliyunVodPlayerState currentPlayStatus;   //记录播放器的状态
@property (nonatomic, strong) PlayAuthModel * playAuthModel;            //播放的vid和playauth
@end

@implementation FWVideoView

#pragma mark - Life Cycle

- (instancetype)init{
    _mProgressCanUpdate = NO;
    return [self initWithFrame:CGRectZero];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //指记录竖屏时界面尺寸
    if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]){
        if (!self.fixedPortrait) {
            self.saveFrame = frame;
        }
    }
}

//初始化view
- (void)initView{
    self.aliPlayer.delegate = self;
    [self addSubview:self.aliPlayer.playerView];
    self.coverImageView.backgroundColor = [UIColor yellowColor];
//    [self addSubview:self.coverImageView];
//    self.controlView.delegate = self;
//    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
//    [self addSubview:self.controlView];    
//    [self addSubview:self.moreView];
    
    self.popLayer.delegate = self;
    [self addSubview:self.popLayer];
    [self addSubview:self.loadingView];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (self) {
            if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]){
                self.saveFrame = frame;
            }else{
                self.saveFrame = CGRectZero;
            }
            _mProgressCanUpdate = YES;
            //设置view
            [self initView];
            //屏幕旋转通知
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleDeviceOrientationDidChange:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object:nil
             ];
            
            //网络状态判定
            _reachability = [AliyunReachability reachabilityForInternetConnection];
            [_reachability startNotifier];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged)
                                                         name:AliyunPVReachabilityChangedNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(releasePlayerDealloc)
                                                         name:@"releasePlayerDealloc"
                                                       object:nil];
            //存储第一次触发saas
            //            NSString *str =   [[NSUserDefaults standardUserDefaults] objectForKey:@"aliyunVodPlayerFirstOpen"];
            //            if (!str) {
            //                [[NSUserDefaults standardUserDefaults] setValue:@"aliyun_saas_first_open" forKey:@"aliyunVodPlayerFirstOpen"];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
            //            }
        }
    }
    return self;
}

#pragma mark - dealloc

- (void)releasePlayerDealloc
{
    if (_aliPlayer) {
        [self releasePlayer];
    }
}

- (void)dealloc {
    if (_aliPlayer) {
        [self releasePlayer];
    }
}


#pragma mark - Layout SubViews

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    self.aliPlayer.playerView.frame = self.bounds;
    self.coverImageView.frame= self.bounds;
    self.controlView.frame = self.bounds;
    self.moreView.frame = self.bounds;
    self.popLayer.frame = self.bounds;
    self.popLayer.center = CGPointMake(width/2, height/2);
    
    float x = (self.bounds.size.width -  AlilyunViewLoadingViewWidth)/2;
    float y = (self.bounds.size.height - AlilyunViewLoadingViewHeight)/2;
    self.loadingView.frame = CGRectMake(x, y, AlilyunViewLoadingViewWidth, AlilyunViewLoadingViewHeight);
}


#pragma mark - System Delegate


#pragma mark - Custom Delegate

#pragma mark - AliyunVodPlayerDelegate
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    DLog(@"播放器事件回调:事件%ld,播放器状态:%ld",(long)event,(long)vodPlayer.playerState);
    //接收onEventCallback回调时，根据当前播放器事件更新UI播放器UI数据
    [self updateVodPlayViewDataWithEvent:event vodPlayer:vodPlayer];
    if(event == AliyunVodPlayerEventPlay || event == AliyunVodPlayerEventPrepareDone){
        //让错误的提示消失
        [self.loadingView dismiss];
        self.popLayer.hidden = YES;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    
    //取消屏幕锁定旋转状态
    [self unlockScreen];
    //关闭loading动画
    [_loadingView dismiss];
    
    //根据播放器状态处理seek时thumb是否可以拖动
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    //根据错误信息，展示popLayer界面
    [self showPopLayerWithErrorModel:errorModel];
    if(self.printLog) {
        NSLog(@" errorCode:%d errorMessage:%@",errorModel.errorCode,errorModel.errorMsg);
    }
}


//3.4.7
//- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer newPlayerState:(AliyunVodPlayerState)newState{
//
//    _currentPlayStatus = newState;
//}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer willSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition {
    self.mProgressCanUpdate = NO;
    //根据状态设置 controllayer 清晰度按钮 可用？
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    
    NSArray *ary = [FWVideoView allQualities];
    [self.controlView setQualityButtonTitle:ary[quality]];
    //选中切换
    [self.controlView.listView setCurrentQuality:quality];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition {
    self.mProgressCanUpdate = YES;
    
    NSArray *ary = [FWVideoView allQualities];
    [self.controlView setQualityButtonTitle:ary[quality]];
    //选中切换
    [self.controlView.listView setCurrentQuality:quality];
    NSString *showString = [NSString stringWithFormat:@"已为你切换至%@",[FWVideoView stringWithQuality:quality]];
    [MBProgressHUD showTips:showString toView:self];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition {
    [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeLoadDataError popMsg:nil];
    [self unlockScreen];
    
    NSArray *ary = [FWVideoView allQualities];
    [self.controlView setQualityButtonTitle:ary[quality]];
    //选中切换
    [self.controlView.listView setCurrentQuality:quality];
}

- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer *)vodPlayer{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onCircleStartWithVodPlayerView:)]) {
        [self.delegate onCircleStartWithVodPlayerView:self];
    }
}

- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer {
    //取消屏幕锁定旋转状态
    [self unlockScreen];
    //关闭loading动画
    [_loadingView dismiss];
    //根据播放器状态处理seek时thumb是否可以拖动
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    //根据错误信息，展示popLayer界面
    NSBundle *resourceBundle = [FWVideoView languageBundle];
    AliyunPlayerVideoErrorModel *errorModel = [[AliyunPlayerVideoErrorModel alloc] init];
    errorModel.errorCode = ALIVC_ERR_AUTH_EXPIRED;
    errorModel.errorMsg = NSLocalizedStringFromTableInBundle(@"ALIVC_ERR_AUTH_EXPIRED", nil, resourceBundle, nil);
    
    [self showPopLayerWithErrorModel:errorModel];
    if(self.printLog) {
        NSLog(@" errorCode:%d errorMessage:%@",errorModel.errorCode,errorModel.errorMsg);
    }
    
    //播放器鉴权数据过期回调，出现过期可重新prepare新的地址或进行UI上的错误提醒。
    DLog(@"鉴权过期");
    
}

/*
 *功能：播放过程中鉴权即将过期时提供的回调消息（过期前一分钟回调）
 *参数：videoid：过期时播放的videoId
 *参数：quality：过期时播放的清晰度，playauth播放方式和STS播放方式有效。
 *参数：videoDefinition：过期时播放的清晰度，MPS播放方式时有效。
 *备注：使用方法参考高级播放器-点播。
 */
- (void)vodPlayerPlaybackAddressExpiredWithVideoId:(NSString *)videoId quality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //鉴权有效期为2小时，在这个回调里面可以提前请求新的鉴权，stop上一次播放，prepare新的地址，seek到当前位置
    if (self.delegate &&[self.delegate respondsToSelector:@selector(FWVideoViewDelegatevodPlayerPlaybackAddressExpiredWithVideoId:quality:videoDefinition:)]) {
        [self.delegate FWVideoViewDelegatevodPlayerPlaybackAddressExpiredWithVideoId:videoId quality:quality videoDefinition:videoDefinition];
    }
    DLog(@"播放过程中鉴权过期");
}


#pragma mark - popdelegate

- (void)showPopViewWithType:(ALYPVErrorType)type WithPopCode:(ALYPVPlayerPopCode)code{
    self.popLayer.hidden = YES;
    switch (type) {
        case ALYPVErrorTypeReplay:
        {
            //重播
            [self.aliPlayer replay];
            [self.aliPlayer seekToTime:self.saveCurrentTime];
        }
            break;
        case ALYPVErrorTypeRetry:
        {
            [self stop];
            if (self.aliPlayer.autoPlay == NO) {
                self.aliPlayer.autoPlay = YES;
            }
            
            //重试播放
            if ([self networkChangedToShowPopView]) {
                return;
            }
            [self.aliPlayer prepareWithVid:self.playAuthModel.videoId
                                  playAuth:self.playAuthModel.playAuth];
            if(code == ALYPVPlayerPopCodeNetworkTimeOutError){
                if (self.delegate && [self.delegate respondsToSelector:@selector(FWVideoViewDelegateonTimeExpiredError)]) {
                    [self.delegate FWVideoViewDelegateonTimeExpiredError];
                }
            }
            //记录事件和时间
//            self.isRerty = YES;
//            self.saveCurrentTime = self.aliPlayer.currentTime;
        }
            break;
        case ALYPVErrorTypePause:
        {
            if (self.aliPlayer.playerState == AliyunVodPlayerStatePause){
                [self.aliPlayer resume];
            } else {
                if (self.aliPlayer.autoPlay == NO) {
                    self.aliPlayer.autoPlay = YES;
                }
                
                [self.aliPlayer prepareWithVid:self.playAuthModel.videoId
                                      playAuth:self.playAuthModel.playAuth];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - controlViewDelegate
- (void)onLockButtonClickedWithClassroomPlayControView:(FWVideoPlayControlView *)controlView{
    controlView.lockButton.selected = !controlView.lockButton.isSelected;
    self.isScreenLocked =controlView.lockButton.selected;
    //锁屏判定
    [controlView lockScreenWithIsScreenLocked:self.isScreenLocked fixedPortrait:self.fixedPortrait];
    if (!self.isScreenLocked) { //不在播放的时候 取消锁屏显示大播放按钮
        if (!self.isPlaying) {
            controlView.playButton.hidden = NO;
        }
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ClassroomPlayView:lockScreen:)]) {
        BOOL lScreen = self.isScreenLocked;
        if (self.isProtrait) {
            lScreen = YES;
        }
        [self.delegate ClassroomPlayView:self lockScreen:lScreen];
    }
}

- (void)onMoreViewClickedWithClassroomPlayControView:(FWVideoPlayControlView *)controlView {
    [self.moreView showSpeedViewMoveInAnimate];
}
#pragma mark - ClassroomControlViewDelegate

- (void)onBackViewClickWithClassroomPlayControView:(FWVideoPlayControlView *)controlView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithClassroomPlayView:)]){
        [self.delegate onBackViewClickWithClassroomPlayView:self];
    } else {
        [self stop];
    }
}

- (void)onClickedPlayButtonWithClassroomPlayControView:(FWVideoPlayControlView *)controlView{
    AliyunVodPlayerState state = self.aliPlayer.playerState;// [self playerViewState];
    
    if (state == AliyunVodPlayerStatePlay){
        [self pause];
    }else if (state == AliyunVodPlayerStatePrepared){
        [self start];
    }else if(state == AliyunVodPlayerStatePause){
        [self resume];
    }else if(state == AliyunVodPlayerStateFinish){
        
        //隐藏封面
        if (self.coverImageView) {
            self.coverImageView.hidden = YES;
        }
        [self replay];
    }
    
    //    if (state == AliyunVodPlayerStatePrepared ||state == AliyunVodPlayerStatePlay ||
    //        state == AliyunVodPlayerStatePause ||
    //        state == AliyunVodPlayerStateStop ||
    //        state == AliyunVodPlayerStateFinish ) {
    //        //隐藏封面
    //        if (self.coverImageView) {
    //            self.coverImageView.hidden = YES;
    //        }
    //    }else{
    //
    //        if (self.coverImageView) {
    //            self.coverImageView.hidden = NO;
    //        }
    //    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithClassroomPlayView:)]) {
        [self.delegate onClickedPlayButtonWithClassroomPlayView:self];
    }
    
    DLog(@"点击播放按钮");
    //获取最新状态
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    
    if (self.coverImageView) {
        self.coverImageView.hidden = YES;
    }
}

- (void)onClickedfullScreenButtonWithClassroomPlayControView:(FWVideoPlayControlView *)controlView{
    if(self.fixedPortrait){
        
        controlView.lockButton.hidden = self.isProtrait;
        if(!self.isProtrait){
            self.frame = CGRectMake(0, 0, Screen_W , Screen_H);
            self.isProtrait = YES;
            
        }else{
            self.frame = self.saveFrame;
            self.isProtrait = NO;
        }
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(ClassroomPlayView:fullScreen:)]) {
            [self.delegate ClassroomPlayView:self fullScreen:self.isProtrait];
        }
    }else{
        if(self.isScreenLocked){
            return;
        }
        [FWVideoView setFullOrHalfScreen];
    }
    controlView.isProtrait = self.isProtrait;
    [self setNeedsLayout];
}

- (void)ClassroomPlayControView:(FWVideoPlayControlView *)controlView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event{
    
    switch (event) {
        case UIControlEventTouchDown:
        {
            self.mProgressCanUpdate = NO;
        }
            break;
        case UIControlEventValueChanged:
        {
            self.mProgressCanUpdate = NO;
        }
            break;
        case UIControlEventTouchUpInside:
        {
            self.mProgressCanUpdate = YES;
            [self.aliPlayer seekToTime:progressValue*self.aliPlayer.duration];
            AliyunVodPlayerState state = self.aliPlayer.playerState;
            if (state == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
        }
            break;
        case UIControlEventTouchUpOutside:{
            self.mProgressCanUpdate = YES;
            [self.aliPlayer seekToTime:progressValue*self.aliPlayer.duration];
            AliyunVodPlayerState state = self.aliPlayer.playerState;
            if (state == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
        }
            break;
            //点击事件
        case UIControlEventTouchDownRepeat:{
            self.mProgressCanUpdate = YES;
            [self.aliPlayer seekToTime:progressValue*self.aliPlayer.duration];
        }
            break;
            
        default:
            self.mProgressCanUpdate = YES;
            break;
    }
    
    
    
}

- (void)ClassroomPlayControView:(FWVideoPlayControlView *)controlView qualityListViewOnItemClick:(int)index{
    //暂停状态切换清晰度
    if(self.aliPlayer.playerState == AliyunVodPlayerStatePause){
        [self.aliPlayer resume];;
    }
    //切换清晰度
    [self.aliPlayer setQuality:index];
}

#pragma mark - Event Response


#pragma mark - Network Requests


#pragma mark - Public Methods

/*
 * 功能 ： 接收onEventCallback回调时，根据当前播放器事件更新UI播放器UI数据
 * 参数：
 */
- (void)updateVodPlayViewDataWithEvent:(AliyunVodPlayerEvent)event vodPlayer:(AliyunVodPlayer *)vodPlayer{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayView:happen:)]){
        [self.delegate ClassroomPlayView:self happen:event];
    }
    [self.controlView updateViewWithPlayerState:vodPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
        {
            //关闭loading动画
            [_loadingView dismiss];
            DLog(@"播放器:准备播放完成");
            //保存获取的的播放器信息 ，需要优化。
            self.currentDuration = vodPlayer.duration;
            //更新controlLayer界面ui数据
            [self updateControlLayerDataWithMediaInfo:[self.aliPlayer getAliyunMediaInfo]];
            if (self.coverImageView) {
                self.coverImageView.hidden = NO;
            }
            
        }
            break;
        case  AliyunVodPlayerEventFirstFrame:
        {
            //sdk内部无计时器，需要获取currenttime；注意 NSRunLoopCommonModes
            NSTimer * tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSRunLoopCommonModes];
            self.timer = tempTimer;
            
            [self.controlView setEnableGesture:YES];
            if((int)self.aliPlayer.quality >= 0){
                [self.controlView setCurrentQuality:self.aliPlayer.quality];
            }else{
                [self.controlView setCurrentDefinition:self.aliPlayer.videoDefinition];
            }
            
            //开启常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            //            //隐藏封面
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
                DLog(@"播放器:首帧加载完成封面隐藏");
            }
        }
            break;
        case AliyunVodPlayerEventPlay:
            
            //            AliyunVodPlayerStatePrepared,           //已准备好
            //            AliyunVodPlayerStatePlay,               //播放
            //            AliyunVodPlayerStatePause,              //暂停
            //            AliyunVodPlayerStateStop,               //停止
            //            AliyunVodPlayerStateFinish,             //播放完成
            
            //            if (vodPlayer.playerState == AliyunVodPlayerStatePrepared ||vodPlayer.playerState == AliyunVodPlayerStatePlay ||
            //                vodPlayer.playerState == AliyunVodPlayerStatePause ||
            //                vodPlayer.playerState == AliyunVodPlayerStateStop ||
            //                vodPlayer.playerState == AliyunVodPlayerStateFinish ) {
            
            //隐藏封面
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
            }
            //            }else{
            //
            //                if (self.coverImageView) {
            //                    self.coverImageView.hidden = NO;
            //                }
            //            }
            
            break;
        case AliyunVodPlayerEventPause:
        {
            //播放器暂停回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayView:onPause:)]) {
                NSTimeInterval time = vodPlayer.currentTime;
                [self.delegate ClassroomPlayView:self onPause:time];
            }
            if (self.coverImageView) {
                self.coverImageView.hidden = NO;
            }
        }
            break;
        case AliyunVodPlayerEventFinish:{
            
            //播放完成回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(onFinishWithClassroomPlayView:)]) {
                [self.delegate onFinishWithClassroomPlayView:self];
            }
            //播放完成
            //            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodePlayFinish popMsg:nil];
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
            }
            
            [self unlockScreen];
        }
            break;
        case AliyunVodPlayerEventStop: {
            //stop 回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayView:onStop:)]) {
                NSTimeInterval time = vodPlayer.currentTime;
                [self.delegate ClassroomPlayView:self onStop:time];
            }
            //取消常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            //隐藏封面
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
                DLog(@"播放器:播放停止封面隐藏");
            }
        }
            break;
        case AliyunVodPlayerEventSeekDone :{
            self.mProgressCanUpdate = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayView:onSeekDone:)]) {
                [self.delegate ClassroomPlayView:self onSeekDone:vodPlayer.currentTime];
            }
            
        }
            break;
        case AliyunVodPlayerEventBeginLoading: {
            //展示loading动画
            [_loadingView show];
            self.controlView.playButton.hidden = YES;
            //  self.controlView.playButton.backgroundColor = UIColor.redColor;
        }
            break;
        case AliyunVodPlayerEventEndLoading: {
            //关闭loading动画
            [_loadingView dismiss];
            self.controlView.playButton.hidden = NO;
            //         self.controlView.playButton.backgroundColor = UIColor.greenColor;
            
            self.mProgressCanUpdate = YES;
        }
            break;
        default:
            break;
    }
}

//更新controlLayer界面ui数据
- (void)updateControlLayerDataWithMediaInfo:(AliyunVodPlayerVideo *)mediaInfo{
    //以用户设置的为先，标题和封面,用户在控制台设置coverurl地址
    if (!self.coverUrl && mediaInfo.coverUrl && mediaInfo.coverUrl.length>0) {
        [self updateCoverWithCoverUrl:mediaInfo.coverUrl];
    }
    //设置数据
    self.controlView.videoInfo = mediaInfo;
    //标题, 未播放URL 做备用判定
    if (!self.currentMediaTitle) {
        if (mediaInfo.title && mediaInfo.title.length>0) {
            self.controlView.title = mediaInfo.title;
        }
    }else{
        self.controlView.title = self.currentMediaTitle;
    }
}

//更新封面图片
- (void)updateCoverWithCoverUrl:(NSString *)coverUrl{
    //以用户设置的为先，标题和封面,用户在控制台设置coverurl地址
    if (self.coverImageView) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.coverImageView.image = [UIImage imageWithData:data];
                if (!self.coverImageView.hidden) {
                    self.coverImageView.hidden = NO;
                    DLog(@"播放器:展示封面");
                }
            });
        });
    }
}


//根据错误信息，展示popLayer界面
- (void)showPopLayerWithErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    switch (errorModel.errorCode) {
        case ALIVC_SUCCESS:
            break;
        case ALIVC_ERR_LOADING_TIMEOUT:
        {
            [self.popLayer showPopViewWithCode:    ALYPVPlayerPopCodeNetworkTimeOutError popMsg:nil];
            [self unlockScreen];
        }
            break;
        case ALIVC_ERR_REQUEST_DATA_ERROR:
        case ALIVC_ERR_INVALID_INPUTFILE:
        case ALIVC_ERR_INVALID_PARAM:
        case ALIVC_ERR_AUTH_EXPIRED:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(FWVideoViewDelegateonTimeExpiredError)]) {
                [self.delegate FWVideoViewDelegateonTimeExpiredError];
            }
        }
        case ALIVC_ERR_NO_INPUTFILE:
        case ALIVC_ERR_VIDEO_FORMAT_UNSUPORTED:
        case ALIVC_ERR_PLAYAUTH_PARSE_FAILED:
        case ALIVC_ERR_DECODE_FAILED:
        case ALIVC_ERR_NO_SUPPORT_CODEC:
        case ALIVC_ERR_REQUEST_ERROR:
        case ALIVC_ERR_QEQUEST_SAAS_SERVER_ERROR:
        case ALIVC_ERR_QEQUEST_MTS_SERVER_ERROR:
        case ALIVC_ERR_SERVER_INVALID_PARAM:
        case ALIVC_ERR_NO_VIEW:
        case ALIVC_ERR_NO_MEMORY:
        case ALIVC_ERR_ILLEGALSTATUS:
        {
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeServerError popMsg:errorModel.errorMsg];
            [self unlockScreen];
        }
            break;
        case ALIVC_ERR_READ_DATA_FAILED:
        {
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeLoadDataError popMsg:nil];
            [self unlockScreen];
        }
            break;
        default:
            break;
    }
}

- (void)playViewPrepareWithVid:(NSString *)vid playAuth : (NSString *)playAuth{
    
    self.playAuthModel = [[PlayAuthModel alloc] init];
    self.playAuthModel.videoId = vid;
    self.playAuthModel.playAuth = playAuth;
    if ([self networkChangedToShowPopView]) {
        return;
    }
    [_loadingView show];
    [self.aliPlayer prepareWithVid:vid playAuth:playAuth];
}

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
#pragma mark - timerRun
- (void)timerRun{
    if (self.aliPlayer && self.mProgressCanUpdate) {
        NSTimeInterval loadTime = self.aliPlayer.loadedTime;
        float changeLoadTime = (self.currentDuration == 0) ?: (loadTime / self.currentDuration);
        NSTimeInterval currentTime = self.aliPlayer.currentTime;
        NSTimeInterval durationTime = self.aliPlayer.duration;
        AliyunVodPlayerState state = (AliyunVodPlayerState)self.aliPlayer.playerState;
        self.controlView.state = state;
        self.controlView.loadTimeProgress = changeLoadTime;
        if (self.aliPlayer.currentTime > 0) {
            self.saveCurrentTime = self.aliPlayer.currentTime;
        }
        // NSLog(@"播放时间记录:%0.2f",self.saveCurrentTime);
        if (state == AliyunVodPlayerStatePlay || state == AliyunVodPlayerStatePause) {
            //            if(self.isRerty){
            //                [self.aliPlayer seekToTime:self.saveCurrentTime];
            //                self.isRerty = NO;
            //                return;
            //            }
            [self.controlView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
        }
    }
}


#pragma mark - playManagerAction
- (void)start {
    [self.aliPlayer start];
    NSLog(@"播放器start");
}

- (void)pause{
    [self.aliPlayer pause];
    NSLog(@"播放器pause");
}

- (void)resume{
    [self.aliPlayer resume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomPlayView:onResume:)]) {
        NSTimeInterval time = self.aliPlayer.currentTime;
        [self.delegate ClassroomPlayView:self onResume:time];
    }
    NSLog(@"播放器resume");
}

- (void)stop {
    [self.aliPlayer stop];
    NSLog(@"播放器stop");
}

- (void)replay{
    [self.aliPlayer replay];
    NSLog(@"播放器replay");
}

- (void)reset{
    [self.aliPlayer reset];
    [self.controlView updateProgressWithCurrentTime:self.aliPlayer.currentTime durationTime:self.aliPlayer.duration];//重置进度条
    
    NSLog(@"播放器reset");
}

- (void)releasePlayer {
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliyunPVReachabilityChangedNotification object:self.aliPlayer];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_aliPlayer) {
        [_aliPlayer releasePlayer];
        _aliPlayer = nil;
    }
    //开启休眠
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - 播放器当前状态
- (AliyunVodPlayerState)playerViewState {
    return _currentPlayStatus;
}

#pragma mark - 媒体信息
- (AliyunVodPlayerVideo *)getAliyunMediaInfo{
    return  [self.aliPlayer getAliyunMediaInfo];
}

#pragma mark - 边播边下判定
- (void) setPlayingCache:(BOOL)bEnabled saveDir:(NSString*)saveDir maxSize:(int64_t)maxSize maxDuration:(int)maxDuration{
    [self.aliPlayer setPlayingCache:bEnabled saveDir:saveDir maxSize:maxSize maxDuration:maxDuration];
}

#pragma mark - Private Methods

//网络状态判定
- (BOOL)networkChangedToShowPopView{
    BOOL ret = NO;
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            if (self.aliPlayer.autoPlay) {
                self.aliPlayer.autoPlay = NO;
            }
            [self pause];
            [self unlockScreen];
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUseMobileNetwork popMsg:nil];
            [_loadingView dismiss];
            NSLog(@"播放器展示4G提醒");
            
            ret = YES;
        }
            break;
        default:
            break;
    }
    return ret;
}


#pragma mark - 网络状态改变
- (void)reachabilityChanged{
    AliyunPVNetworkStatus status = [self.reachability currentReachabilityStatus];
    if (status == AliyunPVNetworkStatusNotReachable) {
        [MBProgressHUD showError:@"当前无网络,请检查网络连接"];
        [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUnreachableNetwork popMsg:nil];
    }else if (status == AliyunPVNetworkStatusReachableViaWWAN){
        [MBProgressHUD showError:@"当前使用流量"];
        [self.aliPlayer stop];
        [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUseMobileNetwork popMsg:nil];
    }else if (status == AliyunPVNetworkStatusReachableViaWiFi){
        DLog(@"当前使用wifi");
        self.popLayer.hidden = YES;
        [self.aliPlayer prepareWithVid:self.playAuthModel.videoId
                              playAuth:self.playAuthModel.playAuth];
    }
}




#pragma mark - 屏幕旋转
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    UIDevice *device = [UIDevice currentDevice] ;
    if (self.isScreenLocked) {
        return;
    }
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            self.frame = CGRectMake(0, 0, Screen_W, Screen_H);
            //            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"aliyunVodPlayerFirstOpen"];
            //            if ([str isEqualToString:@"aliyun_saas_first_open"]) {
            //                [[NSUserDefaults standardUserDefaults] setValue:@"aliyun_saas_no_first_open" forKey:@"aliyunVodPlayerFirstOpen"];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
            //   [self addSubview:self.guideView];
            //            }
            
            if (self.delegate &&[self.delegate respondsToSelector:@selector(ClassroomPlayView:fullScreen:)]) {
                [self.delegate ClassroomPlayView:self fullScreen:YES];
            }
        }
            break;
        case UIDeviceOrientationPortrait:
        {
            
            //去掉此部分  防止退出当前页面时播放器页面9/16
//            if (self.saveFrame.origin.x == 0 && self.saveFrame.origin.y==0 && self.saveFrame.size.width == 0 && self.saveFrame.size.height == 0) {
//                //开始时全屏展示，self.saveFrame = CGRectZero, 旋转竖屏时做以下默认处理
//                CGRect tempFrame = self.frame ;
//                tempFrame.size.width = self.frame.size.height;
//                tempFrame.size.height = self.frame.size.height* 9/16;
//                self.frame = tempFrame;
//            }else{
//                self.frame = self.saveFrame;
//
//            }
//            //2018-6-28 cai
//            BOOL isFullScreen = YES;
//            if (self.frame.size.width > self.frame.size.height) {
//                isFullScreen = NO;
//            }
//            if (self.delegate &&[self.delegate respondsToSelector:@selector(ClassroomPlayView:fullScreen:)]) {
//                [self.delegate ClassroomPlayView:self fullScreen:isFullScreen];
//            }
            //  [self.guideView removeFromSuperview];
            
            
        }
            break;
        default:
            break;
    }
}

//取消屏幕锁定旋转状态
- (void)unlockScreen{
    //弹出错误窗口时 取消锁屏。
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ClassroomPlayView:lockScreen:)]) {
        if (self.isScreenLocked == YES||self.fixedPortrait) {
            [self.delegate ClassroomPlayView:self lockScreen:NO];
            //弹出错误窗口时 取消锁屏。
            [self.controlView cancelLockScreenWithIsScreenLocked:self.isScreenLocked fixedPortrait:self.fixedPortrait];
            self.isScreenLocked = NO;
        }
    }
}

- (void)setUIStatusToReplay{
    [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUseMobileNetwork  popMsg:@"重播"];
}

+ (NSString *)stringWithQuality:(AliyunVodPlayerVideoQuality )quality{
    switch (quality) {
        case AliyunVodPlayerVideoFD:
            return [@"流畅" localString];
            break;
        case AliyunVodPlayerVideoLD:
            return [@"普清清" localString];
            break;
        case AliyunVodPlayerVideoSD:
            return [@"标清" localString];
            break;
        case AliyunVodPlayerVideoHD:
            return [@"高清" localString];
            break;
        case AliyunVodPlayerVideo2K:
            return [@"2K" localString];
            break;
        case AliyunVodPlayerVideo4K:
            return [@"4K" localString];
            break;
        case AliyunVodPlayerVideoOD:
            return [@"原画" localString];
            break;
            
        default:
            break;
    }
    return @"";
}

#pragma mark - Setters

- (void)setCoverUrl:(NSURL *)coverUrl{
    _coverUrl = coverUrl;
    if (coverUrl) {
        if (self.coverImageView) {
            
            self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:coverUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.coverImageView.image = [UIImage imageWithData:data];
                    
                    //  [self.coverImageView sd_setImageWithURL:coverUrl placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                    self.coverImageView.hidden = NO;
                    NSLog(@"播放器:展示封面");
                });
            });
        }
    }
}
#pragma mark - 清晰度
- (void)setQuality:(AliyunVodPlayerVideoQuality)quality{
    self.aliPlayer.quality = quality;
}
- (AliyunVodPlayerVideoQuality)quality{
    return self.aliPlayer.quality;
}
#pragma mark - MTS清晰度
- (void)setVideoDefinition:(NSString *)videoDefinition{
    self.aliPlayer.videoDefinition = videoDefinition;
}
- (NSString*)videoDefinition{
    return self.aliPlayer.videoDefinition;
}
#pragma mark - 缓冲的时长，毫秒
- (NSTimeInterval)bufferPercentage{
    return self.aliPlayer.bufferPercentage;
}
#pragma mark - 自动播放
- (void)setAutoPlay:(BOOL)autoPlay {
    [self.aliPlayer setAutoPlay:autoPlay];
}
#pragma mark - 循环播放
- (void)setCirclePlay:(BOOL)circlePlay{
    [self.aliPlayer setCirclePlay:circlePlay];
}
- (BOOL)circlePlay{
    return self.aliPlayer.circlePlay;
}
#pragma mark - 截图
- (UIImage *)snapshot{
    return  [self.aliPlayer snapshot];
}
#pragma mark - 浏览方式
- (void)setDisplayMode:(AliyunVodPlayerDisplayMode)displayMode{
    [self.aliPlayer setDisplayMode:displayMode];
}
- (void)setMuteMode:(BOOL)muteMode{
    [self.aliPlayer setMuteMode: muteMode];
}
#pragma mark - 是否正在播放中
- (BOOL)isPlaying{
    return [self.aliPlayer isPlaying];
}
#pragma mark - 播放总时长
- (NSTimeInterval)duration{
    return  [self.aliPlayer duration];
}
#pragma mark - 当前播放时长
- (NSTimeInterval)currentTime{
    return  [self.aliPlayer currentTime];
}
#pragma mark - 缓冲的时长，秒
- (NSTimeInterval)loadedTime{
    return  [self.aliPlayer loadedTime];
}
#pragma mark - 播放器宽度
- (int)videoWidth{
    return [self.aliPlayer videoWidth];
}
#pragma mark - 播放器高度
- (int)videoHeight{
    return [self.aliPlayer videoHeight];
}
#pragma mark - 设置绝对竖屏
- (void)setFixedPortrait:(BOOL)fixedPortrait{
    _fixedPortrait = fixedPortrait;
    if(fixedPortrait){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }else{
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];
    }
}

#pragma mark - timeout
- (void)setTimeout:(int)timeout{
    [self.aliPlayer setTimeout:timeout];
}
- (int)timeout{
    return  self.aliPlayer.timeout;
}

#pragma mark - 打印日志
- (void)setPrintLog:(BOOL)printLog{
    if (self.playerViewLog) {
        self.playerViewLog.isPrintLog = printLog;
    }
    [self.aliPlayer setPrintLog:printLog];
}
- (BOOL)isPrintLog{
    return self.aliPlayer.printLog;
}


#pragma mark - Getters
- (AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor clearColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (FWVideoPlayControlView *)controlView{
    if (!_controlView) {
        _controlView = [[FWVideoPlayControlView alloc] init];
    }
    return _controlView;
}

- (ClassroomPlayMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[ClassroomPlayMoreView alloc] init];
    }
    return  _moreView;
}

- (ClassroomPopView *)popLayer{
    if (!_popLayer) {
        _popLayer = [[ClassroomPopView alloc] init];
        _popLayer.frame = self.bounds;
        _popLayer.hidden = YES;
    }
    return _popLayer;
}

- (ClassroomLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[ClassroomLoadingView alloc] init];
    }
    return _loadingView;
}

- (AliyunLog *)playerViewLog{
    if (!_playerViewLog) {
        _playerViewLog = [[AliyunLog alloc] init];
        _playerViewLog.isPrintLog = NO;
    }
    return _playerViewLog;
}
//"fd_definition" = "流畅";
//"ld_definition" = "标清";
//"sd_definition" = "高清";
//"hd_definition" = "超清";
//"2k_definition" = "2K";
//"4k_definition" = "4K";
//"od_definition" = "OD";
//获取所有已知清晰度泪飙
+ (NSArray<NSString *> *)allQualities {
    return @[@"流畅",
             @"普清",
             @"标清",
             @"高清",
             @"2K",
             @"4K",
             @"原画"
             ];
}
+ (NSBundle *)languageBundle {
    NSBundle *resourceBundle = [NSBundle mainBundle];
    return resourceBundle;
}
#pragma mark - Getters


@end
