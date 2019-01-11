//
//  FWForgetPwdVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWForgetPwdVC.h"
#import "FWLoginManager.h"

@interface FWForgetPwdVC ()<UITextFieldDelegate>
{
    NSTimer *_codeTime;
    NSUInteger _secondsCountDown;
    NSString *_countryCodeStr;
    BOOL _isCN;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;


@property (weak, nonatomic) IBOutlet LhkhTextField *phoneText;
@property (weak, nonatomic) IBOutlet LhkhTextField *codeText;
@property (weak, nonatomic) IBOutlet LhkhTextField *pwdText;
@property (weak, nonatomic) IBOutlet LhkhTextField *rePwdText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet UIButton *rehideBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation FWForgetPwdVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *value = [USER_DEFAULTS objectForKey:UD_CountryCode];
    if ([value isEqualToString:@"86"] || [value isEqualToString:@"852"] || [value isEqualToString:@"853"] || [value isEqualToString:@"886"]) {
        _isCN = YES;
    }else{
        _isCN = NO;
    }
    _countryCodeStr = value;
    self.phoneText.text = @"";
    self.codeBtn.alpha = 0.5;
    self.codeBtn.enabled = NO;
    self.sureBtn.alpha = 0.5;
    self.sureBtn.enabled = NO;
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

- (IBAction)codeClick:(id)sender {
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

- (IBAction)hidepwdClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.pwdText.secureTextEntry = NO;
    }else{
        self.pwdText.secureTextEntry = YES;
    }
}

- (IBAction)reHidepwdClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.rePwdText.secureTextEntry = NO;
    }else{
        self.rePwdText.secureTextEntry = YES;
    }
}

- (IBAction)sureClick:(id)sender {
    [self loadCodeNumCheck];
}

- (void)textFieldTextChange:(NSNotification *)notif
{
    if (self.phoneText.text.length == 0 ) {
        self.codeBtn.alpha = 0.5f;
        self.codeBtn.enabled = YES;
    }else{
        self.codeBtn.alpha = 1.f;
        self.codeBtn.enabled = YES;
    }
    
    if (self.phoneText.text.length == 0 || self.codeText.text.length == 0 || self.pwdText.text.length == 0 || self.rePwdText.text.length == 0) {
        self.sureBtn.alpha = 0.5f;
        self.sureBtn.enabled = YES;
    }else {
        self.sureBtn.alpha = 1.f;
        self.sureBtn.enabled = YES;
    }
}
#pragma mark - Network requests

- (void)loadCodeNum
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"smsType":@"2",
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"resultDesc"]];
            [self codeButtonBeginCountdown];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)loadCodeNumCheck
{
    if (self.pwdText.text.length == 0 || self.rePwdText.text.length == 0) {
        [MBProgressHUD showTips:@"请填写新密码"];
        return;
    }
    if (![self.pwdText.text isEqual:self.rePwdText.text]) {
        [MBProgressHUD showTips:@"两次填写的密码不一致"];
        return;
    }
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"smsType":@"2",
                            @"smsCode":self.codeText.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCheckCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self forgetPWDClick];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)forgetPWDClick
{
    
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"password":self.pwdText.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager forgetPWDWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:@"修改密码成功，请重新登录"];
            [self.navigationController popViewControllerAnimated:YES];
            
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
    
    self.phoneText.text = self.phoneNum?:@"";
    self.view1.layer.cornerRadius = 22.f;
    self.view1.layer.masksToBounds = YES;
    self.view1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view1.layer.borderWidth = 1.f;
    self.view2.layer.cornerRadius = 22.f;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view2.layer.borderWidth = 1.f;
    self.view3.layer.cornerRadius = 22.f;
    self.view3.layer.masksToBounds = YES;
    self.view3.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view3.layer.borderWidth = 1.f;
    self.view4.layer.cornerRadius = 22.f;
    self.view4.layer.masksToBounds = YES;
    self.view4.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view4.layer.borderWidth = 1.f;
    
    self.codeBtn.layer.cornerRadius = 22.f;
    self.codeBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 20.f;
    self.sureBtn.layer.masksToBounds = YES;
    
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
