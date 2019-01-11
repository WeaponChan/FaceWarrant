//
//  FWMAttentionCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMessageAModel;
@interface FWMAttentionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMessageAModel*)model indexPath:(NSIndexPath*)indexPath;
+ (CGFloat)cellHeight;
@end
