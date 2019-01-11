//
//  FWFaceLibrarySearchVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWFacelibrarySearchModel.h"
@interface FWFaceLibrarySearchVC : FWBaseViewController
@property(copy, nonatomic)NSString *searchText;
@property(strong, nonatomic)FWFacelibrarySearchModel *model;
@end
