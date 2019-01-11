//
//  FWIntgralHeaderCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/21.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWIntegralModel;
@interface FWIntgralHeaderCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWIntegralModel*)model indexPath:(NSIndexPath*)indexPath;
@end
