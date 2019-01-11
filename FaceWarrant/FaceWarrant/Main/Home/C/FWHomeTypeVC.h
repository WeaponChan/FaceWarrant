//
//  FWHomeTypeVC.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
@protocol FWHomeTypeVCDelegate <NSObject>
- (void)FWHomeTypeVCDelegateScrollWithY:(CGFloat)offsetY newoffsetY:(CGFloat)newoffsetY;
@end
@interface FWHomeTypeVC : FWBaseViewController
@property (assign,nonatomic)NSInteger selectType;
@property (strong, nonatomic)NSMutableArray *classifyArr;
@property(weak,nonatomic)id<FWHomeTypeVCDelegate>delegate;
@end
