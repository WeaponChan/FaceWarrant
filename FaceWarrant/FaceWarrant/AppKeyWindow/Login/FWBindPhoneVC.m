//
//  FWBindPhoneVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBindPhoneVC.h"
#import "FWLoginManager.h"
#import "FWCountryVC.h"
#import "FWCountryModel.h"
@interface FWBindPhoneVC ()<UITextFieldDelegate>
{
    NSTimer *_codeTime;
    NSUInteger _secondsCountDown;
    NSString *_countryCodeStr;
    NSString *_countryId;
    BOOL _isCN;
    MBProgressHUD *_hud;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;

@property (weak, nonatomic) IBOutlet LhkhTextField *phoneNum;
@property (weak, nonatomic) IBOutlet LhkhTextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation FWBindPhoneVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *name = [USER_DEFAULTS objectForKey:UD_CountryName];
    NSString *value = [USER_DEFAULTS objectForKey:UD_CountryCode];
    if ([value isEqualToString:@"86"] || [value isEqualToString:@"852"] || [value isEqualToString:@"853"] || [value isEqualToString:@"886"]) {
        _isCN = YES;
    }else{
        _isCN = NO;
    }
    self.countryLab.text = name?:@"中国大陆";
    self.countryCode.text = StringConnect(@"+", value?:@"+86");
    _countryCodeStr = value;
    self.codeBtn.alpha = 0.5;
    self.codeBtn.enabled = NO;
    self.loginBtn.alpha = 0.5;
    self.loginBtn.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (IBAction)codeCLick:(id)sender {
    if (_isCN == YES) {
        if([NSString checkTelNumber:self.phoneNum.text]){
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

- (IBAction)sureClick:(id)sender {
    if (self.codeText.text.length == 0) {
        [MBProgressHUD showTips:@"请输入验证码"];
        return;
    }
    [self loadCodeNumCheck];
}

- (IBAction)countryClick:(id)sender {
    FWCountryVC *vc = [[FWCountryVC alloc] init];
    vc.countryblock = ^(NSString *name, NSString *code, NSString *cId) {
        [USER_DEFAULTS setObject:name forKey:UD_CountryName];
        [USER_DEFAULTS setObject:code forKey:UD_CountryCode];
        [USER_DEFAULTS setObject:cId forKey:UD_CountryID];
        self->_countryCodeStr = code;
        self->_countryId = cId;
        self.countryLab.text = name;
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
    if (self.phoneNum.text.length == 0 ) {
        self.codeBtn.alpha = 0.5f;
        self.codeBtn.enabled = NO;
    }else{
        self.codeBtn.alpha = 1.f;
        self.codeBtn.enabled = YES;
    }
    
    if (self.phoneNum.text.length == 0 || self.codeText.text.length == 0) {
        self.loginBtn.alpha = 0.5;
        self.loginBtn.enabled = NO;
    }else {
        self.loginBtn.alpha = 1;
        self.loginBtn.enabled = YES;
    }
}

#pragma mark - Network requests

- (void)loadCodeNum
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneNum.text,
                            @"smsType":@"4",
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self codeButtonBeginCountdown];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}


- (void)loadCodeNumCheck
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneNum.text,
                            @"smsType":@"4",
                            @"smsCode":self.codeText.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCheckCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self registerClick];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)registerClick
{
    NSString *type = @"";
    if ([self.loginType isEqualToString:@"4"]) {
        type = @"1";
    }else if ([self.loginType isEqualToString:@"6"]){
        type = @"2";
    }else{
        type = @"3";
    }
    
    _hud = [MBProgressHUD showHUDwithMessage:@"正在登陆。。。"];
    NSDictionary *param = @{
                            @"headImageUrl":self.headImg,
                            @"name":self.nickName,
                            @"phoneNo":self.phoneNum.text,
                            @"countryCode":_countryCodeStr?:@"86",
                            @"countryId":self->_countryId?:[USER_DEFAULTS objectForKey:UD_CountryID],
                            @"country":self.countryLab.text,
                            @"provinceId":@"",
                            @"province":@"",
                            @"cityId":@"",
                            @"city":@"",
                            @"password":@"",
                            @"referee":@"",
                            @"registerType":@"2",
                            @"type":type,
                            @"openId":self.openId,
                            @"registrationId":[USER_DEFAULTS objectForKey:JPushRegistrationID]?:@""
                            };
    
    [FWLoginManager registerWithParameters:param result:^(id response) {
        [self->_hud hide];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"resultDesc"]];
            NSString *ID = response[@"result"][@"id"];
            NSString *countryCode = response[@"result"][@"countryCode"];
            NSString *userImg = response[@"result"][@"headImageUrl"];
            NSString *userId = [NSString stringWithFormat:@"%@",ID];
            NSString *mobile = response[@"result"][@"mobile"];
            [USER_DEFAULTS setObject:userId forKey:UD_UserID];
            [USER_DEFAULTS setObject:userImg forKey:UD_UserHeadImg];
            [USER_DEFAULTS setObject:countryCode forKey:UD_Code];
            
            if (self.phoneNum.text.length>0 && self.phoneNum.text!= nil && [self.phoneNum.text isEqualToString:@""]) {
                [USER_DEFAULTS setObject:self.phoneNum.text forKey:UD_UserPhone];
            }else{
                [USER_DEFAULTS setObject:mobile forKey:UD_UserPhone];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_RegisterSuccess object:nil];
            });
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
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
    
    self.view.backgroundColor = Color_White;
    _secondsCountDown = 60;
    self.view1.layer.cornerRadius = 22.f;
    self.view1.layer.masksToBounds = YES;
    self.view1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view1.layer.borderWidth = 1.f;
    self.view2.layer.cornerRadius = 22.f;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view2.layer.borderWidth = 1.f;
    
    self.codeBtn.layer.cornerRadius = 22.f;
    self.codeBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 22.f;
    self.loginBtn.layer.masksToBounds = YES;
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

#pragma mark - Setters




#pragma mark - Getters




@end
