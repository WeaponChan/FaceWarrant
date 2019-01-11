//
//  FWMeItemCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMeInfoModel;
@interface FWMeItemCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithIndexPath:(NSIndexPath*)indexPath item:(FWMeInfoModel*)item vcType:(NSString*)vcType;
@end
