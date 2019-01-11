//
//  FWFaceLibraryManager.h
//  FaceWarrant
//
//  Created by FW on 2018/8/15.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFaceLibraryClassifyModel.h"
#import "FWFaceLibraryModel.h"
#import "FWFaceHomeModel.h"
#import "FWFaceReleaseModel.h"
#import "FWAiteFaceModel.h"
@interface FWFaceLibraryManager : NSObject

/**
 face库获取分类下面的tab
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadFaceLibraryClassifyWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceLibraryClassifyModel*> *model))result;



/**
 face库
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadFaceLibraryListWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceLibraryModel*> *model))result;


/**
 获取face个人主页

 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadFaceHomeDataWithParameters:(id)parameters result:(void(^)(FWFaceHomeModel *model,NSString *resultCode,NSString *resultDesc))result;

/**
 获取face个人主页 下面的碑它
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadFaceHomeReleasegoodsDataWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceReleaseModel*> *model))result;

/**
 获取添加face
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadFaceHomeOtherFaceWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 改变face的位置
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)changeFaceIndexFaceWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 获取@的人和群
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadAiteFaceAndGroupsWithParameters:(id)parameters result:(void(^)(FWAiteFaceModel* model))result;

/**
 获取搜索到的hash
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadSearchHashWithParameters:(id)parameters result:(void(^)(NSArray *arr))result;

/**
 获取搜索到的face
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadSearchFaceWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 拉人
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)addFaceToGroupWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 通讯录邀请
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)inviteFaceToGroupWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 face库 按条件搜索全部品牌
 
 @param parameters 传参字典
 @param result 数据
 */
+ (void)loadFaceLibrarySearchDataWithParameters:(id)parameters result:(void(^)(id response))result;

@end
