//
//  FWApplyCashVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWApplyCashVC.h"
#import "FWMeManager.h"
#import "FWBankListVC.h"
#import "FWFaceValueCashDetailVC.h"

@interface FWApplyCashVC ()<FWBankListVCDelegate>
{
    NSString *_balance;
    NSString *_realName;//真是姓名
    NSString *_cardNo;//卡号或者支付宝账号
    NSString *_bankName;//银行名称
    NSString *_bankId;//银行id
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UILabel *itemLab1;
@property (weak, nonatomic) IBOutlet UITextField *itemText1;
@property (weak, nonatomic) IBOutlet UILabel *itemLab2;
@property (weak, nonatomic) IBOutlet UITextField *itemText2;
@property (weak, nonatomic) IBOutlet UITextField *itemText3;
@property (weak, nonatomic) IBOutlet UITextField *cashText;
@property (weak, nonatomic) IBOutlet UILabel *cashLab;
@property (weak, nonatomic) IBOutlet UILabel *applyLab;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightW;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UILabel *ruleLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation FWApplyCashVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self loadAccountData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadYueData];
    self.cashText.text = @"";
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
#pragma mark - FWBankListVCDelegate
- (void)FWBankListVCDelegateClick:(NSString *)bankName bankID:(NSString*)bankId
{
    self.itemText1.text = bankName;
    _bankName = bankName;
    _bankId = bankId;
    if (self.itemText3.text.length>6 && self.itemText3.text != nil && ![self.itemText3.text isEqualToString:@""]) {
        if (self.itemText1.text.length>0 && self.itemText3.text.length>15) {
            NSString *str = [self.itemText3.text substringFromIndex:self.itemText3.text.length-4];
            self.applyLab.text =  [NSString stringWithFormat:@"提现到%@（尾号%@），到账时间以银行实际到账时间为准",self.itemText1.text,str];
        }
    }
}

#pragma mark - Event Response

- (void)textFieldTextChange:(NSNotification*)notif
{
    if ([self.itemType isEqualToString:@"银行卡"]) {
        if (self.itemText3.text.length>6 && self.itemText3.text != nil && ![self.itemText3.text isEqualToString:@""]) {
            if (self.itemText1.text.length>0 && self.itemText3.text.length>15) {
                NSString *str = [self.itemText3.text substringFromIndex:self.itemText3.text.length-4];
                self.applyLab.text =  [NSString stringWithFormat:@"提现到%@（尾号%@），到账时间以银行实际到账时间为准",self.itemText1.text,str];
            }
        }
    }else{
        if (self.itemText1.text.length>6 && self.itemText1.text != nil && ![self.itemText1.text isEqualToString:@""]) {
            NSRange range={3,4};
            NSString *str = [self.itemText1.text stringByReplacingCharactersInRange:range withString:@"****"];
            self.applyLab.text = [NSString stringWithFormat:@"提现到支付宝（%@），到账时间以支付宝实际到账时间为准",str];
        }
    }
}



- (IBAction)selectBankClick:(id)sender {
    DLog(@"----");
    if ([self.itemType isEqualToString:@"银行卡"]) {
        FWBankListVC *vc = [FWBankListVC new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)sureClick:(id)sender {
    
    if (self.itemText1.text.length == 0 || [self.itemText1.text isEqualToString:@""] || self.itemText1.text == nil) {
        if ([self.itemType isEqualToString:@"银行卡"]) {
            [MBProgressHUD showTips:@"请选择要提现的银行"];
        }else{
            [MBProgressHUD showTips:@"请输入支付宝账号"];
        }
        return;
    }
    
    if (self.itemText2.text.length == 0 || [self.itemText2.text isEqualToString:@""] || self.itemText2.text == nil) {
        if ([self.itemType isEqualToString:@"银行卡"]) {
            [MBProgressHUD showTips:@"请输入持卡人名称"];
        }else{
            [MBProgressHUD showTips:@"请输入姓名"];
        }
        return;
    }
    
    if ([self.itemType isEqualToString:@"银行卡"]) {
        if (self.itemText3.text.length == 0 || [self.itemText3.text isEqualToString:@""] || self.itemText3.text == nil || ![NSString checkBankCard:self.itemText3.text]) {
            [MBProgressHUD showTips:@"请正确输入银行卡号"];
            return;
        }
    }
    
    if (self.cashText.text.floatValue > _balance.floatValue) {
        [MBProgressHUD showTips:@"提现金额不能大于可提现金额~"];
        return;
    }else if (self.cashText.text != nil && self.cashText.text.length>0 && self.cashText.text.floatValue>0){
        [self sureCash];
    }else{
        [MBProgressHUD showTips:@"请输入提现金额~"];
        return;
    }
}

#pragma mark - Network Requests
- (void)loadAccountData
{
    NSString *type = @"";
    if ([self.itemType isEqualToString:@"银行卡"]) {
        type = @"0";
    }else{
        type = @"1";
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"type":type
                            };
    [FWMeManager loadFaceValueAccountInfoWithParameters:param result:^(id response) {
        DLog(@"----->%@",response);
        if (response[@"success"] && [response[@"success"] isEqual:@1] && response[@"result"]) {
            NSDictionary *dic = response[@"result"];
            NSString *accountType = dic[@"accountType"];
            NSString *realName = dic[@"realName"];
            NSString *cashAccount = dic[@"cashAccount"];
            NSString *bankId = dic[@"bankId"];
            NSString *cashBankType = dic[@"cashBankType"];
            self->_bankName = cashBankType;
            self->_bankId = bankId;
            if ([accountType isEqual:@1]) {
                self.itemText1.text = cashAccount;
                self.itemText2.text = realName;
                if (cashAccount.length>3) {
                    NSRange range={3,4};
                    NSString *str = [cashAccount stringByReplacingCharactersInRange:range withString:@"****"];
                    self.applyLab.text = [NSString stringWithFormat:@"提现到支付宝（%@），到账时间以支付宝实际到账时间为准",str];
                }
            }else{
                if (self.itemText3.text.length>6 && self.itemText3.text != nil && ![self.itemText3.text isEqualToString:@""]) {
                    if (self.itemText1.text.length>0 && self.itemText3.text.length>15) {
                        NSString *str = [self.itemText3.text substringFromIndex:self.itemText3.text.length-4];
                        self.applyLab.text =  [NSString stringWithFormat:@"提现到%@（尾号%@），到账时间以银行实际到账时间为准",self.itemText1.text,str];
                    }
                }else{
                    self.itemText1.text = cashBankType;
                    self.itemText2.text = realName;
                    self.itemText3.text = cashAccount;
                    if (cashAccount.length>4) {
                        NSString *str = [cashAccount substringFromIndex:cashAccount.length-4];
                        self.applyLab.text =  [NSString stringWithFormat:@"提现到%@（尾号%@），到账时间以银行实际到账时间为准",cashBankType,str];
                    }
                }
            }
        }else{
            self.applyLab.text = @"";
        }
    }];
}

- (void)loadYueData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWMeManager loadFaceValueYueInfoWithParameters:param result:^(id response) {
        DLog(@"----->%@",response);
        NSDictionary *dic = response[@"result"];
        NSString *withdrawTime = dic[@"withdrawTime"];
        NSString *withdrawLimit = dic[@"withdrawLimit"];
        NSString *balance = dic[@"balance"];
        self->_balance = balance;
        NSString *cashOnHand = dic[@"cashOnHand"];
//        [USER_DEFAULTS setObject:balance forKey:UD_UserFaceValue];
        self.cashLab.text = [NSString stringWithFormat:@"可提现金额%.1f元",balance.floatValue];
        self.ruleLab.text = [NSString stringWithFormat:@"提现规则：\n\n1、提现时间：每周%@ 9：00~22：00；\n\n2、提现条件：提上周及以前未提现的现金；\n\n3、单日提现次数：%@次，单日限制%@元。",withdrawTime,cashOnHand,withdrawLimit];
    }];
}

- (void)sureCash
{
    NSString *type = @"";
    NSDictionary *param = nil;
    _realName = self.itemText2.text;
    if ([self.itemType isEqualToString:@"银行卡"]) {
        type = @"0";
        _cardNo = self.itemText3.text;
        param = @{
                    @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                    @"type":type,
                    @"cashAccount":_cardNo,
                    @"bankId":_bankId?:@"",
                    @"bankName":_bankName?:@"",
                    @"realName":_realName,
                    @"withdrawCash":self.cashText.text
                    };
    }else{
        type = @"1";
        _cardNo = self.itemText1.text;
        param = @{
                  @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                  @"type":type,
                  @"cashAccount":_cardNo,
                  @"realName":_realName,
                  @"withdrawCash":self.cashText.text
                  };
    }
    [FWMeManager sureFaceValueCashWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_ApplyFaceValueSuccess object:nil];
            FWFaceValueCashDetailVC *vc = [FWFaceValueCashDetailVC new];
            vc.vcType = @"FWApplyCashVC";
            vc.accountExpend = response[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = self.itemType;
    
    if ([self.itemType isEqualToString:@"银行卡"]) {
        self.img.hidden = NO;
        self.topViewH.constant = 120;
        self.rightW.constant = 25;
        self.itemText1.userInteractionEnabled = NO;
        self.bankBtn.hidden = NO;
    }else{
        self.img.hidden = YES;
        self.topViewH.constant = 80;
        self.rightW.constant = 15;
        self.itemLab1.text = @"支付宝账号";
        self.itemText1.placeholder = @"请输入支付宝账号";
        self.itemLab2.text = @"姓名";
        self.itemText2.placeholder = @"请输入姓名";
        self.itemText1.userInteractionEnabled = YES;
        self.bankBtn.hidden = YES;
    }
    
    self.sureBtn.layer.cornerRadius = 5.f;
    self.sureBtn.layer.masksToBounds = YES;
}

#pragma mark - Setters


#pragma mark - Getters


@end
