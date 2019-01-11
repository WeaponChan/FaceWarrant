//
//  FWCountryVC.h
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWCountryModel.h"
typedef void (^CountryBlock)(NSString *name,NSString *code,NSString *cId);
@interface FWCountryVC : FWBaseViewController
@property (copy, nonatomic)CountryBlock countryblock;
@property (strong, nonatomic)NSMutableArray <FWCountryModel*> *keyList;
@end
