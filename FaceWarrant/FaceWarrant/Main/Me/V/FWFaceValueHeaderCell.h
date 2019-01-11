//
//  FWFaceValueHeaderCell.h
//  FaceWarrantDel
//
//  Created by FW on 2018/10/29.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWFaceValueHeaderCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithIndexPath:(NSIndexPath*)indexPath item:(NSString*)item;
@end
