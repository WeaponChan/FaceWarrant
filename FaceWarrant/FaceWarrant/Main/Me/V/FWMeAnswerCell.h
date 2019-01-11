//
//  FWMeAnswerCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMeAnswerModel;

@interface FWMeAnswerCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


- (void)configCellWithModel:(FWMeAnswerModel*)model indexPath:(NSIndexPath*)indexPath;

@end
