//
//  FWQuestionManager.h
//  FaceWarrant
//
//  Created by FW on 2018/8/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWQuestionManager : NSObject
/**
 获取提问页面的热门标签
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadQuestionHotTagsWithParameters:(id)parameters result:(void(^)(NSArray *arr))result;


/**
 提问
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)sendQuestionWithParameters:(id)parameters result:(void(^)(id response))result;
@end
