//
//  FWMyFacesSubVC.h
//  FaceWarrant
//
//  Created by FW on 2018/10/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"

@protocol FWMyFacesSubVCDelegate <NSObject>

- (void)FWMyFacesSubVCDelegateScrollOffsetY:(CGFloat)offsetY;

@end

@interface FWMyFacesSubVC : FWBaseViewController
@property(copy, nonatomic)NSString *groupId;
@property(weak, nonatomic)id<FWMyFacesSubVCDelegate>delegate;
@end
