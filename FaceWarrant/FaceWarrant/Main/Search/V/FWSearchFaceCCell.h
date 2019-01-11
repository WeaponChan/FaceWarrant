//
//  FWSearchFaceCCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWSearchFaceModel;
@interface FWSearchFaceCCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configCellWithModel:(FWSearchFaceModel*)model indexPath:(NSIndexPath*)indexPath;
@end
