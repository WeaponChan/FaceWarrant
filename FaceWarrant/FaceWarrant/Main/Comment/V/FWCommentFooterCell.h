//
//  FWCommentFooterCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWCommendReplyModel;
@protocol FWCommentFooterCellDelegate <NSObject>
- (void)FWCommentFooterCellDelegateClick:(NSString*)commentId;
@end

@interface FWCommentFooterCell : UITableViewCell
@property (weak, nonatomic)id<FWCommentFooterCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithNum:(FWCommendReplyModel*)model indexPath:(NSIndexPath*)indexPath;
@end
