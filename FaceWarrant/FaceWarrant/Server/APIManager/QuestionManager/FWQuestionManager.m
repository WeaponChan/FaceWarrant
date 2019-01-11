//
//  FWQuestionManager.m
//  FaceWarrant
//
//  Created by FW on 2018/8/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWQuestionManager.h"

@implementation FWQuestionManager

+ (void)loadQuestionHotTagsWithParameters:(id)parameters result:(void(^)(NSArray *arr))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/QA/recommendTags") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = response.responseObject[@"result"];
                result(arr);
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)sendQuestionWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/QA/question") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}
@end
