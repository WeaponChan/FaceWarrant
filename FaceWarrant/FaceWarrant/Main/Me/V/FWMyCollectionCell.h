//
//  FWMyCollectionCell.h
//  FaceWarrant
//
//  Created by FW on 2018/8/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectBlock)(void);

@class FWMyCollectionModel;

@interface FWMyCollectionCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configCellWithData:(FWMyCollectionModel*)model isEdit:(BOOL)isEdit indexPath:(NSIndexPath*)indexPath;

@property (nonatomic, strong) UIButton *delBtn;

@property (copy, nonatomic)SelectBlock selectblock;
@end
