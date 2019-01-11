//
//  FWModifyHeaderCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWModifyHeaderCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithheaderUrl:(NSString*)url;
@end
