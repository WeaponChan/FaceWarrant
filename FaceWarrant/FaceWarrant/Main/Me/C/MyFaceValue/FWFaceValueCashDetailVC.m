//
//  FWFaceValueCashDetailVC.m
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceValueCashDetailVC.h"
#import "FWMeManager.h"
#import "FWFaceValueCashDetailModel.h"
#import "FWApplyCashVC.h"
@interface FWFaceValueCashDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bangimg;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
//@property (weak, nonatomic) IBOutlet UILabel *cashNoteNO;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *jineLab;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIImageView *bankImg;
@property (strong, nonatomic)FWFaceValueCashDetailModel *model;

@end

@implementation FWFaceValueCashDetailVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)cashAgainClick:(UIButton *)sender {
    if ([self.vcType isEqualToString:@"FWApplyCashVC"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        FWApplyCashVC *vc = [FWApplyCashVC new];
        
        if ([self.model.expendType isEqualToString:@"0"]) {
            vc.itemType = @"银行卡";
        }else{
            vc.itemType = @"支付宝";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{@"accountExpend":self.accountExpend};
    [FWMeManager loadFaceValueCashDetailWithParameters:param result:^(FWFaceValueCashDetailModel *model) {
        self.model = model;
        self.valueLab.text = StringConnect(@"+", model.withdrawFee);
        if ([model.status isEqualToString:@"0"]) {
            self.view1.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
            self.view2.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
            self.img2.image = Image(@"me_startCashSel");
            self.img1.image = Image(@"me_duringSel");
            self.img3.image = Image(@"me_success");
            self.lab1.textColor = [UIColor colorWithHexString:@"#FE9F25"];
            self.lab2.textColor = [UIColor colorWithHexString:@"#999999"];
            self.lab3.textColor = [UIColor colorWithHexString:@"#999999"];
        }else if ([model.status isEqualToString:@"2"]){
            self.view1.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
            self.view2.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
            self.img2.image = Image(@"me_startCashSel");
            self.img1.image = Image(@"me_duringSel");
            self.img3.image = Image(@"me_success");
            self.lab1.textColor = [UIColor colorWithHexString:@"#999999"];
            self.lab2.textColor = [UIColor colorWithHexString:@"#FE9F25"];
            self.lab3.textColor = [UIColor colorWithHexString:@"#999999"];
        }else{
            self.view1.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
            self.view2.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
            self.img2.image = Image(@"me_startCashSel");
            self.img1.image = Image(@"me_duringSel");
            self.img3.image = Image(@"me_successSel");
            self.lab1.textColor = [UIColor colorWithHexString:@"#999999"];
            self.lab2.textColor = [UIColor colorWithHexString:@"#999999"];
            self.lab3.textColor = [UIColor colorWithHexString:@"#FE9F25"];
        }
        if ([model.expendType isEqualToString:@"0"]) {
            self.bankView.hidden = YES;
            self.bankImg.hidden = NO;
            [self.bankImg sd_setImageWithURL:URL(model.bankUrl) placeholderImage:Image(@"me_zfb")];
//            self.bankName.text  = model.bankName;
            
            if (model.bankAccountNumber.length>4) {
                NSString *str = [model.bankAccountNumber substringFromIndex:model.bankAccountNumber.length-4];
                self.accountLab.text =  [NSString stringWithFormat:@"%@(尾号%@)",model.bankName,str];
            }
        }else{
            self.bankView.hidden = NO;
            self.bankImg.hidden = YES;
            [self.bangimg sd_setImageWithURL:URL(model.bankUrl) placeholderImage:Image(@"me_zfb")];
            self.bankName.text  = model.realName;
            if (![model.bankAccountNumber isKindOfClass:[NSNull class]] && model.bankAccountNumber != nil && model.bankAccountNumber.length>6) {
                NSRange range={3,4};
                NSString *str = [model.bankAccountNumber stringByReplacingCharactersInRange:range withString:@"****"];
                self.accountLab.text = [NSString stringWithFormat:@"支付宝（%@)",str];
            }
        }
        self.timeLab.text = model.withdrawalsTime;
        self.jineLab.text = model.withdrawFee;
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"提现详情";
    self.cashBtn.layer.cornerRadius = 5.f;
    self.cashBtn.layer.masksToBounds = YES;
    self.cashBtn.layer.borderColor = [UIColor colorWithHexString:@"#E6195F"].CGColor;
    self.cashBtn.layer.borderWidth = 1.f;
}


#pragma mark - Setters


#pragma mark - Getters

@end
