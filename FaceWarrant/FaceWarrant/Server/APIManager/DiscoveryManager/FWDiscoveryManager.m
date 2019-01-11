//
//  FWDiscoveryManager.m
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWDiscoveryManager.h"

@implementation FWDiscoveryManager
+ (void)loadDiscoveryFaceWithParameters:(id)parameters result:(void(^)(NSArray *dataArr, NSString *type))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/find") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = nil;
                NSNumber *num = response.responseObject[@"result"][@"type"];
                NSString *type = num.stringValue;
                
                if ((type && [type isEqualToString:@"0"]) || (type && [type isEqualToString:@"-1"])) {
                    arr = [FWDiscoveryFaceModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"recommendFaceList"]];
                    
                }else{
                    arr = [FWDiscoveryModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"faceGoodsList"]];
                }
                result(arr,type);
            }else{
                [MBProgressHUD showTips:response.responseObject[@"resultDesc"]];
            }
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}
@end
