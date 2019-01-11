//
//  AppDelegate.h
//  FaceWarrant
//
//  Created by LHKH on 2018/6/1.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WeiboAccessTokenDelegate <NSObject>
- (void)WeiboAccessTokenDelegateWithUid:(NSString *)uid accessToken:(NSString*)accessToken;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic)id<WeiboAccessTokenDelegate>wbDelegate;
@end

