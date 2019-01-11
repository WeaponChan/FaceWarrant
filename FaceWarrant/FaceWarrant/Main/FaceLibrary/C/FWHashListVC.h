//
//  FWHashListVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
typedef void (^HashBlock)(NSString *hash);
@interface FWHashListVC : FWBaseViewController
@property (copy, nonatomic)HashBlock hashblock;
@end
