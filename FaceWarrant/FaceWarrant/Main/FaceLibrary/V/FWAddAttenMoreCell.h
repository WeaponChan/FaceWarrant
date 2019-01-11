//
//  FWAddAttenMoreCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/12.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWAddMoreFaceModel,FWContactModel;

@protocol FWAddAttenMoreCellDelegate <NSObject>
- (void)FWAddAttenMoreCellDelegateAddClick:(FWAddMoreFaceModel*)fmodel cmodel:(FWContactModel*)cmodel indexPath:(NSIndexPath*)indexPath;
- (void)FWAddAttenMoreCellDelegateInviteClick:(FWContactModel*)cmodel indexPath:(NSIndexPath*)indexPath;
@end

@interface FWAddAttenMoreCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWAddMoreFaceModel*)model cmodel:(FWContactModel*)cmodel type:(NSString*)type indexPath:(NSIndexPath*)indexPath;
@property (strong, nonatomic)UIButton *attenBtn;
@property (weak, nonatomic)id<FWAddAttenMoreCellDelegate>delegate;
@end
