//
//  FWPhoneNoVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWPhoneNoVC.h"
#import "FWPhoneNoSubVC.h"
@interface FWPhoneNoVC ()
@property (strong, nonatomic)UILabel *phoneNoLab;
@end

@implementation FWPhoneNoVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)modifyClick
{
    [self.navigationController pushViewController:[FWPhoneNoSubVC new] animated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setSubView
{
    self.navigationItem.title = @"绑定手机号";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = Image(@"me_banged");
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(130);
        make.width.offset(97);
        make.top.equalTo(self.view).offset(NavigationBar_H +50);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.phoneNoLab];
    NSString *phone = [USER_DEFAULTS objectForKey:UD_UserPhone];
    NSRange range={3,4};
    NSString *str = [phone stringByReplacingCharactersInRange:range withString:@"****"];
    self.phoneNoLab.text = [NSString stringWithFormat:@"绑定的手机号：%@",str];
    
    [self.phoneNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(30);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [sureBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    [sureBtn setTitleColor:Color_Theme_Pink forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = Color_White;
    sureBtn.layer.borderWidth = 1.f;
    sureBtn.layer.borderColor = Color_Theme_Pink.CGColor;
    sureBtn.layer.cornerRadius = 5.f;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.top.equalTo(self.phoneNoLab.mas_bottom).offset(55);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];
}

#pragma mark - Setters

- (UILabel *)phoneNoLab
{
    if (_phoneNoLab == nil) {
        _phoneNoLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNoLab.font = systemFont(16);
        _phoneNoLab.textAlignment = NSTextAlignmentCenter;
        _phoneNoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _phoneNoLab;
}

#pragma mark - Getters


@end
