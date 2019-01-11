//
//  FWMyReleasegoodsCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceReleaseModel;

@protocol FWMyReleasegoodsCellDelegate <NSObject>

- (void)FWMyReleasegoodsCellDelegateDeleteClick:(NSString *)releasegoodId indexPath:(NSIndexPath*)indexPath;

@end

@interface FWMyReleasegoodsCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configCellWithData:(FWFaceReleaseModel*)model isEdit:(BOOL)isEdit indexPath:(NSIndexPath*)indexPath;

@property (nonatomic, strong) UIButton *delBtn;

@property (weak, nonatomic)id<FWMyReleasegoodsCellDelegate>delegate;
@end
