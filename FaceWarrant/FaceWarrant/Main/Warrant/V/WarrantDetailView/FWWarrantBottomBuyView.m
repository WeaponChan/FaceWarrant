//
//  FWWarrantBottomBuyView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantBottomBuyView.h"
#import "FWWarrantDetailModel.h"
#import "FWWarrantManager.h"
#import "FWCommentListVC.h"
#import "FWQCodeVC.h"
#import "FWWarrantManager.h"
@interface FWWarrantBottomBuyView()
@property (weak, nonatomic) IBOutlet UILabel *shanglianLab;
@property (weak, nonatomic) IBOutlet UIImageView *shanglianImg;
@property (weak, nonatomic) IBOutlet UILabel *commendLab;
@property (weak, nonatomic) IBOutlet UILabel *xinyuanLab;
@property (weak, nonatomic) IBOutlet UIImageView *xinyuanImg;
@property (strong, nonatomic)FWWarrantDetailModel *model;
@property (strong ,nonatomic)NSString *resultCode;
@property (strong, nonatomic)FWQCodeVC *qCodeVC;
@end

@implementation FWWarrantBottomBuyView

#pragma mark - Life Cycle

+ (instancetype)shareBottomBuyView
{
    return [[NSBundle mainBundle] loadNibNamed:@"FWWarrantBottomBuyView" owner:self options:nil].firstObject;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (IBAction)bottomViewClick:(UIButton *)sender {
    if (sender.tag == 0) {
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"isFavorite":self.model.isFavorite,
                                @"releaseGoodsId":self.model.releaseGoodsId
                                };
        [self actionfavorited:param];
    }else if(sender.tag == 1){
        if ([self.resultCode isEqual:@4002]) {
            [MBProgressHUD showTips:@"此碑它已被取消"];
        }else{
            FWCommentListVC *vc = [[FWCommentListVC alloc] init];
            vc.commentType = @"1";
            vc.dModel = self.model;
            [[self superViewController:self].navigationController pushViewController:vc animated:YES];
        }
    }else if (sender.tag == 2){
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"isCollect":self.model.isCollect,
                                @"releaseGoodsId":self.model.releaseGoodsId
                                };
        [self actioncollected:param];
    }else{
        DLog(@"购买");
        NSDictionary *param = @{
                                @"orderSource":@"1",
                                @"phoneNo":[USER_DEFAULTS objectForKey:UD_UserPhone],
                                @"releaseGoodsId":self.model.releaseGoodsId,
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"faceId":self.model.faceId,
                                @"countryCode":[USER_DEFAULTS objectForKey:UD_Code]
                                };
        [self actionbuy:param];
    }
}

#pragma mark - Network Requests

- (void)actionfavorited:(NSDictionary*)param
{
    [FWWarrantManager actionWarrantFavoritedWithParameter:param result:^(id response) {
        if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@200]) {
            NSInteger favorite = self.model.favoriteCount.integerValue;
            if ([self.model.isFavorite isEqualToString:@"0"]) {
                self.shanglianImg.image = Image(@"warrant_xiaoSel");
                favorite = favorite+1;
                self.model.favoriteCount = [NSString stringWithFormat:@"%ld",favorite];
                self.model.isFavorite = @"1";
            }else{
                self.shanglianImg.image = Image(@"warrant_xiao");
                favorite = favorite-1;
                self.model.favoriteCount = [NSString stringWithFormat:@"%ld",favorite];
                self.model.isFavorite = @"0";
            }
            self.shanglianLab.text = [NSString stringWithFormat:@"赏脸·%ld",favorite];
        }else if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@4002]){
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

- (void)actioncollected:(NSDictionary*)param
{
    [FWWarrantManager actionWarrantCollectedWithParameter:param result:^(id response) {
        if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@200]) {
            NSInteger collect = self.model.collectCount.integerValue;
            if ([self.model.isCollect isEqualToString:@"0"]) {
                self.xinyuanImg.image = Image(@"warrant_starSel");
                collect = collect+1;
                self.model.collectCount = [NSString stringWithFormat:@"%ld",collect];
                self.model.isCollect = @"1";
            }else{
                self.xinyuanImg.image = Image(@"warrant_star");
                collect = collect-1;
                self.model.collectCount = [NSString stringWithFormat:@"%ld",collect];
                self.model.isCollect = @"0";
            }
            self.xinyuanLab.text = [NSString stringWithFormat:@"心愿·%ld",collect];
        }else if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@4002]){
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

- (void)actionbuy:(NSDictionary*)param
{
    MBProgressHUD *hud = [MBProgressHUD showHUDwithMessage:@"正在生成二维码"];
    [FWWarrantManager buywarrantgoodsWithParameters:param result:^(FWOrderModel *model) {
        if ([model.code isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            self.qCodeVC.model = model;
            if ((model.buyUrl != nil && ![model.buyUrl isEqualToString:@""] && model.orderId != nil && ![model.orderId isEqualToString:@""]) || (model.microMallCode && ![model.microMallCode isEqualToString:@""] && model.microMallOrderId && ![model.microMallOrderId isEqualToString:@""])) {
                self.qCodeVC.oneQRImage = YES;
            }
            if (model.buyUrl != nil && ![model.buyUrl isEqualToString:@""] && model.orderId != nil && ![model.orderId isEqualToString:@""] && model.microMallCode && ![model.microMallCode isEqualToString:@""] && model.microMallOrderId && ![model.microMallOrderId isEqualToString:@""]) {
                self.qCodeVC.oneQRImage = NO;
            }
            self.qCodeVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.qCodeVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [[self superViewController:self] presentViewController:self.qCodeVC animated:YES completion:^(void)
             {
                 self.qCodeVC.view.superview.backgroundColor = [UIColor clearColor];
             }];
        }else{
            [hud hideAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showTips:model.message];
            });
        }
    }];
}
#pragma mark - Public Methods

- (void)configViewWithData:(FWWarrantDetailModel*)model code:(NSString *)resultCode
{
    self.model = model;
    self.resultCode = resultCode;
    self.shanglianLab.text = StringConnect(@"赏脸·", model.favoriteCount);
    self.commendLab.text = StringConnect(@"评论·", model.commentCount);
    self.xinyuanLab.text = StringConnect(@"心愿·", model.collectCount);
    if ([model.isFavorite isEqualToString:@"1"]) {
        [self.shanglianImg setImage:Image(@"warrant_xiaoSel")];
    }else{
        [self.shanglianImg setImage:Image(@"warrant_xiao")];
    }
    
    if ([model.isCollect isEqualToString:@"1"]) {
        [self.xinyuanImg setImage:Image(@"warrant_starSel")];
    }else{
        [self.xinyuanImg setImage:Image(@"warrant_star")];
    }
}

#pragma mark - Private Methods
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters

- (FWQCodeVC*)qCodeVC
{
    if (_qCodeVC == nil) {
        _qCodeVC = [FWQCodeVC new];
    }
    return _qCodeVC;
}

#pragma mark - Getters



@end
