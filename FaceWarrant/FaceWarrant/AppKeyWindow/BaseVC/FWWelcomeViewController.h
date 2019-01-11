//
//  FWWelcomeViewController.h
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
typedef void(^completionBlock)(void);
@interface FWWelcomeViewController : FWBaseViewController
@property (nonatomic, copy) completionBlock block;
- (void)welcomeViewStartAnimationWithCompletion:(completionBlock)block;
@end
