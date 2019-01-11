//
//  FWModifyPwdVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWModifyPwdVC.h"
#import "FWMeManager.h"
@interface FWModifyPwdVC ()
@property (strong, nonatomic)UITextField *oldPwd;
@property (strong, nonatomic)UITextField *newerPwd;
@property (strong, nonatomic)UITextField *surePwd;
@end

@implementation FWModifyPwdVC

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


#pragma mark - Network Requests

- (void)sureClick
{
    if (self.oldPwd.text.length == 0){
        [MBProgressHUD showTips:@"请填写旧密码"];
        return;
    }
    if( self.newerPwd.text.length == 0 ){
        [MBProgressHUD showTips:@"请填写新密码"];
        return;
    }
    if( self.surePwd.text.length == 0 ) {
        [MBProgressHUD showTips:@"请确认新密码"];
        return;
    }
    
    if( ![self.surePwd.text isEqual:self.newerPwd.text] ) {
        [MBProgressHUD showTips:@"两次密码不一致,请确认"];
        return;
    }
    
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"oldPwd":self.oldPwd.text,
                            @"newPwd":self.newerPwd.text
                            };
    [FWMeManager modifyPwdWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_ModifyPassWord object:nil];
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
    self.navigationItem.title = @"修改密码";

    [self.view addSubview:self.oldPwd];
    [self.view addSubview:self.newerPwd];
    [self.view addSubview:self.surePwd];
    
    
    UILabel *oldLab = [[UILabel alloc] initWithFrame:CGRectZero];
    oldLab.text = @"旧密码丨";
    oldLab.font = systemFont(16);
    [self.view addSubview:oldLab];
    
    UILabel *newLab = [[UILabel alloc] initWithFrame:CGRectZero];
    newLab.text = @"新密码丨";
    newLab.font = systemFont(16);
    [self.view addSubview:newLab];
    
    UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectZero];
    sureLab.text = @"确认密码丨";
    sureLab.font = systemFont(16);
    [self.view addSubview:sureLab];
    
    [oldLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationBar_H +40);
        make.left.equalTo(self.view).offset(40);
        make.width.offset(80);
        make.height.offset(40);
    }];
    
    [self.oldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldLab.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-40);
        make.centerY.equalTo(oldLab.mas_centerY);
        make.height.offset(40);
    }];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.view addSubview:view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(oldLab);
        make.right.equalTo(self.oldPwd);
        make.top.equalTo(self.oldPwd.mas_bottom).offset(5);
    }];
    
    [newLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldLab.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(40);
        make.width.offset(80);
        make.height.offset(40);
    }];
    
    [self.newerPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newLab.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-40);
        make.centerY.equalTo(newLab.mas_centerY);
        make.height.offset(40);
    }];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.view addSubview:view2];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(newLab);
        make.right.equalTo(self.newerPwd);
        make.top.equalTo(self.newerPwd.mas_bottom).offset(5);
    }];
    
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLab.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(40);
        make.width.offset(100);
        make.height.offset(40);
    }];
    
    [self.surePwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureLab.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-40);
        make.centerY.equalTo(sureLab.mas_centerY);
        make.height.offset(40);
    }];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectZero];
    view3.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.view addSubview:view3];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(sureLab);
        make.right.equalTo(self.surePwd);
        make.top.equalTo(self.surePwd.mas_bottom).offset(5);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [sureBtn  setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = Color_Theme_Pink;
    sureBtn.layer.cornerRadius = 20.f;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.top.equalTo(view3.mas_bottom).offset(100);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];
}

#pragma mark - Setters
- (UITextField*)oldPwd
{
    if (_oldPwd == nil) {
        _oldPwd = [[UITextField alloc] initWithFrame:CGRectZero];
        _oldPwd.font = systemFont(16);
        _oldPwd.placeholder = @"旧密码";
        _oldPwd.secureTextEntry = YES;
        _oldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _oldPwd;
}

- (UITextField*)newerPwd
{
    if (_newerPwd == nil) {
        _newerPwd = [[UITextField alloc] initWithFrame:CGRectZero];
        _newerPwd.font = systemFont(16);
        _newerPwd.placeholder = @"新密码";
        _newerPwd.secureTextEntry = YES;
        _newerPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _newerPwd;
}

- (UITextField*)surePwd
{
    if (_surePwd == nil) {
        _surePwd = [[UITextField alloc] initWithFrame:CGRectZero];
        _surePwd.font = systemFont(16);
        _surePwd.placeholder = @"确认密码";
        _surePwd.secureTextEntry = YES;
        _surePwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _surePwd;
}

#pragma mark - Getters


@end
