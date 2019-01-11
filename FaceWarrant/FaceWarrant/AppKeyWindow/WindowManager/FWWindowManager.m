//
//  FWWindowManager.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/7.
//  Copyright © 2018年 LHKH. All rights reserved.
//


#import "FWWindowManager.h"
#import "FWTabBarViewController.h"
#import "FWWelcomeViewController.h"
#import "LhkhNewFeatureVC.h"
#import "FWLoginVC.h"
#import "FWWarrantDetailVC.h"
#import "FWSearchVC.h"


#import "AppDelegate.h"
#import "FWOSSResponse.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "FWOSSConfigManager.h"

static FWWindowManager *instance = nil;

@interface FWWindowManager ()
{
    NSString *_flag;
}
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) FWTabBarViewController *tabBarVC;
@property (nonatomic, strong) FWWelcomeViewController *welcomeVC;
@end
@implementation FWWindowManager


#pragma  mark life
+ (instancetype)sharedWindow
{
    return [[self alloc] init];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}

- (id)init
{
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super init];
        });
    }
    return instance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_UserWillLogout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_ModifyPassWord object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_ChangePhoneNo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_showLoginView object:nil];
}



#pragma privary mothed
- (void)showKeyWindowRootVC:(UIWindow*)window
{
    [self loadSIMCardInfo];
    [self initUserDefaults];
    [self registerNotifications];
    [self loadOSSproperty];
    [self loadlimitTime];
    [self isShowBuy];
    self.keyWindow = window;
    self.keyWindow.backgroundColor = [UIColor whiteColor];
    
    NSString *userId = [USER_DEFAULTS objectForKey:UD_UserID];

    if (userId && userId != nil && ![userId isEqualToString:@""]) {
        [self showTabbarView:nil];
    }else{
        self.keyWindow.rootViewController = self.welcomeVC;
        [self.welcomeVC welcomeViewStartAnimationWithCompletion:^{
            
            BOOL isShow = [LhkhNewFeatureVC canShowNewFeature];
            if(isShow){
                if (IS_iPhoneX_Later) {
                    LhkhNewFeatureModel *m1 = [LhkhNewFeatureModel model:Image(@"leading_X_1")];
                    LhkhNewFeatureModel *m2 = [LhkhNewFeatureModel model:Image(@"leading_X_2")];
                    LhkhNewFeatureModel *m3 = [LhkhNewFeatureModel model:Image(@"leading_X_3")];
                    
                    self.keyWindow.rootViewController = [LhkhNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3] enterBlock:^{
                        [self showLoginView:nil];
                    }];
                }else{
                    LhkhNewFeatureModel *m1 = [LhkhNewFeatureModel model:Image(@"leading_1")];
                    LhkhNewFeatureModel *m2 = [LhkhNewFeatureModel model:Image(@"leading_2")];
                    LhkhNewFeatureModel *m3 = [LhkhNewFeatureModel model:Image(@"leading_3")];
                    
                    self.keyWindow.rootViewController = [LhkhNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3] enterBlock:^{
                        [self showLoginView:nil];
                    }];
                }
            }else{
                [self showLoginView:nil];
            }
        }];
    }
}

//登录界面
- (void)showLoginView:(NSNotificationCenter*)notifi
{
    LhkhNavigationController *loginNVC = [[LhkhNavigationController alloc] init];
    [loginNVC addChildViewController:[FWLoginVC showLoginView:^(NSString *logintype) {
        [self showTabbarView:nil];
    }]];
    self.keyWindow.rootViewController = loginNVC;
}

//碑它详情界面
- (void)showWarrantDetailView:(NSString*)releasegoodsId flag:(NSString *)flag
{
    LhkhNavigationController *warrantDetailNVC = [[LhkhNavigationController alloc] init];
    FWWarrantDetailVC *warrantDetailVC = [FWWarrantDetailVC new];
    warrantDetailVC.releaseGoodsId = releasegoodsId?:@"";
    warrantDetailVC.flag = @"1";
    [warrantDetailNVC addChildViewController:warrantDetailVC];
    self.keyWindow.rootViewController = warrantDetailNVC;
}

- (void)showTabbarView:(NSNotificationCenter*)notifi
{
    FWTabBarViewController *tabBarVC = [[FWTabBarViewController alloc] init];
    self.tabBarVC = tabBarVC;
//    [self.tabBarVC.view addSubview:self.welcomeVC.view];
//    [self.welcomeVC welcomeViewStartAnimationWithCompletion:^{
//        //欢迎动画执行完 移除
//        [self.welcomeVC.view removeFromSuperview];
//    }];
    self.keyWindow.rootViewController = self.tabBarVC;
}

- (void)showTabbarViewAgain:(NSInteger)index;
{
    FWTabBarViewController *tabBarVC = [[FWTabBarViewController alloc] init];
    self.tabBarVC = tabBarVC;
    [tabBarVC setSelectedIndex:index];
    self.keyWindow.rootViewController = self.tabBarVC;
}

- (void)showVC:(FWBaseViewController*)vc
{
    LhkhNavigationController *NVC = [[LhkhNavigationController alloc] initWithRootViewController:vc];
    self.keyWindow.rootViewController = NVC;
}

- (void)userWillLogout:(NSNotificationCenter*)notifi
{
    [USER_DEFAULTS setObject:@"" forKey:UD_UserPwd];
    [USER_DEFAULTS setObject:@"" forKey:UD_UserID];
    [USER_DEFAULTS setObject:@"" forKey:UD_UserHeadImg];
    [USER_DEFAULTS setObject:@"" forKey:UD_LoginType];
    [USER_DEFAULTS synchronize];
    
    [self showLoginView:nil];
}

- (void)modifyPwd:(NSNotificationCenter*)notifi
{
    [USER_DEFAULTS setObject:@"" forKey:UD_UserPwd];
    [USER_DEFAULTS setObject:@"" forKey:UD_UserID];
    [USER_DEFAULTS setObject:@"" forKey:UD_LoginType];
    [USER_DEFAULTS synchronize];
    
    [self showLoginView:nil];
}

- (void)changePhoneNo:(NSNotificationCenter*)notifi
{
    [USER_DEFAULTS setObject:@"" forKey:UD_UserPwd];
    [USER_DEFAULTS setObject:@"" forKey:UD_UserID];
    [USER_DEFAULTS setObject:@"" forKey:UD_LoginType];
    [USER_DEFAULTS synchronize];
    
    [self showLoginView:nil];
}

- (void)loadSIMCardInfo
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *iso= [carrier isoCountryCode];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *imsi = [NSString stringWithFormat:@"%@-%@-%@",iso, mcc, mnc];
    DLog(@"sim%@",imsi);
    NSString *ISO = [iso uppercaseString];    //大写
    [USER_DEFAULTS setObject:ISO forKey:UD_ISO];
    
    [self loadCountryInfoWithISO:ISO];
}

- (void)initUserDefaults
{
    //app首次启动
    if ([USER_DEFAULTS objectForKey:UD_FirstLogin] == nil) {
        //首次启动标志
        [USER_DEFAULTS setObject:@"1" forKey:UD_FirstLogin];
    }
    [USER_DEFAULTS setObject:@"0" forKey:UD_FaceLibraryChange];
}
- (void)registerNotifications
{
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWillLogout:) name:Notif_UserWillLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyPwd:) name:Notif_ModifyPassWord object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhoneNo:) name:Notif_ChangePhoneNo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView:) name:Notif_showLoginView object:nil];
}


#pragma  NetWork
- (void)loadOSSproperty
{
    [FWOSSConfigManager loadOSSBaseConfigInfo:nil result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            
            FWOSSResponse *ossproperty = [FWOSSResponse mj_objectWithKeyValues:response[@"result"]];
            
            [USER_DEFAULTS setObject:ossproperty.IMAGE_SERVER_DOMAIN forKey:@"IMAGE_SERVER_DOMAIN"];
            [USER_DEFAULTS setObject:ossproperty.OSS_BUCKET_NAME forKey:@"OSS_BUCKET_NAME"];
            [USER_DEFAULTS setObject:ossproperty.OSS_endpoint forKey:@"OSS_endpoint"];
            [USER_DEFAULTS setObject:ossproperty.OSS_FW_interval_endpoint forKey:@"OSS_interval_endpoint"];
        }
    }];
}


- (void)loadCountryInfoWithISO:(NSString*)iso
{
    NSDictionary *param = @{@"region":iso?:@""};
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getCountryByRegion") parameters:param completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"result"]) {
                if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                    NSString *name = response.responseObject[@"result"][@"name"];
                    NSString *value = response.responseObject[@"result"][@"value"];
                    NSString *ID = response.responseObject[@"result"][@"id"];
                    [USER_DEFAULTS setObject:name forKey:UD_CountryName];
                    [USER_DEFAULTS setObject:value forKey:UD_CountryCode];
                    [USER_DEFAULTS setObject:ID forKey:UD_CountryID];
                }else{
                    [MBProgressHUD showError:response.responseObject[@"resultDesc"]];
                }
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

- (void)loadlimitTime
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/base/limitTime") parameters:nil completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"result"]) {
                NSString *videoTimeLimit = response.responseObject[@"result"][@"videoTimeLimit"];
                NSString *recordingTimeLimit = response.responseObject[@"result"][@"recordingTimeLimit"];
                NSString *voiceTimeLimit = response.responseObject[@"result"][@"voiceTimeLimit"];
                [USER_DEFAULTS setObject:videoTimeLimit forKey:UD_VideoTimeLimit];
                [USER_DEFAULTS setObject:recordingTimeLimit forKey:UD_RecordingTimeLimit];
                [USER_DEFAULTS setObject:voiceTimeLimit forKey:UD_VoiceTimeLimit];
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


- (void)isShowBuy
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/base/isShowBuy") parameters:nil completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"result"]) {
                NSString *result = response.responseObject[@"result"];
                [USER_DEFAULTS setObject:result forKey:UD_IsShowBuy];
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

//获取当前屏幕显示的控制器
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


- (FWWelcomeViewController *)welcomeVC
{
    if (!_welcomeVC) {
        _welcomeVC = [[FWWelcomeViewController alloc] init];
    }
    return _welcomeVC;
}


@end
