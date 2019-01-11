//
//  FWBrandHeaderView.h
//  FaceWarrant
//
//  Created by Weapon on 2018/11/20.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWBrandDetailModel;
@interface FWBrandHeaderView : UIView
- (instancetype)initFaceBrandHeaderViewWithFrame:(CGRect)frame;
- (void)configCellWithModel:(FWBrandDetailModel*)model;
@end
