//
//  FWMyWarrantCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceReleaseModel;
@interface FWMyWarrantCell : UICollectionViewCell

+ (CGSize)cellSize;
- (void)configCellWithModel:(FWFaceReleaseModel *)model indexPath:(NSIndexPath*)indexPath;
@end
