//
//  FWLoginManager.m
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWLoginManager.h"

@implementation FWLoginManager
+ (void)loadCountryWithParameters:(id)parameters result:(void(^)(NSArray <FWCountryModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getCountries") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWCountryModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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


+ (void)loadCodeWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/smsCode") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadCheckCodeWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/base/smsCode") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadMyCountryProvincesWithParameters:(id)parameters result:(void(^)(NSArray <FWProvinceModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/provinces") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWProvinceModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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


+ (void)loadMyCountryCityWithParameters:(id)parameters result:(void(^)(NSArray <FWCityModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/cities") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWCityModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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


+ (void)loadOtherCountryCityWithParameters:(id)parameters result:(void(^)(NSArray <FWCityModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getCountriesCities") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWCityModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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

+ (void)registerWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/register") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loginWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/login") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loginOutWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/loginOut") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadAlipayUserInfoWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/getAlipayUserInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadWechatUserInfoWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/getWXUserInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
//            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)forgetPWDWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/forgetPwd") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadCountryInfoWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/base/getCountryByRegion") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadAliPayAuthInfoWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/users/getAlipayAuthInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

@end
