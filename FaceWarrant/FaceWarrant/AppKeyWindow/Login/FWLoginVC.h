//
//  FWLoginVC.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
typedef void (^FWLoginBlock)(NSString *type);

@interface FWLoginVC : FWBaseViewController
@property (copy, nonatomic)FWLoginBlock loginblock;
+ (instancetype)showLoginView:(void(^)(NSString *logintype))block;

@end
