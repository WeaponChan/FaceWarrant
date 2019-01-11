//
//  FWFaceLibraryManager.m
//  FaceWarrant
//
//  Created by FW on 2018/8/15.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibraryManager.h"

@implementation FWFaceLibraryManager
+ (void)loadFaceLibraryClassifyWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceLibraryClassifyModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/groups/myGroups") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWFaceLibraryClassifyModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"][@"groupsList"]];
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

+ (void)loadFaceLibraryListWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceLibraryModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/myFaceLibrary") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            if (response.responseObject[@"success"] && [response.responseObject[@"success"] isEqual:@1]) {
                NSArray *arr = [FWFaceLibraryModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"result"]];
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

+ (void)loadFaceHomeDataWithParameters:(id)parameters result:(void(^)(FWFaceHomeModel *model,NSString *resultCode,NSString *resultDesc))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/faceInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            FWFaceHomeModel *model = [FWFaceHomeModel mj_objectWithKeyValues:response.responseObject[@"result"]];
            result(model,response.responseObject[@"resultCode"],response.responseObject[@"resultDesc"]);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}


+ (void)loadFaceHomeReleasegoodsDataWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceReleaseModel*> *model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/faceReleaseGoods") parameters:parameters completion:^(LhkhBaseResponse *response) {
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


+ (void)loadFaceHomeOtherFaceWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/groups/facesNotInGroup") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)changeFaceIndexFaceWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/faceLibrary/changeGroupsIndex") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadAiteFaceAndGroupsWithParameters:(id)parameters result:(void(^)(FWAiteFaceModel* model))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/QA/showFacesAndGroups") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            FWAiteFaceModel *model = [FWAiteFaceModel mj_objectWithKeyValues:response.responseObject[@"result"]];
            result(model);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadSearchHashWithParameters:(id)parameters result:(void(^)(NSArray *arr))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/QA/searchTags") parameters:parameters completion:^(LhkhBaseResponse *response) {
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

+ (void)loadSearchFaceWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/faceLibrary/searchFaces") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)addFaceToGroupWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/groups/joinFace") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)inviteFaceToGroupWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] POST:APIURLStringConnect(@"/v1/users/sendInviteMsg") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

+ (void)loadFaceLibrarySearchDataWithParameters:(id)parameters result:(void(^)(id response))result
{
    [[LhkhRequestManager sharedManager] GET:APIURLStringConnect(@"/v1/faceLibrary/searchMyFaceLibraryInfo") parameters:parameters completion:^(LhkhBaseResponse *response) {
        if (!response.error && response.responseObject) {
            result(response.responseObject);
            
        } else {
            NSLog(@"------>%@",response.errorMsg);
            [MBProgressHUD showError:response.errorMsg];
        }
    }];
}

@end
