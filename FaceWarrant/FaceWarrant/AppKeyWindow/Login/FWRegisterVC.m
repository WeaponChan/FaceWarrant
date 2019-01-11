//
//  FWRegisterVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWRegisterVC.h"
#import "UIButton+Lhkh.h"
#import "FWRegisterInfoVC.h"
#import "FWLoginManager.h"
#import "FWCountryVC.h"
#import "FWCountryModel.h"
#import "FWXieYiVC.h"
@interface FWRegisterVC ()<UITextFieldDelegate>
{
    NSTimer *_codeTime;
    NSUInteger _secondsCountDown;
    NSString *_countryCodeStr;
    NSString *_cId;
    MBProgressHUD *_hud;
    BOOL _isCN;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;


@property (weak, nonatomic) IBOutlet LhkhTextField *phoneText;
@property (weak, nonatomic) IBOutlet LhkhTextField *codeText;
@property (weak, nonatomic) IBOutlet LhkhTextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation FWRegisterVC

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
    self.countryCode.text = StringConnect(@"+", value?:@"86");
    _countryCodeStr = value;
    self.phoneText.text = @"";
    self.codeBtn.enabled = NO;
    self.codeBtn.alpha = 0.5;
    self.nextBtn.enabled = NO;
    self.nextBtn.alpha = 0.5;
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

- (IBAction)countryClick:(id)sender {
    FWCountryVC *vc = [[FWCountryVC alloc] init];
    vc.countryblock = ^(NSString *name, NSString *code, NSString *cId) {
        [USER_DEFAULTS setObject:name forKey:UD_CountryName];
        [USER_DEFAULTS setObject:code forKey:UD_CountryCode];
        self->_countryCodeStr = code;
        self.countryLab.text = name;
        self.countryCode.text = StringConnect(@"+", code);
        self->_cId = cId;
        if ([code isEqualToString:@"86"] || [code isEqualToString:@"852"] || [code isEqualToString:@"853"] || [code isEqualToString:@"886"]) {
            self->_isCN = YES;
        }else{
            self->_isCN = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//获取验证码
- (IBAction)codeClick:(id)sender {
    
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

//注册下一步
- (IBAction)registerClick:(id)sender {

    if (self.codeText.text == nil || self.codeText.text.length == 0) {
        [MBProgressHUD showTips:@"请输入验证码"];
    }else if(self.checkBox.selected == NO){
        [MBProgressHUD showTips:@"请确认用户注册协议"];
    }else{
        [self loadNext];
    }
}

- (IBAction)checkCLick:(UIButton*)sender {
    sender.selected = !sender.selected;
}
- (IBAction)xieyiClick:(id)sender {
    [self.navigationController pushViewController:[FWXieYiVC new] animated:YES];
}
- (IBAction)hideClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.pwdText.secureTextEntry = NO;
    }else{
        self.pwdText.secureTextEntry = YES;
    }
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
    
    if (self.phoneText.text.length == 0 || self.codeText.text.length == 0 || self.pwdText.text.length == 0) {
        self.nextBtn.alpha = 0.5;
        self.nextBtn.enabled = NO;
    }else{
        self.nextBtn.alpha = 1;
        self.nextBtn.enabled = YES;
    }
}
#pragma mark - Network requests

- (void)loadCodeNum
{
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"smsType":@"0",
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

- (void)loadNext
{
    _hud = [MBProgressHUD showHUDwithMessage:@"正在注册。。。"];
    NSDictionary *param = @{
                            @"phoneNo":self.phoneText.text,
                            @"smsType":@"0",
                            @"smsCode":self.codeText.text,
                            @"countryCode":_countryCodeStr?:@"86"
                            };
    [FWLoginManager loadCheckCodeWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self->_hud hide];
            dispatch_async(dispatch_get_main_queue(), ^{
                FWRegisterInfoVC *vc = [FWRegisterInfoVC new];
                vc.phoneNo = self.phoneText.text;
                vc.pwd = self.pwdText.text;
                vc.countryCode = self->_countryCodeStr;
                vc.countryId = self->_cId;
                vc.countryName = self.countryLab.text;
                [self.navigationController pushViewController:vc animated:NO];
            });
        }else{
            [self->_hud hide];
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
    _countryCodeStr = @"86";
    
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
    self.codeBtn.layer.cornerRadius = 22.f;
    self.codeBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 20.f;
    self.nextBtn.layer.masksToBounds = YES;
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
