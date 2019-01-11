//
//  FWLoginVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWLoginVC.h"
#import "FWRegisterVC.h"
#import "FWForgetPwdVC.h"
#import "UIButton+Lhkh.h"
#import "FWCountryVC.h"
#import "FWLoginManager.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WeiboSDK.h"
#import "APAuthInfo.h"
#import "RSADataSigner.h"
#import "FWBindPhoneVC.h"
#import "LhkhHttpsManager.h"
#import "AppDelegate.h"
#import "APPVersionManager.h"
@interface FWLoginVC ()<WeiboAccessTokenDelegate,UIApplicationDelegate>
{
    NSTimer *_codeTime;
    NSUInteger _secondsCountDown;
    NSString *_countryCodeStr;
    NSString *_loginType;
    NSString *_openId;
    NSString *_headImg;
    NSString *_nickName;
    BOOL _isCN;
    MBProgressHUD *_hud;
    NSString *_isShow;
}
@property (weak, nonatomic) IBOutlet UIButton *pwdloginType;
@property (weak, nonatomic) IBOutlet UIButton *codeloginType;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet LhkhTextField *phoneText;
@property (weak, nonatomic) IBOutlet LhkhTextField *pwdText;
@property (weak, nonatomic) IBOutlet LhkhTextField *codeText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *wxView;
@property (weak, nonatomic) IBOutlet UIView *zfbView;
@property (weak, nonatomic) IBOutlet UIView *wbView;

@end

@implementation FWLoginVC

#pragma mark - Life Cycle

+ (instancetype)showLoginView:(void (^)(NSString *))block
{
    FWLoginVC *vc = [[FWLoginVC alloc] init];
    vc.loginblock = block;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
    [self loadAppStoreVersion];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _loginType = @"2";
    [USER_DEFAULTS setObject:@"1" forKey:UD_LoginType];
    NSString *phoneStr = [USER_DEFAULTS objectForKey:UD_UserPhone];
    NSString *pwdStr = [USER_DEFAULTS objectForKey:UD_UserPwd];
    NSString *name = [USER_DEFAULTS objectForKey:UD_CountryName];
    NSString *value = [USER_DEFAULTS objectForKey:UD_CountryCode];
    if ([value isEqualToString:@"86"] || [value isEqualToString:@"852"] || [value isEqualToString:@"853"] || [value isEqualToString:@"886"]) {
        _isCN = YES;
    }else{
        _isCN = NO;
    }
    self.phoneText.text = phoneStr;
    self.countryLab.text = name?:@"中国大陆";
    self.countryCode.text = StringConnect(@"+", value?:@"86");
    _countryCodeStr = value;
    if (phoneStr.length>0 && pwdStr.length>0) {
        self.phoneText.text = phoneStr;
        self.pwdText.text = pwdStr;
        self.loginBtn.alpha = 1;
        self.loginBtn.enabled = YES;
    }else{ 
        self.phoneText.text = @"";
        self.pwdText.text = @"";
        self.loginBtn.alpha = 0.5;
        self.loginBtn.enabled = NO;
    }
    
    if (phoneStr.length>0) {
        self.codeBtn.alpha = 1;
        self.codeBtn.enabled = YES;
    }else{
        self.codeBtn.alpha = 0.5;
        self.codeBtn.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disanfangRegisterSuccess) name:Notif_RegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatgetToken:) name:Notif_WechatoAuthSuccess object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_RegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_WechatoAuthSuccess object:nil];
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate

#pragma mark - WeiboAccessTokenDelegate

- (void)WeiboAccessTokenDelegateWithUid:(NSString *)uid accessToken:(NSString *)accessToken
{
    [LhkhHttpsManager requestWithURLString:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",accessToken,uid] parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        DLog(@"---->%@",responseObject);
        if (responseObject) {
            self->_openId = responseObject[@"id"];
            self->_nickName = responseObject[@"name"];
            self->_headImg = responseObject[@"avatar_large"];
            [self loginClick];
        }else{
            [MBProgressHUD showTips:@"获取微博授权信息失败"];
        }
    } failure:^(NSError *error) {
         [MBProgressHUD showTips:@"获取微博授权信息失败"];
    }];
}


#pragma mark - Event Response

//密码登录
- (IBAction)pwdloginClick:(id)sender {
    _loginType = @"2";
    [USER_DEFAULTS setObject:@"1" forKey:UD_LoginType];
    self.codeView.hidden = YES;
    self.pwdView.hidden = NO;
    self.view4.hidden = NO;
    self.view5.hidden = NO;
    self.pwdloginType.titleLabel.font = systemFont(30);
    [self.pwdloginType setTitleColor:Color_Black forState:UIControlStateNormal];
    self.codeloginType.titleLabel.font = systemFont(18);
    [self.codeloginType setTitleColor:Color_SubText forState:UIControlStateNormal];
}

//验证码登录
- (IBAction)codeloginClick:(id)sender {
    _loginType = @"1";
    [USER_DEFAULTS setObject:@"1" forKey:UD_LoginType];
    self.codeView.hidden = NO;
    self.pwdView.hidden = YES;
    self.view4.hidden = YES;
    self.view5.hidden = YES;
    self.pwdloginType.titleLabel.font = systemFont(18);
    [self.pwdloginType setTitleColor:Color_SubText forState:UIControlStateNormal];
    self.codeloginType.titleLabel.font = systemFont(30);
    [self.codeloginType setTitleColor:Color_Black forState:UIControlStateNormal];
}
//忘记密码
- (IBAction)forgetpwdClick:(id)sender {
    FWForgetPwdVC *vc = [[FWForgetPwdVC alloc] init];
    vc.phoneNum = self.phoneText.text;
    vc.countryCodeStr = _countryCodeStr;
    [self.navigationController pushViewController:vc animated:NO];
}
//登录
- (IBAction)loginClick:(id)sender {
    if ([_loginType isEqualToString:@"1"]) {
        [self loginCodeClick];
    }else{
        if (_isCN == YES) {
            if([NSString checkTelNumber:self.phoneText.text]){
                [self loginClick];
            }else{
                [MBProgressHUD showTips:@"请输入正确的手机号码"];
            }
        }else{
            [self loginClick];
        }
    }
}
//注册
- (IBAction)registerClick:(id)sender {
    FWRegisterVC *vc = [[FWRegisterVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

//微信
- (IBAction)wechatClick:(id)sender {
    _loginType = @"4";
    [USER_DEFAULTS setObject:_loginType forKey:UD_LoginType];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"faceWarrant";
    [WXApi sendReq:req];
}

- (void)wechatgetToken:(NSNotification*)notif
{
    NSString *code = [[notif userInfo] valueForKey:@"code"];
    [self loadWechatUserInfo:code];
    
}

//微博
- (IBAction)qqClick:(id)sender {
    _loginType = @"6";
    [USER_DEFAULTS setObject:_loginType forKey:UD_LoginType];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    //回调地址与 新浪微博开放平台中 我的应用  --- 应用信息 -----高级应用    -----授权设置 ---应用回调中的url保持一致就好了
    request.redirectURI = @"http://www.facewarrant.com.cn";
    //SCOPE 授权说明参考  http://open.weibo.com/wiki/
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
}

-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    NSDictionary *dic = (NSDictionary *) response.requestUserInfo;
    DLog(@"userinfo %@",dic);    
}

//支付宝
- (IBAction)alipayClick:(id)sender {
    _loginType = @"5";
    [USER_DEFAULTS setObject:_loginType forKey:UD_LoginType];
    [FWLoginManager loadAliPayAuthInfoWithParameters:nil result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            NSString *appScheme = @"alipaylogin";
            NSString *authInfoStr = response[@"result"];
            [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                             fromScheme:appScheme
                                               callback:^(NSDictionary *resultDic) {
                                                   // 解析 auth code
                                                   NSString *result = resultDic[@"result"];
                                                   NSString *authCode = nil;
                                                   if (result.length>0) {
                                                       NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                       for (NSString *subResult in resultArr) {
                                                           if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                               authCode = [subResult substringFromIndex:10];
                                                               break;
                                                           }
                                                       }
                                                   }
                                                   
                                                   DLog(@"result = %@ 授权结果 authCode = %@", resultDic,authCode?:@"");
                                                   [self loadAlipayUserInfo:authCode];
                                               }];
        }
    }];
}

//第三方注册成功
- (void)disanfangRegisterSuccess
{
    if (self.loginblock) {
        self.loginblock(@"1");
    }
}


//隐藏密码
- (IBAction)pwdHideCLick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.pwdText.secureTextEntry = NO;
    }else{
        self.pwdText.secureTextEntry = YES;
    }
}

//获取验证码
- (IBAction)codeClick:(UIButton *)sender {
    
    if(self.countryCode.text == nil || [self.countryCode.text isEqualToString:@""]){
        [MBProgressHUD showTips:@"请先选择您的国家"];
        return;
    }
    
    if (_isCN == YES) {
        if([NSString checkTelNumber:self.phoneText.text]){
            [self.codeText becomeFirstResponder];
            [self loadCodeNum];
        }else{
            [MBProgressHUD showTips:@"请输入正确的手机号码"];
        }
    }else{
        [self.codeText becomeFirstResponder];
        [self loadCodeNum];
    }
}

//获取国家 国际编码
- (IBAction)getCountryClick:(id)sender {
    FWCountryVC *vc = [[FWCountryVC alloc] init];
    vc.countryblock = ^(NSString *name, NSString *code,NSString *cId) {
        [USER_DEFAULTS setObject:name forKey:UD_CountryName];
        [USER_DEFAULTS setObject:code forKey:UD_CountryCode];
        self.countryLab.text = name;
        self->_countryCodeStr = code;
        self.countryCode.text = StringConnect(@"+", code);
        if ([code isEqualToString:@"86"] || [code isEqualToString:@"852"] || [code isEqualToString:@"853"] || [code isEqualToString:@"886"]) {
            self->_isCN = YES;
        }else{
            self->_isCN = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)textFieldTextChange:(NSNotification *)notif
{
    if (self.phoneText.text.length == 0 ) {
        self.codeBtn.alpha = 0.5f;
        self.codeBtn.enabled = NO;
    }else{
        self.codeBtn.alpha = 1.f;
        self.codeBtn.enabled = YES;
    }
    
    if ([_loginType isEqualToString:@"2"]) {
        if (self.phoneText.text.length == 0 || self.pwdText.text.length == 0) {
            self.loginBtn.alpha = 0.5;
            self.loginBtn.enabled = NO;
        }else {
            self.loginBtn.alpha = 1;
            self.loginBtn.enabled = YES;
        }
    }else{
        if (self.phoneText.text.length == 0 || self.codeText.text.length == 0) {
            self.loginBtn.alpha = 0.5;
            self.loginBtn.enabled = NO;
        }else {
            self.loginBtn.alpha = 1;
            self.loginBtn.enabled = YES;
        }
    }
    
}

#pragma mark - Network requests

- (void)loginClick
{
    _hud = [MBProgressHUD showHUDwithMessage:@"正在登录。。。"];
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text?:@"",
                            @"password":self.pwdText.text?:@"",
                            @"loginType":_loginType,
                            @"countryCode":_countryCodeStr?:@"86",
                            @"openId":_openId?:@"",
                            @"registrationId":[USER_DEFAULTS objectForKey:JPushRegistrationID]?:@"123456"
                            };
    [FWLoginManager loginWithParameters:param result:^(id response) {
        [self->_hud hide];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            NSString *userId = response[@"result"][@"userId"];
            NSString *countryCode = response[@"result"][@"countryCode"];
            NSString *userImg = response[@"result"][@"headImageUrl"];
            NSString *phoneNo = response[@"result"][@"phoneNo"];
            [USER_DEFAULTS setObject:phoneNo forKey:UD_UserPhone];
            [USER_DEFAULTS setObject:self.pwdText.text forKey:UD_UserPwd];
            [USER_DEFAULTS setObject:userId forKey:UD_UserID];
            [USER_DEFAULTS setObject:userImg forKey:UD_UserHeadImg];
            [USER_DEFAULTS setObject:countryCode forKey:UD_Code];
            
            if (self.loginblock) {
                self.loginblock(@"1");
            }
        }else{
            if ([self->_loginType isEqualToString:@"4"]||[self->_loginType isEqualToString:@"5"]||[self->_loginType isEqualToString:@"6"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    FWBindPhoneVC *vc = [FWBindPhoneVC new];
                    vc.loginType = self->_loginType;
                    vc.headImg = self->_headImg;
                    vc.nickName = self->_nickName;
                    vc.openId = self->_openId;
                    [self.navigationController pushViewController:vc animated:NO];
                });
            }else{
                [MBProgressHUD showError:response[@"resultDesc"]];
            }
        }
    }];
}


- (void)loadCodeNum
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"smsType":@"1",
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self codeButtonBeginCountdown];
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)loginCodeClick
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"smsType":@"1",
                            @"smsCode":self.codeText.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCheckCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self loginClick];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)loadAlipayUserInfo:(NSString*)authCode
{
    NSDictionary *param = @{
                            @"authCode":authCode
                            };
    
    [FWLoginManager loadAlipayUserInfoWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            if (response[@"result"]) {
                self->_openId = response[@"result"][@"userId"];
                self->_nickName = response[@"result"][@"nickName"];
                self->_headImg = response[@"result"][@"avatar"];
                [self loginClick];
            }else{
                [MBProgressHUD showError:@"获取支付宝授权信息失败"];
            }
        }
    }];
}

- (void)loadWechatUserInfo:(NSString *)code
{
    NSDictionary *param = @{
                            @"authCode":code,
                            @"sourceType":@"1"
                            };
    [FWLoginManager loadWechatUserInfoWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            if (response[@"result"]) {
                self->_openId = response[@"result"][@"openId"];
                self->_nickName = response[@"result"][@"nickName"];
                self->_headImg = response[@"result"][@"headImgUrl"];
                [self loginClick];
            }else{
                [MBProgressHUD showError:@"获取微信授权信息失败"];
            }
        }
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setSubView
{
    if (IS_iPhoneX_Later) {
        self.topH.constant = -44;
    }else{
        self.topH.constant = -20;
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.wbDelegate = self;
    
    self.view.backgroundColor = Color_White;
    _secondsCountDown = 60;
    _loginType = @"2";
    [USER_DEFAULTS setObject:@"1" forKey:UD_LoginType];
    self.accountView.layer.cornerRadius = 22.f;
    self.accountView.layer.masksToBounds = YES;
    self.accountView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.accountView.layer.borderWidth = 1.f;
    self.pwdView.layer.cornerRadius = 22.f;
    self.pwdView.layer.masksToBounds = YES;
    self.pwdView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.pwdView.layer.borderWidth = 1.f;
    self.codeView.layer.cornerRadius = 22.f;
    self.codeView.layer.masksToBounds = YES;
    self.codeView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.codeView.layer.borderWidth = 1.f;
    
    
    self.wxView.hidden = ![WXApi isWXAppInstalled];
    
    NSURL *zfburl = URL(@"alipay://alipaylogin");
    self.zfbView.hidden = ![[UIApplication sharedApplication]canOpenURL:zfburl];
    
    self.wbView.hidden = ![WeiboSDK isWeiboAppInstalled];

    
    self.view1.layer.cornerRadius = 25.f;
    self.view1.layer.masksToBounds = YES;
    self.view1.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.view1.layer.borderWidth = 1.f;
    self.view2.layer.cornerRadius = 25.f;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.view2.layer.borderWidth = 1.f;
    self.view3.layer.cornerRadius = 25.f;
    self.view3.layer.masksToBounds = YES;
    self.view3.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    self.view3.layer.borderWidth = 1.f;

    
    self.loginBtn.layer.cornerRadius = 20.f;
    self.loginBtn.layer.masksToBounds = YES;
    self.codeBtn.layer.cornerRadius = 22.f;
    self.codeBtn.layer.masksToBounds = YES;
}

- (void)codeButtonBeginCountdown
{
    self.codeBtn.enabled = NO;
    self.codeBtn.alpha = 0.5;
    self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重发（%lus）",(unsigned long)_secondsCountDown] forState:UIControlStateNormal];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
}

- (void)timeFireMethod:(NSTimer *)timer
{
    _secondsCountDown -- ;
    self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重发（%lus）",(unsigned long)_secondsCountDown] forState:UIControlStateNormal];
    
    if (_secondsCountDown == 0) {
        _secondsCountDown = 60;
        self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#FD0663"];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
        self.codeBtn.alpha = 1;
        [timer invalidate];
    }
}


- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)loadAppStoreVersion
{
    _isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
    if (![_isShow isEqualToString:@"1"]) {
        [[APPVersionManager sharedInstance]checkVersion:self];
    }
}

#pragma mark - Setters




#pragma mark - Getters




@end
