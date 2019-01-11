//
//  FWMeManager.h
//  FaceWarrantDel
//
//  Created by FW on 2018/8/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWMeInfoModel.h"
#import "FWMeQuestionModel.h"
#import "FWMeAnswerModel.h"
#import "FWQAndADetailModel.h"
#import "FWFaceModel.h"
#import "FWIntegralModel.h"
#import "FWFaceValueCashItemModel.h"
#import "FWBankModel.h"
#import "FWFaceValueNoteModel.h"
#import "FWFaceValueCashDetailModel.h"
#import "FWFaceReleaseModel.h"
#import "FWMyCollectionModel.h"
#import "FWAttentionModel.h"
@interface FWMeManager : NSObject
/**
 获取我的主页数据
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadMeWithParameters:(id)parameters result:(void(^)(FWMeInfoModel *model))result;


/**
 签到

 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)qiandaoClickWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 我的关注
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadAttentionListWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 我的碑它
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadFaceGoodsListWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceReleaseModel *> *model))result;

/**
 心愿单
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadCollectionListWithParameters:(id)parameters result:(void(^)(NSArray <FWMyCollectionModel *> *model))result;


/**
 获取我的提问列表
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadMyQuestionListWithParameters:(id)parameters result:(void(^)(NSArray <FWMeQuestionModel*> *model))result;

/**
 获取我的回答列表
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadMyAnswerListWithParameters:(id)parameters result:(void(^)(NSArray <FWMeAnswerModel*> *model))result;


/**
 获取问答详情列表
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadQuestionAndAnswerDetailWithParameters:(id)parameters result:(void(^)(FWQAndADetailModel *model,NSString *resultCode))result;

/**
 回答别人给我的提问
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)replyQuestionWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 删除我的提问 或者我的回答

 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)deleteQuestionWithParameters:(id)parameters result:(void(^)(id response))result;
+ (void)deleteAnswerWithParameters:(id)parameters result:(void(^)(id response))result;


/**
 积分
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadIntegralListWithParameters:(id)parameters result:(void(^)(FWIntegralModel *model, NSArray <FWPointsDetailListModel *> *mModel))result;

/**
 积分兑换脸值
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)sendIntegralToFaceValueWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 脸值 收入
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void) loadFaceValueListWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceValueCashItemModel *> *model))result;

/**
 脸值体现获取账户信息
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadFaceValueAccountInfoWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 可提现脸值余额
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadFaceValueYueInfoWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 脸值提现
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)sureFaceValueCashWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 脸值提现详情
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadFaceValueCashDetailWithParameters:(id)parameters result:(void(^)(FWFaceValueCashDetailModel *model))result;

/**
 脸值提现记录
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadFaceValueCashNoteWithParameters:(id)parameters result:(void(^)(NSArray <FWFaceValueNoteModel*> *model))result;

/**
 获取银行列表
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadBankListWithParameters:(id)parameters result:(void(^)(NSArray <FWBankModel*> *model))result;


/**
 获取群成员
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)loadGroupsFaceListWithParameters:(id)parameters result:(void(^)(NSArray <FWAttentionModel *> *model))result;

+ (void)loadGroupsFaceDeleteListWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 删除群成员
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)deleteGroupFacesWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 删除群
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)deleteGroupsWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 修改群组名
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)editGroupsNameWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 增加群组
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)addGroupWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 更换个人主页背景图片
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)changeHeaderBgImgWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 关于我们
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)aboutUSWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 修改密码
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)modifyPwdWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 修改头像
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)modifyHeaderImgWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 更换手机号
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)changePhoneNumWithParameters:(id)parameters result:(void(^)(id response))result;

/**
 意见反馈
 
 @param parameters 传参
 @param result 处理好的结果模型数据
 */
+ (void)sendOpinionWithParameters:(id)parameters result:(void(^)(id response))result;

@end
