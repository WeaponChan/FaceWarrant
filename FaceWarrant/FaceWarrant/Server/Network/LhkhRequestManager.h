//
//  LhkhRequestManager.h
//  LhkhBaseDemo
//
//  Created by Lhkh on 2017/4/24.
//  Copyright © 2017年 Lhkh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LhkhBaseResponse.h"
#import <AFNetworking.h>

typedef enum : NSInteger {
    LhkhRequestManagerStatusCodeCustomDemo = -10000,
} LhkhRequestManagerStatusCode;

typedef LhkhBaseResponse *(^ResponseFormat)(LhkhBaseResponse *response);


@interface LhkhRequestManager : AFHTTPSessionManager


+ (instancetype)sharedManager;

//本地数据模式
@property (assign, nonatomic) BOOL isLocal;

//预处理返回的数据
@property (copy, nonatomic) ResponseFormat responseFormat;

//当前的网络状态
@property (assign, nonatomic) AFNetworkReachabilityStatus currentNetworkStatus;



- (void)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LhkhBaseResponse *response))completion;

- (void)GET:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LhkhBaseResponse *response))completion;

/**
  data 对应的二进制数据
  name 服务端需要参数
 */
- (void)upload:(NSString *)urlString parameters:(id)parameters formDataBlock:(void(^)(id<AFMultipartFormData> formData))formDataBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(LhkhBaseResponse *response))completion;


@end
