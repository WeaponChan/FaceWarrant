//
//  FWSearchFaceCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class FWSearchFaceModel;
@interface FWSearchFaceCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(NSArray*)data indexPath:(NSIndexPath*)indexPath;
- (CGFloat)configCellHeightWithData:(NSArray*)data indexPath:(NSIndexPath*)indexPath;
@end
