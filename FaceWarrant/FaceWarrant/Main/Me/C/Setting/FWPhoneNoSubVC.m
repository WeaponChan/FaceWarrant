//
//  FWPhoneNoSubVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWPhoneNoSubVC.h"
#import "FWLoginManager.h"
#import "FWCountryVC.h"
#import "FWMeManager.h"
@interface FWPhoneNoSubVC ()
{
    NSTimer *_codeTime;
    NSUInteger _secondsCountDown;
    NSString *_countryCodeStr;
    NSString *_cId;
    BOOL _isCN;
}
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation FWPhoneNoSubVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"更换手机号";
    _secondsCountDown = 60;
    _countryCodeStr = @"86";
    self.codeBtn.layer.cornerRadius = 12.5f;
    self.codeBtn.layer.masksToBounds = YES;
    self.codeBtn.enabled = NO;
    self.codeBtn.alpha = 0.5;
    self.codeBtn.layer.borderColor = Color_Theme_Pink.CGColor;
    self.codeBtn.layer.borderWidth = 1.f;
    self.sureBtn.layer.cornerRadius = 5.f;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.borderColor = Color_Theme_Pink.CGColor;
    self.sureBtn.layer.borderWidth = 1.f;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
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
    self.countryCode.text = [NSString stringWithFormat:@"%@ +%@",name,value]?:@"中国大陆 +86";
    _countryCodeStr = value;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)getCountryCode:(id)sender {
    FWCountryVC *vc = [[FWCountryVC alloc] init];
    vc.countryblock = ^(NSString *name, NSString *code,NSString *cId) {
        [USER_DEFAULTS setObject:name forKey:UD_CountryName];
        [USER_DEFAULTS setObject:code forKey:UD_CountryCode];
        self->_countryCodeStr = code;
        self.countryCode.text = [NSString stringWithFormat:@"%@ +%@",name,code];
        if ([code isEqualToString:@"86"] || [code isEqualToString:@"852"] || [code isEqualToString:@"853"] || [code isEqualToString:@"886"]) {
            self->_isCN = YES;
        }else{
            self->_isCN = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)sureClick:(id)sender {
    if (self.phoneNum.text.length == 0 || [self.phoneNum.text isEqualToString:@""] || self.phoneNum.text == nil) {
        [MBProgressHUD showTips:@"请输入更换的手机号码"];
    }else if (self.code.text.length == 0 || [self.code.text isEqualToString:@""] || self.code.text == nil){
        [MBProgressHUD showTips:@"请输入验证码"];
    }else{
        [self loadNext];
    }
}

- (IBAction)getCodeClick:(id)sender {
    if(self.countryCode.text == nil || [self.countryCode.text isEqualToString:@""]){
        [MBProgressHUD showTips:@"请先选择您的国家"];
        return;
    }
    if (_isCN == YES) {
        if([NSString checkTelNumber:self.phoneNum.text]){
            [self.code becomeFirstResponder];
            [self loadCodeNum];
        }else{
            [MBProgressHUD showTips:@"请输入正确的手机号码"];
        }
    }else{
        [self.code becomeFirstResponder];
        [self loadCodeNum];
    }
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
}
#pragma mark - Network Requests

- (void)loadCodeNum
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneNum.text,
                            @"smsType":@"3",
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            [self codeButtonBeginCountdown];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)loadNext
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneNum.text,
                            @"smsType":@"3",
                            @"smsCode":self.code.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCheckCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self changePhone];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)changePhone
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"phoneNo":self.phoneNum.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWMeManager changePhoneNumWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            [USER_DEFAULTS setObject:self.phoneNum.text forKey:UD_UserPhone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_ChangePhoneNo object:nil];
            });
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)codeButtonBeginCountdown
{
    self.codeBtn.enabled = NO;
    self.codeBtn.alpha = 0.5;
    self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
    self.codeBtn.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重发（%lus）",(unsigned long)_secondsCountDown] forState:UIControlStateNormal];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
}

- (void)timeFireMethod:(NSTimer *)timer
{
    _secondsCountDown -- ;
    self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
    self.codeBtn.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重发（%lus）",(unsigned long)_secondsCountDown] forState:UIControlStateNormal];
    
    if (_secondsCountDown == 0) {
        _secondsCountDown = 60;
        self.codeBtn.backgroundColor = Color_White;
        self.codeBtn.layer.borderColor = [UIColor colorWithHexString:@"#FD0663"].CGColor;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
        self.codeBtn.alpha = 1;
        [timer invalidate];
    }
}

#pragma mark - Setters


#pragma mark - Getters


@end
