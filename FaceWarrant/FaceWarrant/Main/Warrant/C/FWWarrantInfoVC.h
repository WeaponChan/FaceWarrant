//
//  FWWarrantInfoVC.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"

@interface FWWarrantInfoVC : FWBaseViewController
@property (strong, nonatomic)UIImage *image;
@property (strong, nonatomic)NSString *imagePath;
@property (strong, nonatomic)NSString *videoPath;
@property (copy, nonatomic)NSString *type;


@property (assign, nonatomic)BOOL isIOSTen;
@end
