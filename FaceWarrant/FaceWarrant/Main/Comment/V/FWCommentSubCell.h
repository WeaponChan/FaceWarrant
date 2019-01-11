//
//  FWCommentSubCell.h
//  FaceWarrant
//
//  Created by FW on 2018/10/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWCommendReplyModel,FWReplyModel;

@protocol FWCommentSubCellDelegate <NSObject>

- (void)FWCommentSubCellDelegateCommentClick:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath;
- (void)FWCommentSubCellDelegateCommentDeleteClick:(FWReplyModel*)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FWCommentSubCell : UITableViewCell

@property(weak, nonatomic)id<FWCommentSubCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithCommentModel:(FWCommendReplyModel*)model replyModel:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath;
@end
