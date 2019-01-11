//
//  FWTXNoteCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceValueNoteModel;
@interface FWTXNoteCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWFaceValueNoteModel*)model indexPath:(NSIndexPath*)indexPath;
@end
