//
//  FWMessageCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMessageModel;
@interface FWMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMessageModel*)model indexPath:(NSIndexPath*)indexPath;
@end
