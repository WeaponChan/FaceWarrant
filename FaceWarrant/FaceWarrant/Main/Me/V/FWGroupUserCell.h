//
//  FWGroupUserCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWAttentionModel;
@interface FWGroupUserCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configCellWithData:(NSArray*)data indexPath:(NSIndexPath*)indexPath type:(NSString*)type faceGroupName:(NSString*)facegroupName;
@end
