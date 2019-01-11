//
//  FWSetUpVC.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
@class FWMeInfoModel;
@interface FWSetUpVC : FWBaseViewController
@property (copy, nonatomic)NSString *headerUrl;
@property (strong, nonatomic) FWMeInfoModel *model;
@end
