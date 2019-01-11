//
//  FWFaceLibraryBrandCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWFaceLibraryBrandCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithName:(NSString*)name indexPath:(NSIndexPath*)indexPath;
@end
