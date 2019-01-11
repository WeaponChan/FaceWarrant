//
//  FWQDetailFCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWQAndADetailModel,AnswerInfoListModel;

@interface FWQDetailFCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWQAndADetailModel *)model subModel:(AnswerInfoListModel *)aModel indexPath:(NSIndexPath*)indexPath;
@end
