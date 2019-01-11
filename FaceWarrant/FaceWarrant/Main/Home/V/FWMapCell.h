//
//  FWMapCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWShopModel;

@protocol FWMapCellDelegate <NSObject>

- (void)FWMapCellDelegateCellClick:(NSIndexPath *)indexPath;

@end

@interface FWMapCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWShopModel*)model fromAddr:(NSString *)fromAddr indexPath:(NSIndexPath*)indexPath;
@property (weak, nonatomic)id<FWMapCellDelegate>delegate;

@end
