//
//  FWCommentManager.h
//  FaceWarrant
//
//  Created by FW on 2018/8/1.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FWCommentModel,FWReplyModel;
@interface FWCommentManager : NSObject


/**
 获取评论列表
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadCommentListWithParameters:(id)parameters result:(void(^)(FWCommentModel *model,NSString *resultCode))result;



/**
 回复评论

 @param parameters 传参
 */
+ (void)sendReplyMessageTextWithParameter:(id)parameters result:(void(^)(id response))result;


/**
 评论碑它
 
 @param parameters 传参
 */
+ (void)sendCommentMessageTextWithParameter:(id)parameters result:(void(^)(id response))result;


/**
 点赞评论
 
 @param parameters 传参
 */
+ (void)actionCommentLikedWithParameter:(id)parameters result:(void(^)(id response))result;


/**
 更多回复
 
 @param parameters 传参
 */
+ (void)loadMoreReplyListWithParameter:(id)parameters result:(void(^)(NSArray <FWReplyModel*> *model))result;

@end
