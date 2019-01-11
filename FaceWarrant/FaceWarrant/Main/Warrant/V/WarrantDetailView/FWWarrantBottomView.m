//
//  FWWarrantBottomView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantBottomView.h"
#import "FWWarrantDetailModel.h"
#import "FWWarrantManager.h"
#import "FWCommentListVC.h"
@interface FWWarrantBottomView()
@property (weak, nonatomic) IBOutlet UIButton *shanglianBtn;
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;
@property (weak, nonatomic) IBOutlet UIButton *xinyuanBtn;
@property (strong, nonatomic)FWWarrantDetailModel *model;
@property (strong ,nonatomic)NSString *resultCode;

@end

@implementation FWWarrantBottomView

#pragma mark - Life Cycle

+ (instancetype)shareBottomView
{
    return [[NSBundle mainBundle] loadNibNamed:@"FWWarrantBottomView" owner:self options:nil].firstObject;
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
    }else if (sender.tag == 2){
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"isCollect":self.model.isCollect,
                                @"releaseGoodsId":self.model.releaseGoodsId
                                };
        [self actioncollected:param];
    }else{
        if ([self.resultCode isEqual:@4002]) {
            [MBProgressHUD showTips:@"此碑它已被取消"];
        }else{
            FWCommentListVC *vc = [[FWCommentListVC alloc] init];
            vc.commentType = @"1";
            vc.dModel = self.model;
            vc.releaseGoodsId = self.model.releaseGoodsId;
            [[self superViewController:self].navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Network Requests

- (void)actionfavorited:(NSDictionary*)param
{
    [FWWarrantManager actionWarrantFavoritedWithParameter:param result:^(id response) {
        if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@200]) {
            NSInteger favorite = self.model.favoriteCount.integerValue;
            if ([self.model.isFavorite isEqualToString:@"0"]) {
                [self.shanglianBtn setImage:Image(@"warrant_xiaoSel") forState:UIControlStateNormal];
                favorite = favorite+1;
                self.model.favoriteCount = [NSString stringWithFormat:@"%ld",favorite];
                self.model.isFavorite = @"1";
            }else{
                [self.shanglianBtn setImage:Image(@"warrant_xiao") forState:UIControlStateNormal];
                favorite = favorite-1;
                self.model.favoriteCount = [NSString stringWithFormat:@"%ld",favorite];
                self.model.isFavorite = @"0";
            }
            [self.shanglianBtn setTitle:[NSString stringWithFormat:@"赏脸·%ld",favorite] forState:UIControlStateNormal];
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
                [self.xinyuanBtn setImage:Image(@"warrant_starSel") forState:UIControlStateNormal];
                collect = collect+1;
                self.model.collectCount = [NSString stringWithFormat:@"%ld",collect];
                self.model.isCollect = @"1";
            }else{
                [self.xinyuanBtn setImage:Image(@"warrant_star") forState:UIControlStateNormal];
                collect = collect-1;
                self.model.collectCount = [NSString stringWithFormat:@"%ld",collect];
                self.model.isCollect = @"0";
            }
            [self.xinyuanBtn setTitle:[NSString stringWithFormat:@"心愿·%ld",collect] forState:UIControlStateNormal];
        }else if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@4002]){
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}


#pragma mark - Public Methods
- (void)configViewWithData:(FWWarrantDetailModel*)model code:(NSString *)resultCode
{
    self.model = model;
    self.resultCode = resultCode;
    [self.shanglianBtn setTitle:StringConnect(@"赏脸·", model.favoriteCount) forState:UIControlStateNormal];
    [self.commendBtn setTitle:StringConnect(@"评论·", model.commentCount) forState:UIControlStateNormal];
    [self.xinyuanBtn setTitle:StringConnect(@"心愿·", model.collectCount) forState:UIControlStateNormal];
    
    if ([model.isFavorite isEqualToString:@"1"]) {
        [self.shanglianBtn setImage:Image(@"warrant_xiaoSel") forState:UIControlStateNormal];
    }else{
        [self.shanglianBtn setImage:Image(@"warrant_xiao") forState:UIControlStateNormal];
    }
    
    if ([model.isCollect isEqualToString:@"1"]) {
        [self.xinyuanBtn setImage:Image(@"warrant_starSel") forState:UIControlStateNormal];
    }else{
        [self.xinyuanBtn setImage:Image(@"warrant_star") forState:UIControlStateNormal];
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


#pragma mark - Getters



@end
