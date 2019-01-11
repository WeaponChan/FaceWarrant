//
//  FWCommentCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWWarrantDetailModel,FWCommendReplyModel,FWReplyModel;

@protocol FWCommentCellDelegate <NSObject>
- (void)FWCommentCellDelegateClickWithModel:(FWCommendReplyModel*)model indexPath:(NSIndexPath *)indexPath;
- (void)FWCommentCellDelegateReplyClickWithModel:(FWReplyModel*)rmodel indexPath:(NSIndexPath *)indexPath;
- (void)FWCommentCellDelegateCommentDeleteClick:(FWCommendReplyModel*)model indexPath:(NSIndexPath *)indexPath;
- (void)FWCommentCellDelegateReplyDeleteClick:(FWReplyModel*)rmodel indexPath:(NSIndexPath *)indexPath;
@end

@interface FWCommentCell : UITableViewCell

@property (weak, nonatomic)id<FWCommentCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(FWWarrantDetailModel*)dmodel model:(FWCommendReplyModel*)model moreReplyData:(NSArray*)moreReplyArr indexPath:(NSIndexPath*)indexPath;
@end
