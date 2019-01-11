//
//  FWHomeManager.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/25.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWHomeManager.h"

@implementation FWHomeManager

+ (void)loadHomeFaceWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWFaceModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"faceLibraryInfoList"]];
                result(arr);
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
                result(@[]);
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
            result(@[]);
        }
    }];
}


+ (void)loadHomeClassifyWithParameters:(id)parameters result:(void (^)(NSArray <FWHomeClassifyModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/memberClass") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWHomeClassifyModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
                result(arr);
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
            
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
            result(@[]);
        }
    }];
}


+ (void)actionHomeAttentedFaceWithParameter:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/faceLibrary/attention") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadHomeShopWithParameters:(id)parameters result:(void (^)(NSArray <FWShopModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/store") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWShopModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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

+ (void)loadGoodsBrandWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/faceBrand") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadGoodsBrandDetailWithParameter:(id)parameters result:(void(^)(FWBrandDetailModel * model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/brandInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            FWBrandDetailModel *model = [FWBrandDetailModel mj_objectWithKeyValues:response.responseObject[@"result"]];
            result(model);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadGoodsBrandDetailListWithParameter:(id)parameters result:(void(^)(NSArray <FWFaceReleaseModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/brandReleaseGoods") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWFaceReleaseModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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

+ (void)pushPhoneAndNaviWithParameter:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/store/navigation") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


@end
