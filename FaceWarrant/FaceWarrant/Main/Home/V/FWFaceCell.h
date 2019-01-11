//
//  FWFaceCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWFaceModelDelegate <NSObject>
- (void)FWFaceModelDelegateClickWithID:(NSString*)userId faceId:(NSString*)faceId isAtten:(NSString*)isAttention indexPath:(NSIndexPath *)indexPath;
@end
@class FWFaceModel;
@interface FWFaceCell : UICollectionViewCell
+ (CGSize)cellSize;
- (void)configCellWithData:(FWFaceModel*)model indexPath:(NSIndexPath*)indexPath;
@property (weak, nonatomic)id<FWFaceModelDelegate>delegate;
@end
