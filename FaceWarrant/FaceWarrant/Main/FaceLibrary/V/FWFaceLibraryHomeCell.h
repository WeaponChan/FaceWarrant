//
//  FWFaceLibraryHomeCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceReleaseModel;
@interface FWFaceLibraryHomeCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configCellWithData:(FWFaceReleaseModel*)model indexPath:(NSIndexPath*)indexPath;
@end
