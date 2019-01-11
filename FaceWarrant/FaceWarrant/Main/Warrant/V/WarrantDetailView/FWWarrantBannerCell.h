//
//  FWWarrantBannerCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWWarrantDetailModel;
@protocol FWWarrantBannerCellDelegate<NSObject>
- (void)FWWarrantBannerCellDelegateWithHeight:(CGFloat)height;
- (void)FWWarrantBannerCellDelegateClick:(NSString*)playAuth;
@end

@interface FWWarrantBannerCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(FWWarrantDetailModel*)model;
@property (weak, nonatomic)id<FWWarrantBannerCellDelegate>celldelegate;
@end
