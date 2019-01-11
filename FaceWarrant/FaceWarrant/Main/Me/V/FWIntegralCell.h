//
//  FWIntegralCell.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWPointsDetailListModel;
@interface FWIntegralCell : UITableViewCell

+ (CGFloat)cellHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configCellWithModel:(FWPointsDetailListModel*)model indexPath:(NSIndexPath*)indexPath;
@end
