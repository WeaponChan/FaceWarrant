//
//  FWWarrantItemVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
@protocol FWWarrantItemVCDelegate <NSObject>
- (void)FWWarrantItemVCDelegateClickWithTag:(NSInteger)tag;
@end
@interface FWWarrantItemVC :FWBaseViewController
@property (weak, nonatomic)id<FWWarrantItemVCDelegate>delegate;
@end
