//
//  FWMCommentFCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMessageAModel;

@interface FWMCommentFCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMessageAModel*)model;
@end
