//
//  FWFaceHomeHeaderView.h
//  FaceWarrantDel
//
//  Created by FW on 2018/11/9.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWFaceHomeModel;
@protocol FWFaceHomeHeaderViewDelegate <NSObject>
- (void)FWFaceHomeHeaderViewDelegateMoreBrandClick;
- (void)FWFaceHomeHeaderViewDelegateMoregoodsClick:(NSString*)sortType;
@end
@interface FWFaceHomeHeaderView : UIView
- (instancetype)initFaceHomeHeaderViewWithFrame:(CGRect)frame;
- (void)configCellWithModel:(FWFaceHomeModel*)model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic)id<FWFaceHomeHeaderViewDelegate>delegate;
@end
