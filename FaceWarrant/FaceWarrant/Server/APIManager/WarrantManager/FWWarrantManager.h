//
//  FWWarrantManager.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/30.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWWarrantDetailModel.h"
#import "FWFaceReleaseModel.h"
#import "FWOrderModel.h"
@interface FWWarrantManager : NSObject



/**
 获取我的碑它列表
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadWarrantListWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceReleaseModel *> *model))result;


/**
 获取碑它详情

 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadWarrantDetailWithParameters:(id)parameters result:(void(^)(FWWarrantDetailModel *model,NSString *resultCode))result;


/**
 赏脸碑它
 
 @param parameters 传参
 */
+ (void)actionWarrantFavoritedWithParameter:(id)parameters result:(void(^)(id response))result;

/**
 收藏碑它
 
 @param parameters 传参
 */
+ (void)actionWarrantCollectedWithParameter:(id)parameters result:(void(^)(id response))result;


/**
 获取全部品牌
 
 @param result 处理好的模型数据
 */
+ (void)loadAllBrandListWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 获取品牌大类
 
 @param result 处理好的模型数据
 */
+ (void)loadBrandBigClassListWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 获取品牌小类
 
 @param result 处理好的模型数据
 */
+ (void)loadBrandSmallClassListWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 获取品牌商品
 
 @param result 处理好的模型数据
 */
+ (void)loadBrandGoodsListWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 碑它
 
 @param result 处理好的模型数据
 */
+ (void)warrantgoodsWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 取消碑它
 
 @param result 处理好的模型数据
 */
+ (void)deleteWarrantgoodsWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 购买
 
 @param result 处理好的模型数据
 */
+ (void)buywarrantgoodsWithParameters:(id)parameters result:(void(^)(FWOrderModel *model))result;

/**
 购买点击加次数
 
 @param result 处理好的模型数据
 */
+ (void)buywarrantgoodsUpdateClickNoWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 关注加群
 
 @param result 处理好的模型数据
 */
+ (void)attenFaceToGroupWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 获取碑它页面的基本信息

 @param parameters 传参
 @param result 结果
 */
+ (void)loadWarrantBaseInfoWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 监测是否显示购买按钮 （应付苹果审核的）

 @param parameters 传参
 @param result 结果
 */
+ (void)checkIsShowBuyWithParameters:(id)parameters result:(void(^)(id response))result;

@end
