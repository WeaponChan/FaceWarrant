//
//  FWWarrantSubFooterCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWWarrantSubFooterCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithNum:(NSString*)num;
@end
