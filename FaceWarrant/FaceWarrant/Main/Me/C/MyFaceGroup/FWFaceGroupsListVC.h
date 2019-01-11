//
//  FWFaceGroupsListVC.h
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWFaceLibraryClassifyModel.h"
@interface FWFaceGroupsListVC : FWBaseViewController
@property(strong, nonatomic)FWFaceLibraryClassifyModel *model;
@property (copy, nonatomic)NSString *groupId;
@property (copy, nonatomic)NSString *groupName;
@property (copy, nonatomic)NSString *groupType;
@end
