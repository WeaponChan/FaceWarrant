//
//  FWBankListCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWBankModel;
@interface FWBankListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(FWBankModel*)model indexPath:(NSIndexPath*)indexPath;
@end
