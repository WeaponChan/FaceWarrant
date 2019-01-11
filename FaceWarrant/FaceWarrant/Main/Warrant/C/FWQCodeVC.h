//
//  FWQCodeVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
@class FWOrderModel;
@interface FWQCodeVC : FWBaseViewController
@property(strong, nonatomic)FWOrderModel *model;
@property (nonatomic, assign) BOOL oneQRImage;
@end
