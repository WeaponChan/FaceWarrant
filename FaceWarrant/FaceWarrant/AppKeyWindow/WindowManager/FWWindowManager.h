//
//  FWWindowManager.h
//  FaceWarrant
//
//  Created by LHKH on 2018/6/7.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class FWBaseViewController;
@interface FWWindowManager : NSObject
/*
 *单例*
 */
+ (instancetype)sharedWindow;

/*
 *显示当前窗口*
 */
- (void)showKeyWindowRootVC:(UIWindow*)window;
- (void)showLoginView:(NSNotificationCenter*)notifi;
- (void)showTabbarView:(NSNotificationCenter*)notifi;

- (void)showTabbarViewAgain:(NSInteger)index;
- (void)showVC:(FWBaseViewController*)vc;

- (void)showWarrantDetailView:(NSString*)releasegoodsId flag:(NSString *)flag;
@end
