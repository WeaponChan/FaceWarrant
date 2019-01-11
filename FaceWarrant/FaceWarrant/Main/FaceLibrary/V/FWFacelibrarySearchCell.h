//
//  FWFacelibrarySearchCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFacelibrarySearchFaceModel;
@interface FWFacelibrarySearchCell : UICollectionViewCell

+ (CGSize)cellSize;
- (void)configCellWithData:(FWFacelibrarySearchFaceModel*)model indexPath:(NSIndexPath*)indexPath;
@end
