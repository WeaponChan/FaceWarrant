//
//  FWEditFacesVC.h
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWFaceLibraryClassifyModel.h"
typedef void (^GroupsNameBlock)(NSString *str);

@interface FWEditFacesVC : FWBaseViewController
@property (strong, nonatomic)FWFaceLibraryClassifyModel *model;
@property (copy, nonatomic)NSString *type;
@property (copy, nonatomic)GroupsNameBlock groupblock;
@end
