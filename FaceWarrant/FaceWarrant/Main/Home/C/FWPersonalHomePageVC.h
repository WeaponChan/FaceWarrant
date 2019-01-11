//
//  FWPersonalHomePageVC.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"

@interface FWPersonalHomePageVC : FWBaseViewController
@property(copy, nonatomic)NSString *faceId;
@property(copy, nonatomic)NSString *searchText;
@property(copy, nonatomic)NSString *brandId;
@property(strong, nonatomic)NSIndexPath *indexPath;
@end
