//
//  FWAttentionCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWAttentionModel,FWContactModel,FWRecommendModel;

@protocol FWAttentionCellDelegate <NSObject>
- (void)FWAttentionCellDelegateAddClick:(NSString*)faceId indexPath:(NSIndexPath*)indexPath;
- (void)FWAttentionCellDelegateInviteClick:(NSString*)phoneNum countryCode:(NSString*)code indexPath:(NSIndexPath*)indexPath;
@end
@interface FWAttentionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWAttentionModel*)model cmodel:(FWContactModel*)cmodel rmodel:(FWRecommendModel*)rmodel indexPath:(NSIndexPath*)indexPath type:(NSString *)vcType tag:(NSString*)tag;

@property (weak, nonatomic)id<FWAttentionCellDelegate>delegate;
@property (strong, nonatomic)UIButton *attenBtn;
@end
