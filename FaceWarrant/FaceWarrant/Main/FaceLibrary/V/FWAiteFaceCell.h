//
//  FWAiteFaceCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWAiteFaceModel,FWAiteFacesListModel,FWAiteGroupsListModel;

@protocol FWAiteFaceCellDelegate <NSObject>

- (void)FWAiteFaceCellDelegateClick:(NSIndexPath*)indexPath;

@end

@interface FWAiteFaceCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWAiteGroupsListModel*)gmodel fmodel:(FWAiteFacesListModel*)fmodel indexPath:(NSIndexPath *)indexPath;

@property (weak, nonatomic)id<FWAiteFaceCellDelegate>delegate;
@end
