//
//  FWWarrantBottomView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWWarrantDetailModel;

@interface FWWarrantBottomView : UIView
+ (instancetype)shareBottomView;
- (void)configViewWithData:(FWWarrantDetailModel*)model code:(NSString *)resultCode;
@end
