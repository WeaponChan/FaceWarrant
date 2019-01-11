//
//  FWMFavoriteCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMessageAModel;
@interface FWMFavoriteCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWMessageAModel*)model indexPath:(NSIndexPath*)indexPath;
@end
