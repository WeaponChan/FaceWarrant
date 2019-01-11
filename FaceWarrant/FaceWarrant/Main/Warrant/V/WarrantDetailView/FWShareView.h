//
//  FWShareView.h
//  FaceWarrant
//
//  Created by FW on 2018/9/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CancelBlock)(void);

@class FWWarrantDetailModel;
@interface FWShareView : UIView
+ (instancetype)shareView;
- (void)configViewWithModel:(FWWarrantDetailModel*)model;
@property (copy, nonatomic)CancelBlock cancelblock;
@end
