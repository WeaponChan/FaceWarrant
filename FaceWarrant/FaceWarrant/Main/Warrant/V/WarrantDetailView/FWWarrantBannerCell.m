//
//  FWWarrantBannerCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantBannerCell.h"
#import "LhkhImageSlideScrollView.h"
#import "FWWarrantDetailModel.h"
#import "ItemListImageModel.h"
#import "FWOSSConfigManager.h"
#import "FWVideoView.h"

@interface FWWarrantBannerCell ()<LhkhImageSlideScrollViewDelegate,UIAlertViewDelegate,FWVideoViewDelegate>
{
    NSString *_netWorkStatus;
    NSString *_playAuth;
}
@property (strong, nonatomic) LhkhImageSlideScrollView *imgSlideView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) FWWarrantDetailModel *model;
@property (strong, nonatomic) FWVideoView *playerView;
//控制锁屏
@property (nonatomic, assign)BOOL isLock;
@end

@implementation FWWarrantBannerCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantBannerCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantBannerCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.playBtn.hidden = YES;
        [self.playerView stop];
        [self.playerView playViewPrepareWithVid:self.model.videoUrl playAuth:self->_playAuth];
    }
}

#pragma mark - Custom Delegate

#pragma mark -LhkhImageSlideScrollViewDelegate
- (void)LhkhImageSlideScrollViewDelegateWithHeight:(CGFloat)height
{
    if ([self.celldelegate respondsToSelector:@selector(FWWarrantBannerCellDelegateWithHeight:)]) {
        [self.celldelegate FWWarrantBannerCellDelegateWithHeight:height];
    }
}


#pragma mark -FWVideoViewDelegate
//鉴权过期
- (void)FWVideoViewDelegateonTimeExpiredError{
    DLog(@"鉴权过期了");
    [self getPalyAuthWith:self.model.videoUrl];
}

- (void)onClickedPlayButtonWithClassroomPlayView:(FWVideoView *)controlView{

}

- (void)onBackViewClickWithClassroomPlayView:(FWVideoView *)playerView{
//    [self returnAction];
}

- (void)ClassroomPlayView:(FWVideoView *)playerView happen:(AliyunVodPlayerEvent)event{
    //日志事件
}

- (void)ClassroomPlayView:(FWVideoView*)playerView onPause:(NSTimeInterval)currentPlayTime{
    DLog(@"onPause");
}

- (void)ClassroomPlayView:(FWVideoView*)playerView onResume:(NSTimeInterval)currentPlayTime{
    DLog(@"onResume");
}

- (void)ClassroomPlayView:(FWVideoView*)playerView onStop:(NSTimeInterval)currentPlayTime{
    DLog(@"onStop");
}

- (void)ClassroomPlayView:(FWVideoView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
    DLog(@"onSeekDone");
}

-(void)onFinishWithClassroomPlayView:(FWVideoView *)playerView{
    DLog(@"onFinish");
    self.playBtn.hidden = NO;
}

- (void)ClassroomPlayView:(FWVideoView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}


- (void)ClassroomPlayView:(FWVideoView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

//点击全屏
- (void)ClassroomPlayView:(FWVideoView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
//    self.isStatusHidden = isFullScreen  ;
//    [self refreshUIWhenScreenChanged:isFullScreen];
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)ClassroomPlayView:(FWVideoView *)playerView onVideoDefinitionChanged:(NSString *)videoDefinition {
    
}

- (void)onCircleStartWithVodPlayerView:(FWVideoView *)playerView {
    
}

- (void)ClassroomPlayViewvodPlayerPlaybackAddressExpiredWithVideoId:(NSString *)videoId quality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition
{
    [self getPalyAuthWith:self.model.videoUrl];
}



#pragma mark - Event Response
- (void)playClick:(UIButton*)sender
{
    if ([_netWorkStatus isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前网络非WiFi状态下，继续播放？" delegate:self cancelButtonTitle:@"残忍离开" otherButtonTitles:@"继续播放", nil];
        [alert show];
    }else{
        if (_playAuth) {
            self.playBtn.hidden = YES;
            [self.playerView stop];
            [self.playerView playViewPrepareWithVid:self.model.videoUrl playAuth:self->_playAuth];
        }else{
            [self getPalyAuthWith:self.model.videoUrl];
        }
    }
}

- (void)changeNetwork:(NSNotification*)notif
{
    _netWorkStatus = [notif userInfo][@"netWork"];
}


#pragma mark - Network requests

- (void)getPalyAuthWith:(NSString*)vid
{
    NSDictionary *param = @{
                            @"videoId":vid
                            };
    [FWOSSConfigManager loadOSSGetVideoPlayAuth:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            self.playBtn.hidden = YES;
            self->_playAuth = response[@"result"][@"playAuth"];
            [self.playerView stop];
            [self.playerView playViewPrepareWithVid:self.model.videoUrl playAuth:self->_playAuth];
        }
    }];
}


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithData:(FWWarrantDetailModel*)model
{
    self.model = model;
    if ([model.modelType isEqualToString:@"1"]) {
        self.playBtn.hidden = NO;
        self.playerView.hidden = NO;
        [self getPalyAuthWith:model.videoUrl];
    }else{
        self.playBtn.hidden = YES;
        self.playerView.hidden = YES;
    }
    NSString *modelUrl = model.modelUrl;
    NSString *height = model.height;
    NSString *width = model.width;
    NSArray *arr = @[
                        @{
                            @"original" : modelUrl?:@"",
                            @"height" : height?:@"100",
                            @"width" : width?:@"100"
                        }
                     ];
    self.images = [ItemListImageModel mj_objectArrayWithKeyValuesArray:arr];
    [self.imgSlideView slidingViewWithMMutableArray:self.images];
}

#pragma mark - Private Methods

-(void)initView{
    
    self.imgSlideView = [[LhkhImageSlideScrollView alloc]initWithFrame:CGRectZero];
    self.imgSlideView.imageslidDelegate = self;
    [self.contentView addSubview:self.imgSlideView];
    [self.contentView addSubview:self.playerView];
    [self.contentView addSubview:self.playBtn];
    [self.imgSlideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.centerX.equalTo(self.imgSlideView.mas_centerX);
        make.centerY.equalTo(self.imgSlideView.mas_centerY);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetwork:) name:Notif_MonitorNetworking object:nil];
}


#pragma mark - Setters
- (NSMutableArray*)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (UIButton *)playBtn
{
    if (_playBtn == nil) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _playBtn.hidden = YES;
        [_playBtn setImage:Image(@"warrant_play") forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

/**
 播放视图
 */
- (FWVideoView *__nullable)playerView{
    if (!_playerView) {
        CGFloat width = 0;
        CGFloat height = 0;
        CGFloat topHeight = 0;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait ) {
            width = Screen_W;
            height = Screen_W * 9 / 16.0;
            topHeight =  NavigationBar_H;
        }else{
            width = Screen_W;
            height = Screen_H;
            topHeight = 0;
        }
        /****************UI播放器集成内容**********************/
        _playerView = [[FWVideoView alloc] initWithFrame:CGRectZero];
        _playerView.hidden = YES;
        [_playerView setDelegate:self];
        [_playerView setAutoPlay:YES];
        
        [_playerView setPrintLog:YES];
    
//        _playerView.isScreenLocked = true;
//        _playerView.fixedPortrait = true;
//        self.isLock = self.playerView.isScreenLocked||self.playerView.fixedPortrait?YES:NO;
//        //边下边播缓存沙箱位置
//        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docDir = [pathArray objectAtIndex:0];
//        //maxsize:单位 mb    maxDuration:单位秒 ,在prepare之前调用。
//        [_playerView setPlayingCache:YES saveDir:docDir maxSize:300 maxDuration:10000];
    }
    return _playerView;
}

#pragma mark - Getters


@end
