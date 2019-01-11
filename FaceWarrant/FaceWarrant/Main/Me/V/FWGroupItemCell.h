//
//  FWGroupItemCell.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceLibraryClassifyModel;
@protocol FWGroupItemCellDelegate <NSObject>
- (void)FWGroupItemCellDelegateClickWithModel:(FWFaceLibraryClassifyModel *)model tag:(NSInteger)tag ;
@end

@interface FWGroupItemCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWFaceLibraryClassifyModel *)model indexPath:(NSIndexPath*)indexPath;

@property (weak, nonatomic)id<FWGroupItemCellDelegate>delegate;
@end
