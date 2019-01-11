//
//  FWSearchManager.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/23.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSearchManager.h"

@implementation FWSearchManager
+ (void)loadSearchDataWithParameters:(id)parameters result:(void(^)(NSArray<FWFaceModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                if (![response.responseObject[@"result"] isKindOfClass:[NSArray class]] && response.responseObject[@"result"][@"faceLibraryInfoList"]) {
                    NSArray *arr = [FWFaceModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"faceLibraryInfoList"]];
                    result(arr);
                }else{
                    NSArray *arr = [FWFaceModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
                    result(arr);
                }
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
            
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadFaceLibrarySearchDataWithParameters:(id)parameters result:(void(^)(FWFacelibrarySearchModel *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/searchMyFaceLibraryInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            FWFacelibrarySearchModel *model = [FWFacelibrarySearchModel mj_objectWithKeyValues:response.responseObject[@"result"]];
            result(model);
            
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadFaceLibrarySearchDataConditionWithParameters:(id)parameters result:(void(^)(NSArray<FWFacelibrarySearchFaceModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/searchMyFaceLibrary") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWFacelibrarySearchFaceModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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



+ (void)loadSearchHistoryDataWithParameters:(id)parameters result:(void(^)(NSArray<FWSearchHotModel*> *hotModel,NSArray<FWSearchHistoryModel*> *historyModel))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/search") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *hotArr = [FWSearchHotModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"hotSearchList"]];
                NSArray *historyArr = [FWSearchHistoryModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"historySearchList"]];
                result(hotArr,historyArr);
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)clearSearchHistoryDataWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/search/clear") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}
@end
