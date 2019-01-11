//
//  FWHomeManager.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/25.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFaceModel.h"
#import "FWHomeClassifyModel.h"
#import "FWShopModel.h"
#import "FWBrandDetailModel.h"
#import "FWFaceReleaseModel.h"
@interface FWHomeManager : NSObject


/**
 首页Face获取

 @param parameters 传值字典 注意： 此处根据searchType 区分   N:最新  H:热门 
 @param result 处理好的数据模型
 */
+ (void)loadHomeFaceWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceModel*> *model))result;

/**
 首页获取分类下面的tab

 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadHomeClassifyWithParameters:(id)parameters result:(void(^)(NSArray <FWHomeClassifyModel*> *model))result;



/**
 关注face
 
 @param parameters 传参
 */
+ (void)actionHomeAttentedFaceWithParameter:(id)parameters result:(void(^)(id response))result;


/**
 首页获取附近shop
 
 @param result 处理好的模型数据
 */
+ (void)loadHomeShopWithParameters:(id)parameters result:(void(^)(NSArray <FWShopModel*> *model))result;


/**
 获取某个face碑它过的品牌
 
 @param result 处理好的模型数据
 */
+ (void)loadGoodsBrandWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 获取品牌详情
 
 @param parameters 传参
 */
+ (void)loadGoodsBrandDetailWithParameter:(id)parameters result:(void(^)(FWBrandDetailModel * model))result;

/**
 获取品牌详情下面的碑它
 
 @param parameters 传参
 */
+ (void)loadGoodsBrandDetailListWithParameter:(id)parameters result:(void(^)(NSArray <FWFaceReleaseModel*> *model))result;

/**
 电话咨询、导航
 
 @param parameters 传参
 */
+ (void)pushPhoneAndNaviWithParameter:(id)parameters result:(void(^)(id response))result;
@end
