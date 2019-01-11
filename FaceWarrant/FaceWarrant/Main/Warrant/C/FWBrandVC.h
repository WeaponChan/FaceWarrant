//
//  FWBrandVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
typedef void (^FWBrandVCBlock)(NSString *name,NSString *ID);

@interface FWBrandVC : FWBaseViewController
@property (copy, nonatomic)NSString *faceId;
@property (copy, nonatomic)NSString *searchCondition;
@property (copy, nonatomic)NSString *vcType;
@property (copy, nonatomic)NSString *brandId;
@property (copy, nonatomic)NSString *bigClassId;
@property (copy, nonatomic)NSString *smallClassId;
@property (copy, nonatomic)FWBrandVCBlock block;

@end











