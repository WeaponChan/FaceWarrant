//
//  FWEditFacesCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWAttentionModel;

@protocol FWEditFacesCellDelegate <NSObject>

- (void)FWEditFacesCellDelegateClick:(NSIndexPath*)indexPath;

@end

@interface FWEditFacesCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWAttentionModel*)model indexPath:(NSIndexPath*)indexPath;

@property(weak, nonatomic)id<FWEditFacesCellDelegate>delegate;
@end
