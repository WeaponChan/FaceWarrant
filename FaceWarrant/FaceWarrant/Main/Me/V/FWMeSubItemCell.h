//
//  FWMeSubItemCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWMeSubItemCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithIndexPath:(NSIndexPath*)indexPath item:(NSString*)item vcType:(NSString*)vcType;
@end
