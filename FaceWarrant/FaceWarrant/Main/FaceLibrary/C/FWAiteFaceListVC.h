//
//  FWAiteFaceListVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
typedef  void (^AiteFaceBlock)(NSArray *groups,NSArray *faces,NSArray *groupNames,NSArray *faceNames);
@interface FWAiteFaceListVC : FWBaseViewController
@property (copy, nonatomic)AiteFaceBlock aitefaceblock;
@end
