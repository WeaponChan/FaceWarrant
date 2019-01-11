//
//  FWCountryCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWCountryListModel;
@interface FWCountryCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWCountryListModel*)model indexPath:(NSIndexPath*)indexPath;
@end
