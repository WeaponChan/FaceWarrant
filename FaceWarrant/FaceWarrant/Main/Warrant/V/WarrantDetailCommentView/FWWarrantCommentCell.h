//
//  FWWarrantCommentCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommendReplyModel,FWWarrantDetailModel;


@interface FWWarrantCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(FWWarrantDetailModel*)dModel commentReplyModel:(CommendReplyModel*)model  indexPath:(NSIndexPath*)indexPath;
@end
