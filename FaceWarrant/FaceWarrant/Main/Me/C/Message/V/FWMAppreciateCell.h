//
//  FWMAppreciateCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMessageAModel;
@interface FWMAppreciateCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMessageAModel*)model type:(NSString*)type;
@end
