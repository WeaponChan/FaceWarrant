//
//  FWMessageManager.h
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWMessageModel.h"
#import "FWMessageAModel.h"
@interface FWMessageManager : NSObject
/**
 获取我的消息badge数据
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadMessageWithParameters:(id)parameters result:(void(^)(FWMessageModel *model))result;


/**
 获取我的消息list数据
 
 Q:提问
 A:回答
 F:赏脸
 LC:点赞
 CO:收藏
 C:评论/回复
 AT:关注
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadMessageListWithParameters:(id)parameters result:(void(^)(NSArray <FWMessageAModel*> *model,NSString *count))result;


/**
 标记已读或者删除

 @param parameters 传参
 @param result 处理好的模型
 */
+ (void)editMessageWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 已读
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)readedMessageWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 全部已读、删除
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)allReadAndDeleteMessageWithParameters:(id)parameters result:(void(^)(id response))result;



@end
