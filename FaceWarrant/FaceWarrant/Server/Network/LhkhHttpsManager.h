//
//  LhkhHttpsManager.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/21.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    HttpRequestTypeGet = 1,
    HttpRequestTypePost = 2
};
@interface LhkhHttpsManager : NSObject
/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param success     请求的结果
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

+(NSString *)getNowTimeTimestamp;
+(NSString *)md5:(NSString *)str;
@end
