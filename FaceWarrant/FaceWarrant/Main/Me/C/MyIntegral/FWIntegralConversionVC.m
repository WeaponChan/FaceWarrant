//
//  FWIntegralConversionVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWIntegralConversionVC.h"
#import "FWMeManager.h"
@interface FWIntegralConversionVC ()
@property(strong, nonatomic)UILabel *integralLab;
@property(strong, nonatomic)UILabel *ruleLab;
@property(strong, nonatomic)LhkhTextField *integralText;
@end

@implementation FWIntegralConversionVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setSubView];
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

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)textFieldTextChange:(NSNotification*)notif
{
    DLog(@"---->%@",self.integralText.text);
    if (self.integralText.text.floatValue>self.integralLab.text.floatValue) {
        self.integralText.text = self.integralLab.text;
    }
}

- (void)duihuanClick
{
    if ([self.integralText.text isEqualToString:@""] || self.integralText.text == nil || self.integralText.text.length == 0) {
        [MBProgressHUD showTips:@"请输入需要兑换的积分"];
    }else if(self.integralText.text.integerValue % self.integralSubStr.integerValue != 0){
        [MBProgressHUD showTips:[NSString stringWithFormat:@"请输入%@的整数倍进行兑换",self.integralSubStr]];
    }else{
        [self sendIntegralToFaceValue];
    }
}
#pragma mark - Network Requests

- (void)sendIntegralToFaceValue
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"points":self.integralText.text
                            };
    [FWMeManager sendIntegralToFaceValueWithParameters:param result:^(id response) {
        [MBProgressHUD showTips:response[@"resultDesc"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"兑换脸值";
}

- (void)setSubView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
    topView.backgroundColor = Color_White;
    [self.view addSubview:topView];
    [topView addSubview:self.integralLab];
    [self.view addSubview:self.ruleLab];
    
    UIImageView *curimageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    curimageView.image = Image(@"me_integralDuihuan");
    [topView addSubview:curimageView];
    
    UILabel *curLab = [[UILabel alloc] initWithFrame:CGRectZero];
    curLab.text = @"当前积分";
    curLab.textColor = [UIColor colorWithHexString:@"#999999"];
    curLab.font = systemFont(12);
    [topView addSubview:curLab];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"兑换脸值";
    label.textColor = Color_MainText;
    label.font = systemFont(14);
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:@"立即兑换" forState:UIControlStateNormal];
    btn.titleLabel.font = systemFont(16);
    [btn setTitleColor:Color_White forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#E6195F"];
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(duihuanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = Color_White;
    [self.view addSubview:view];
    
    [view addSubview:self.integralText];
    [view addSubview:label];
    
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBar_H);
    }];
    
    [curimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(80);
        make.top.equalTo(topView).offset(30);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    [self.integralLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(curimageView.mas_bottom).offset(15);
    }];
    
    [curLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(self.integralLab.mas_bottom).offset(10);
    }];
    
    [self.ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.top.equalTo(topView.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.top.equalTo(self.ruleLab.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.width.offset(80);
        make.top.bottom.equalTo(view);
    }];
    
    [self.integralText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(20);
        make.top.bottom.equalTo(view);
        make.right.equalTo(view).offset(-15);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(view.mas_bottom).offset(50);
    }];
}

#pragma mark - Setters

- (UILabel*)integralLab
{
    if (_integralLab == nil) {
        _integralLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _integralLab.text = self.integralStr;
        _integralLab.font = systemFont(40);
        _integralLab.textAlignment = NSTextAlignmentCenter;
        _integralLab.textColor = [UIColor colorWithHexString:@"#E50505"];
    }
    return _integralLab;
}

- (UILabel*)ruleLab
{
    if (_ruleLab == nil) {
        _ruleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _ruleLab.text = [NSString stringWithFormat:@"兑换比例为%@积分=1脸值，兑换积分数需是%@的整数倍",self.integralSubStr,self.integralSubStr];
        _ruleLab.font = systemFont(14);
        _ruleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _ruleLab.numberOfLines = 0;
    }
    return _ruleLab;
}

- (LhkhTextField*)integralText
{
    if (_integralText == nil) {
        _integralText = [[LhkhTextField alloc] initWithFrame:CGRectZero];
        _integralText.placeholder = @"请输入需要兑换脸值的积分数量";
        _integralText.font = systemFont(14);
        _integralText.textColor = Color_SubText;
        _integralText.textAlignment = NSTextAlignmentRight;
        _integralText.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _integralText;
}


#pragma mark - Getters


@end
