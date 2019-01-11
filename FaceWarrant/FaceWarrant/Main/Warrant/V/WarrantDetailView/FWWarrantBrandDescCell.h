//
//  FWWarrantBrandDescCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWWarrantDetailModel;

@protocol FWWarrantBrandDescCellDelegate <NSObject>
- (void)FWWarrantBrandDescCellDelegateExpandClickWithIndexPath:(NSIndexPath*)indexPath;
@end

@interface FWWarrantBrandDescCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWWarrantDetailModel *)model indexPath:(NSIndexPath*)indexPath;

@property(weak, nonatomic)id<FWWarrantBrandDescCellDelegate>delegate;
@end
