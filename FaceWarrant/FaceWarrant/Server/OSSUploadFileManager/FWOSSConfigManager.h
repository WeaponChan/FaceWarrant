//
//  FWOSSConfigManager.h
//  FaceWarrant
//
//  Created by FW on 2018/9/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWOSSConfigManager : NSObject

/**
 获取oss基本信息

 @param parameters 传参
 @param result 返回结果
 */
+ (void)loadOSSBaseConfigInfo:(id)parameters result:(void(^)(id response))result;

/**
 获取oss上传凭证信息
 
 @param parameters 传参
 @param result 返回结果
 */
+ (void)loadOSSGetSTSToken:(id)parameters result:(void(^)(id response))result;



/**
 获取oss上传短视频凭证信息
 
 @param parameters 传参
 @param result 返回结果
 */
+ (void)loadOSSGetVideoSTSToken:(id)parameters result:(void(^)(id response))result;

/**
 获取oss短视频播放凭证信息
 
 @param parameters 传参
 @param result 返回结果
 */
+ (void)loadOSSGetVideoPlayAuth:(id)parameters result:(void(^)(id response))result;


/**
 删除oss旧文件  针对头像 和 背景图片

 @param parameters 传参
 @param result 返回结果
 */
+ (void)deleteOSSfile:(id)parameters result:(void(^)(id response))result;
@end


