//
//  FWMQuestionCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWMessageAModel;

@protocol FWMQuestionCellDelegate <NSObject>

- (void)FWMQuestionCellDelegatespreadClick:(NSIndexPath*)indexPath;

@end

@interface FWMQuestionCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMessageAModel*)model indexPath:(NSIndexPath*)indexPath;
@property (nonatomic, weak)id<FWMQuestionCellDelegate>delegate;
@end
