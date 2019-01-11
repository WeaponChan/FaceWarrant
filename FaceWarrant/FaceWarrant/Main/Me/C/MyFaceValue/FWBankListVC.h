//
//  FWBankListVC.h
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"

@protocol FWBankListVCDelegate <NSObject>

- (void)FWBankListVCDelegateClick:(NSString*)bankName bankID:(NSString*)bankId;

@end

@interface FWBankListVC : FWBaseViewController
@property (weak, nonatomic)id<FWBankListVCDelegate>delegate;
@end
