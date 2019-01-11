//
//  FWMeHeaderCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  FWMeInfoModel;
@protocol FWMeHeaderCellDelegate <NSObject>
- (void)FWMeHeaderCellDelegateWith:(NSInteger)tag;
@end


@interface FWMeHeaderCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMeInfoModel*)model;

@property (weak, nonatomic)id<FWMeHeaderCellDelegate>delegate;
@end
