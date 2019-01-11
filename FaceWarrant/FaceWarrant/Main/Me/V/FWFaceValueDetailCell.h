//
//  FWFaceValueDetailCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceValueCashItemModel;
@interface FWFaceValueDetailCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWFaceValueCashItemModel*)model type:(NSString*)type indexPath:(NSIndexPath *)indexPath;
@end
