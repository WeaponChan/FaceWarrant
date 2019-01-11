//
//  FWOSSConfigManager.m
//  FaceWarrant
//
//  Created by FW on 2018/9/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWOSSConfigManager.h"

@implementation FWOSSConfigManager

+ (void)loadOSSBaseConfigInfo:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getOssProperties") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadOSSGetSTSToken:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getSTSToken") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadOSSGetVideoSTSToken:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getVideoSTSToken") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadOSSGetVideoPlayAuth:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getVideoPlayAuth") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)deleteOSSfile:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/deleteFileFromOSS") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

@end
