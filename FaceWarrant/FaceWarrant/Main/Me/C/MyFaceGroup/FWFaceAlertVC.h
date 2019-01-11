//
//  FWFaceAlertVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/21.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWAttentionModel.h"
@interface FWFaceAlertVC : FWBaseViewController
@property (strong, nonatomic)FWAttentionModel *model;
- (void)configViewWithModel:(FWAttentionModel*)model;
@end
