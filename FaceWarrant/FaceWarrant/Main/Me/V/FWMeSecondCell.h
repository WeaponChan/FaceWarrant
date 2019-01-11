//
//  FWMeSecondCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMeInfoModel;
@protocol FWMeSecondCellDelegate <NSObject>
- (void)FWMeSecondCellDelegateWith:(NSInteger)tag;
@end
@interface FWMeSecondCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWMeInfoModel*)model;
@property(weak, nonatomic)id<FWMeSecondCellDelegate>delegate;
@end
