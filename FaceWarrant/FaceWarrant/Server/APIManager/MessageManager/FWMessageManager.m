//
//  FWMessageManager.m
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMessageManager.h"

@implementation FWMessageManager
+ (void)loadMessageWithParameters:(id)parameters result:(void(^)(FWMessageModel *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/messages") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            FWMessageModel *model = [FWMessageModel mj_objectWithKeyValues:response.responseObject[@"result"]];
            result(model);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadMessageListWithParameters:(id)parameters result:(void(^)(NSArray <FWMessageAModel*> *model ,NSString *count))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/messages/msgRecord") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWMessageAModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"messagesResponseDtoList"]];
                NSString *c = (NSString*)response.responseObject[@"result"][@"messagesCount"];
                result(arr,c);
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)editMessageWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/messages/delReadMsg") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)readedMessageWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/messages/delReadMsg") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)allReadAndDeleteMessageWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/messages/delReadAllMsg") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

@end
