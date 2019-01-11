//
//  FWLoginManager.h
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWCountryModel.h"
#import "FWProvinceModel.h"
#import "FWCityModel.h"
@interface FWLoginManager : NSObject
/**
 获取世界行政区 国际编码
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadCountryWithParameters:(id)parameters result:(void(^)(NSArray <FWCountryModel*> *model))result;

/**
 发送验证码
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadCodeWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 校验验证码
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadCheckCodeWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 获取大天国的省份
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadMyCountryProvincesWithParameters:(id)parameters result:(void(^)(NSArray <FWProvinceModel*> *model))result;

/**
 获取大天国的城市
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadMyCountryCityWithParameters:(id)parameters result:(void(^)(NSArray <FWCityModel*> *model))result;

/**
 获取国外的城市
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadOtherCountryCityWithParameters:(id)parameters result:(void(^)(NSArray <FWCityModel*> *model))result;

/**
 注册
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)registerWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 登录
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loginWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 退出登录
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loginOutWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 支付宝传入authcode 获取用户信息
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadAlipayUserInfoWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 微信传入code 获取用户信息
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadWechatUserInfoWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 忘记密码
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)forgetPWDWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 通过SIM卡的ISO获取国家信息
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadCountryInfoWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 获取支付宝签名信息
 
 @param parameters 传值字典
 @param result 处理好的模型数据
 */
+ (void)loadAliPayAuthInfoWithParameters:(id)parameters result:(void(^)(id response))result;
@end
