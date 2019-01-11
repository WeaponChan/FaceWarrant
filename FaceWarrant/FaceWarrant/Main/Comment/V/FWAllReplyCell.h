//
//  FWAllReplyCell.h
//  FaceWarrant
//
//  Created by FW on 2018/10/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWCommendReplyModel,FWReplyModel;
@protocol FWAllReplyCellDelegate <NSObject>

- (void)FWAllReplyCellDelegateCommentAndReplyClick:(FWCommendReplyModel*)model rmodel:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath;

- (void)FWAllReplyCellDelegateCommentAndReplyDeleteClick:(FWCommendReplyModel*)model rmodel:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath;

@end

@interface FWAllReplyCell : UITableViewCell

@property(weak, nonatomic)id<FWAllReplyCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(FWCommendReplyModel*)model replyData:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath;
@end
