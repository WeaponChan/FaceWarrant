//
//  FWDiscoveryFaceCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWDiscoveryModel;
@interface FWDiscoveryFaceCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray *bannerList;
+ (CGSize)cellSize;
- (void)configCellWithData:(FWDiscoveryModel*)model;
@end
