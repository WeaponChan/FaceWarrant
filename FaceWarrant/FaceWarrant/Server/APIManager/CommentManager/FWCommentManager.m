//
//  FWCommentManager.m
//  FaceWarrant
//
//  Created by FW on 2018/8/1.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentManager.h"
#import "FWCommentModel.h"
@implementation FWCommentManager

+ (void)loadCommentListWithParameters:(id)parameters result:(void(^)(FWCommentModel *model,NSString *resultCode))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/goods/comment") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            FWCommentModel *model = [FWCommentModel mj_objectWithKeyValues:response.responseObject[@"result"]];
            result(model,response.responseObject[@"resultCode"]);
        } else {
            DLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)sendReplyMessageTextWithParameter:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/goods/comment/reply") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            DLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)sendCommentMessageTextWithParameter:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/goods/comment") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            DLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)actionCommentLikedWithParameter:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/goods/commentReply") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            DLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadMoreReplyListWithParameter:(id)parameters result:(void(^)(NSArray <FWReplyModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/goods/comment/reply") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                if ([response.responseObject[@"result"] isKindOfClass:[NSDictionary class]]) {
                    NSArray *arr = [FWReplyModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"replyResponseDtoList"]];
                    result(arr);
                }else{
                    result(@[]);
                    [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
                }
            }else{
                result(@[]);
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
            
        } else {
            DLog(@"------>%@",response.errorMsg);
            result(@[]);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

@end
