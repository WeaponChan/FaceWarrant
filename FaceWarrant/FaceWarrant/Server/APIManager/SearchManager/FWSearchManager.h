//
//  FWSearchManager.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/23.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFaceModel.h"
#import "FWSearchHotModel.h"
#import "FWSearchHistoryModel.h"
#import "FWFacelibrarySearchModel.h"
#import "FWFacelibrarySearchFaceModel.h"
@interface FWSearchManager : NSObject

/**
 搜索

 @param parameters 传参字典  注意：searchType = N
 @param result 数据
 */
+ (void)loadSearchDataWithParameters:(id)parameters result:(void(^)(NSArray<FWFaceModel*> *model))result;


/**
 face库 搜索
 
 @param parameters 传参字典
 @param result 数据
 */
+ (void)loadFaceLibrarySearchDataWithParameters:(id)parameters result:(void(^)(FWFacelibrarySearchModel *model))result;


/**
 face库 搜索符合条件的face
 
 @param parameters 传参字典
 @param result 数据
 */
+ (void)loadFaceLibrarySearchDataConditionWithParameters:(id)parameters result:(void(^)(NSArray<FWFacelibrarySearchFaceModel*> *model))result;


/**
 获取搜索历史
 
 @param parameters 传参字典
 @param result 数据
 */
+ (void)loadSearchHistoryDataWithParameters:(id)parameters result:(void(^)(NSArray<FWSearchHotModel*> *hotModel,NSArray<FWSearchHistoryModel*> *historyModel))result;


/**
 清除搜索历史

 @param parameters 传参字典
 @param result result description
 */
+ (void)clearSearchHistoryDataWithParameters:(id)parameters result:(void(^)(id response))result;
@end
