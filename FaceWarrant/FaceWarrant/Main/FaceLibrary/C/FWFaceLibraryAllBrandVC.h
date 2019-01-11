//
//  FWFaceLibraryAllBrandVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
@class FWBrandModel;
typedef void (^BrandIdBlock)(FWBrandModel *model,NSString *all);

@interface FWFaceLibraryAllBrandVC : FWBaseViewController
@property (copy, nonatomic)NSString *searchText;
@property (copy, nonatomic)BrandIdBlock brandidblock;
@end
