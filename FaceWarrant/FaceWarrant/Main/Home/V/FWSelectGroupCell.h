//
//  FWSelectGroupCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWFaceLibraryClassifyModel.h"
typedef void (^SelectBlock)(BOOL isSelect);
@interface FWSelectGroupCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@property(strong, nonatomic)FWFaceLibraryClassifyModel *model;
@property(copy,nonatomic)SelectBlock selectblock;
@end
