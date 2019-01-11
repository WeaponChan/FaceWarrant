//
//  FWFaceLibraryCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceLibraryModel;
@interface FWFaceLibraryCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWFaceLibraryModel*)model indexPath:(NSIndexPath*)indexPath selectType:(NSString*)selectType;
@end
