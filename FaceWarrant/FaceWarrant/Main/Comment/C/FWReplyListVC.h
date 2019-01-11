//
//  FWReplyListVC.h
//  FaceWarrant
//
//  Created by FW on 2018/10/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWWarrantDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@class FWCommendReplyModel;
@interface FWReplyListVC : FWBaseViewController
@property (nonatomic, strong) FWCommendReplyModel *model;
@property (nonatomic, strong) FWWarrantDetailModel *dModel;
@end

NS_ASSUME_NONNULL_END
