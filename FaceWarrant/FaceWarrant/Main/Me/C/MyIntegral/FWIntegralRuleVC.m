//
//  FWIntegralRuleVC.m
//  FaceWarrant
//
//  Created by FW on 2018/8/21.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWIntegralRuleVC.h"

@interface FWIntegralRuleVC ()
@property (weak, nonatomic) IBOutlet UILabel *integralLab;
@property (weak, nonatomic) IBOutlet UILabel *integralruleLab;
@property (weak, nonatomic) IBOutlet UILabel *integralSubLab;
@property (weak, nonatomic) IBOutlet UILabel *integralRuleSubLab;
@end

@implementation FWIntegralRuleVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.integralLab.text = self.integralStr;
    self.integralSubLab.text = [NSString stringWithFormat:@"●  签到可获得%@个积分，每天只可签到一次；\n\n●  注册奖励%@个积分；", self.integralSubStr,self.pointsRegister];
    self.integralRuleSubLab.text = [NSString stringWithFormat:@"●  可兑换脸值；\n\n●  兑换比例为%@积分=1脸值；\n\n●  其他兑换方式敬请期待~", self.integralRuleSubStr];
    self.integralruleLab.layer.cornerRadius = 5.f;
    self.integralruleLab.layer.masksToBounds = YES;
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods


#pragma mark - Setters


#pragma mark - Getters


@end
