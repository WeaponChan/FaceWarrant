//
//  FWWarrantInfoImgCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWWarrantInfoImgCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithData:(UIImage*)image;
@end
