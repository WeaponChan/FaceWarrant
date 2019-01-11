//
//  ClassroomPopView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/12.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomPopView.h"

static const CGFloat ALYPVPopBackButtonWidth  = 24;  //返回按钮宽度

@interface ClassroomPopView()<ClassroomErrorViewDelegate>
@property (nonatomic, strong) UIButton *backBtn;            //返回按钮
@property (nonatomic, strong) ClassroomErrorView *errorView; //错误view
@property (nonatomic, assign) ALYPVPlayerPopCode code;//错误代码
@end

@implementation ClassroomPopView

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
     //   [self addSubview:self.backBtn];
        self.errorView.delegate = self;
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backBtn.frame = CGRectMake(8, (44-ALYPVPopBackButtonWidth)/2.0,ALYPVPopBackButtonWidth,ALYPVPopBackButtonWidth);
    self.errorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate
- (void)onErrorViewClickedWithType:(ALYPVErrorType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPopViewWithType:WithPopCode:)]) {
        [self.delegate showPopViewWithType:type WithPopCode:self.code];
    }
}



#pragma mark - Event Response

- (void)onClick:(UIButton *)btn {
    if (UIInterfaceOrientationPortrait != [[UIApplication sharedApplication] statusBarOrientation]) {
        [ClassroomPopView setFullOrHalfScreen];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBackClickedWithClassroomPopView:)]) {
            [self.delegate onBackClickedWithClassroomPopView:self];
        }
    }
}


#pragma mark - Network requests




#pragma mark - Public Methods

/*
 #define ALIYUNVODVIEW_UNKNOWN              @"未知错误"
 #define ALIYUNVODVIEW_PLAYFINISH           @"再次观看，请点击重新播放"
 #define ALIYUNVODVIEW_NETWORKTIMEOUT       @"当前网络不佳，请稍后点击重新播放"
 #define ALIYUNVODVIEW_NETWORKUNREACHABLE   @"无网络连接，检查网络后点击重新播放"
 #define ALIYUNVODVIEW_LOADINGDATAERROR     @"视频加载出错，请点击重新播放"
 #define ALIYUNVODVIEW_USEMOBILENETWORK     @"当前为移动网络，请点击播放"
 */
- (void)showPopViewWithCode:(ALYPVPlayerPopCode)code popMsg:(NSString *)popMsg {
    if ([_errorView isShowing]) {
        [_errorView dismiss];
    }
    
    
    self.code = code;
    NSBundle *resourceBundle = [NSBundle mainBundle];
    NSString *tempString = @"unknown";
    ALYPVErrorType type = ALYPVErrorTypeRetry;
    switch (code) {
        case ALYPVPlayerPopCodePlayFinish:
        {
            tempString = @"播放完毕";
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"Watch again, please click replay", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeReplay;
        }
            break;
        case ALYPVPlayerPopCodeNetworkTimeOutError :
        {
            tempString = @"请求超时";
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"The current network is not good. Please click replay later", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeReplay;
        }
            break;
        case ALYPVPlayerPopCodeUnreachableNetwork:
        {
           // tempString = [AliyunUtil networkUnreachableTips];
             tempString = @"当前没有网络";
            if (!tempString) {
                tempString = @"当前没有网络";//NSLocalizedStringFromTableInBundle(@"No network connection, check the network, click replay", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeReplay;
        }
            break;
        case ALYPVPlayerPopCodeLoadDataError :
        {
               tempString = @"数据未读取完";//popMsg;
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"Video loading error, please click replay", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeRetry;
        }
            break;
        case ALYPVPlayerPopCodeServerError:
        {
            tempString = @"服务器返回错误情况";//popMsg;
            type = ALYPVErrorTypeRetry;
        }
            break;
        case ALYPVPlayerPopCodeUseMobileNetwork:
        {
            
            tempString = @"当前使用流量 如要继续请点击play";
            if (!tempString) {
                tempString = @"当前使用流量 如要继续请点击play";//NSLocalizedStringFromTableInBundle(@"For mobile networks, click play", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypePause;
            
        }
            break;
        default:
            break;
    }
//    if(popMsg){
//        tempString = popMsg;
//    }
    self.errorView.message = tempString;
    self.errorView.type = type;
    if (code == ALYPVPlayerPopCodeServerError) {
        
        //阿里服务器返回错误 不给提示
    }else{
    [_errorView showWithParentView:self];
    }
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



#pragma mark - Private Methods




#pragma mark - Setters




#pragma mark - Getters

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"user-视频返回"];
        [_backBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (ClassroomErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[ClassroomErrorView alloc] init];
    }
    return _errorView;
}


@end
