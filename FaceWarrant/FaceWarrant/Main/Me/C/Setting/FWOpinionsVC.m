//
//  FWOpinionsVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

//限制最大字数
#define MAX_LIMIT_NUMS   200
#import "FWOpinionsVC.h"
#import "FWMeManager.h"
#import "FWOpinionAlertVC.h"
#import "FWVoiceView.h"
@interface FWOpinionsVC ()<UITextViewDelegate,FWVoiceViewDelegate>
{
    NSInteger _remainingLen;
    NSString *_content;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *tipsLB;
@property (nonatomic, strong) UILabel *tipsLB2;
@property (nonatomic, strong) UILabel *numberLB;
@property (nonatomic, strong) UIButton *yuyinBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) FWOpinionAlertVC *alertVC;
@property (nonatomic, strong) FWVoiceView *voiceView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;//毛玻璃视图
@end

@implementation FWOpinionsVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToRoot) name:Notif_OpinionAlertOK object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_OpinionAlertOK object:nil];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    DLog(@"%@",textView.text);
    
    //隐藏和显示提示文字
    if (textView.text.length > 0) {
        self.tipsLB.hidden = YES;
    }else {
        self.tipsLB.hidden = NO;
    }
    
    if (textView == self.textView) {
        if (textView.text.length > MAX_LIMIT_NUMS) {
            textView.text = [textView.text substringToIndex:MAX_LIMIT_NUMS];
        }
    }
    
    self.numberLB.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,(long)textView.text.length),MAX_LIMIT_NUMS];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.textView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > MAX_LIMIT_NUMS) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Custom Delegate
#pragma mark - FWVoiceViewDelegate
- (void)FWVoiceViewDelegateWithText:(NSString *)text
{
    if (self.textView.text.length>0) {
        self.textView.text = StringConnect(self.textView.text, text);
    }else{
        self.textView.text = text;
    }
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
    self.tipsLB.hidden = self.textView.text.length>0;
}

#pragma mark - Event Response
- (void)backToRoot
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)yuyinClick
{
    [self.view endEditing:YES];
    self.voiceView.hidden = self.visualEffectView.hidden = NO;
}

- (void)singleTapDetected
{
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Network Requests
- (void)sendOpinion
{
    if (self.textView.text == nil || self.textView.text.length == 0) {
        [MBProgressHUD showTips:@"请输入您的意见反馈"];
        return;
    }
    self.sureBtn.userInteractionEnabled = NO;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"suggestion":self.textView.text
                            };
    [FWMeManager sendOpinionWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.alertVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                self.alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:self.alertVC animated:YES completion:^(void)
                 {
                     self.alertVC.view.superview.backgroundColor = [UIColor clearColor];
                 }];
            });
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
        self.sureBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setSubView
{
    self.navigationItem.title = @"意见反馈";
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.tipsLB];
    [self.view addSubview:self.numberLB];
    [self.view addSubview:self.tipsLB2];
    [self.view addSubview:self.yuyinBtn];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset = 16+NavigationBar_H;
        make.leading.equalTo(self.view).offset = 16;
        make.trailing.equalTo(self.view).offset = -16;
        make.height.equalTo(@196);
    }];
    
    [self.tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset = 10;
        make.leading.equalTo(self.textView).offset = 6;
        make.width.equalTo(@200);
        make.height.equalTo(@16);
    }];
    
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView).offset = -10;
        make.trailing.equalTo(self.textView).offset = -10;
        make.height.equalTo(@16);
    }];
    
    [self.tipsLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset = 10;
        make.leading.equalTo(self.textView);
        make.width.equalTo(@200);
        make.height.equalTo(@16);
    }];
    
    [self.yuyinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.offset(40);
        make.right.equalTo(self.numberLB.mas_left);
        make.centerY.equalTo(self.numberLB.mas_centerY);
    }];
    
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:Color_White forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sendOpinion) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.backgroundColor = Color_Theme_Pink;
    self.sureBtn.layer.cornerRadius = 5.f;
    self.sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.sureBtn];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.top.equalTo(self.textView.mas_bottom).offset(80);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];
    
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    self.visualEffectView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.visualEffectView.alpha = 0.5;
    self.visualEffectView.hidden = YES;
    [self.view addSubview:self.visualEffectView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.visualEffectView setUserInteractionEnabled:YES];
    [self.visualEffectView addGestureRecognizer:singleTap];
    
    self.voiceView.hidden = YES;
    [self.view addSubview:self.voiceView];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setters

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = systemFont(15);
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = Color_SubText.CGColor;
        _textView.layer.borderWidth = 0.6;
        _textView.layer.cornerRadius = 6;
        _textView.delegate = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        if (_content.length > 0) {
            _textView.text  =  _content;
            self.tipsLB.hidden = YES;
            self.numberLB.text = [NSString stringWithFormat:@"%ld/%d",(unsigned long)_content.length,MAX_LIMIT_NUMS];
        }
    }
    return _textView;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectZero];
        _voiceView.vctype = @"1";
        _voiceView.backgroundColor = Color_White;
        _voiceView.delegate = self;
    }
    return _voiceView;
}

- (UILabel *)tipsLB
{
    if (!_tipsLB) {
        _tipsLB = [[UILabel alloc] init];
        _tipsLB.text = [NSString stringWithFormat:@"请在此输入您的意见反馈~"];
        _tipsLB.textColor = Color_SubText;
        _tipsLB.font  = systemFont(16);
    }
    return _tipsLB;
}

- (UILabel *)numberLB
{
    if (!_numberLB) {
        _numberLB = [[UILabel alloc] init];
        _numberLB.text = @"0/200";
        _numberLB.textColor = Color_SubText;
        _numberLB.font  = systemFont(16);
        _numberLB.textAlignment = NSTextAlignmentRight;
    }
    return _numberLB;
}

- (UIButton*)yuyinBtn
{
    if (_yuyinBtn == nil) {
        _yuyinBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_yuyinBtn setImage:Image(@"q_voice") forState:UIControlStateNormal];
        [_yuyinBtn addTarget:self action:@selector(yuyinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yuyinBtn;
}

- (FWOpinionAlertVC*)alertVC
{
    if (_alertVC == nil) {
        _alertVC = [FWOpinionAlertVC new];
    }
    return _alertVC;
}

#pragma mark - Getters


@end
