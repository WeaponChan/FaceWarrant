//
//  FWWarrantInfoItemCell.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FWWarrantInfoItemCellDelegate <NSObject>
- (void)FWWarrantInfoItemCellDelegate:(NSString*)text;
@end

@interface FWWarrantInfoItemCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithBrand:(NSString*)brand bigSort:(NSString*)bigSort smallSort:(NSString*)smallSort name:(NSString*)name idinfo:(NSString*)idinfo IndexPath:(NSIndexPath*)indexPath;

@property (weak, nonatomic)id<FWWarrantInfoItemCellDelegate>delegate;
@end
