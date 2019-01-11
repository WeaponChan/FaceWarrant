//
//  FWWarrantItemView.h
//  FaceWarrant
//
//  Created by FW on 2018/9/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWWarrantItemViewDelegate <NSObject>
- (void)FWWarrantItemViewDelegateClickWithTag:(NSInteger)tag;
@end
@interface FWWarrantItemView : UIView
+ (instancetype)shareWarrantItemView;
@property (weak, nonatomic)id<FWWarrantItemViewDelegate>delegate;
@end
