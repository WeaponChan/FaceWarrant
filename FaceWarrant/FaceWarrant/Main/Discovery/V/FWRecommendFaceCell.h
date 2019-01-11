//
//  FWRecommendFaceCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/7.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWDiscoveryFaceModel;
@protocol FWRecommendFaceCellDelegate <NSObject>
- (void)FWRecommendFaceCellDelegateClickWithID:(NSString*)userId faceId:(NSString*)faceId isAtten:(NSString*)isAttention indexPath:(NSIndexPath*)indexPath;
@end
@interface FWRecommendFaceCell : UICollectionViewCell

+ (CGSize)cellSize;
- (void)configCellWithData:(FWDiscoveryFaceModel*)model indexPath:(NSIndexPath*)indexPath;
@property (weak, nonatomic)id<FWRecommendFaceCellDelegate>delegate;
@end
