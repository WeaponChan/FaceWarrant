//
//  FWWarrantBottomBuyView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWWarrantDetailModel;

@interface FWWarrantBottomBuyView : UIView
+ (instancetype)shareBottomBuyView;
- (void)configViewWithData:(FWWarrantDetailModel*)model code:(NSString *)resultCode;
@end
