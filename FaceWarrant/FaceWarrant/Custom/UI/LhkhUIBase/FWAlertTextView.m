//
//  FWAlertTextView.m
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAlertTextView.h"

@interface FWAlertTextView()
{
    NSString *_labelStr;
}
@property (nonatomic, strong) UILabel *tipsLB;
@property (nonatomic, strong) UITextField *labelTF;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@end

@implementation FWAlertTextView

#pragma mark - Life Cycle

+ (instancetype)defaultView
{
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, 280, 172)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_White;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        
        [self addSubview:self.tipsLB];
        [self addSubview:self.labelTF];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.confirmBtn];
        [self addSubview:self.line1];
        [self addSubview:self.line2];
        
        [self setupConstrains];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)cancelAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(FWAlertTextViewDidClickCancelButton:)]) {
        [self.delegate FWAlertTextViewDidClickCancelButton:self];
    }
}


- (void)confirmBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(FWAlertTextView:didClickConfirmButtonWithLabel:)]) {
        [self.delegate FWAlertTextView:self didClickConfirmButtonWithLabel:_labelStr];
    }
}


- (void)textFieldDidChange:(NSNotification *)notif
{
    if (self.labelTF.text.length > 0) {
        self.confirmBtn.enabled = YES;
        [_confirmBtn setTitleColor:Color_Theme_Red forState:UIControlStateNormal];
    }else {
        self.confirmBtn.enabled = NO;
        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"9b9b9b"] forState:UIControlStateNormal];
    }
    
    
    _labelStr = self.labelTF.text;
    
    if (_labelStr.length >= 10) {
        _labelStr = [_labelStr substringWithRange:NSMakeRange(0, 10)];
    }
}


#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setupConstrains
{
    //tips
    [self.tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset = 30;
        make.height.equalTo(@16);
    }];
    
    //textField
    [self.labelTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset = 20;
        make.trailing.equalTo(self).offset = -20;
        make.top.equalTo(self).offset = 66;
        make.height.equalTo(@37);
    }];
    
    //line1
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self.labelTF.mas_bottom).offset = 30;
        make.height.equalTo(@0.6);
    }];
    
    //line2
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@0.6);
    }];
    
    //取消
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(self.width/2));
        make.height.equalTo(@40);
    }];
    
    //确定
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(self.width/2));
        make.height.equalTo(@40);
    }];
}

#pragma mark - Setters
- (UILabel *)tipsLB
{
    if (!_tipsLB) {
        _tipsLB = [[UILabel alloc] init];
        _tipsLB.text = @"新建群组";
        _tipsLB.textColor = Color_MainText;
        _tipsLB.textAlignment = NSTextAlignmentCenter;
        _tipsLB.font = systemFont(18);
    }
    return _tipsLB;
}


- (UITextField *)labelTF
{
    if (!_labelTF) {
        _labelTF = [[UITextField alloc] init];
        _labelTF.placeholder = @"字数不超过10个字";
        _labelTF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _labelTF;
}


- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#2978FA"] forState:UIControlStateNormal];
        _confirmBtn.enabled = NO;
        
        [_confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithHexString:@"#D2D3D5"];
    }
    return _line1;
}


- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithHexString:@"#D2D3D5"];
    }
    return _line2;
}


#pragma mark - Getters



@end
