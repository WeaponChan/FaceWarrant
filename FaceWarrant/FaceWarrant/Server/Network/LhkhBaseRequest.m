//
//  LhkhBaseRequest.m
//  LhkhBaseDemo
//
//  Created by Lhkh on 2017/4/24.
//  Copyright © 2017年 Lhkh. All rights reserved.
//

#import "LhkhBaseRequest.h"
#import "LhkhRequestManager.h"
@implementation LhkhBaseRequest


- (void)GET:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LhkhBaseResponse *response))completion
{
    
    __weak typeof(self) weakself = self;
    [[LhkhRequestManager sharedManager] GET:URLString parameters:parameters completion:^(LhkhBaseResponse *response) {
        
        if (!weakself) {
            return ;
        }
        !completion ?: completion(response);
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LhkhBaseResponse *response))completion
{
    __weak typeof(self) weakself = self;
    [[LhkhRequestManager sharedManager] POST:URLString parameters:parameters completion:^(LhkhBaseResponse *response) {
        
        if (!weakself) {
            return ;
        }
        !completion ?: completion(response);
    }];
}



@end
