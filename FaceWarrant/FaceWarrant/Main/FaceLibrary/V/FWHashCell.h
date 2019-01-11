//
//  FWHashCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHashCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithitem:(NSString*)itemStr isSearch:(BOOL)isSearch indexPath:(NSIndexPath*)indexPath;
@end
