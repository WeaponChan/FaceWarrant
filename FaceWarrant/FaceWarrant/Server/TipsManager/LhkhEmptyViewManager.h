//
//  LhkhEmptyViewManager.h
//  LhkhEmptyView
//
//  Created by LHKH on 2018/2/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 *TipsType状态*
 */
typedef NS_ENUM(NSUInteger, TipsType){
    TipsType_NetWorkLost = 0,       //无网络链接
    TipsType_HaveNoOrder,           //无订单信息
    TipsType_HaveNoHistory,         //无记录
    TipsType_LocationOff,           //未开启定位
    TipsType_HaveNoSearchResult,    //无搜索结果
    TipsType_HaveNoMessage,         //无系统消息
    TipsType_HaveNoFavourite,       //无个人收藏
    TipsType_HaveNoAddress,         //无地址信息
    TipsType_HaveNoComment,         //无评论
    TipsType_HaveNoGoods,           //无商品
    TipsType_HaveNoTips,            //无标签
    TipsType_HaveNoCoupon,          //无优惠券
    TipsType_HaveNoCats,            //无类别
    TipsType_HaveNoJob,             //无招聘信息
    TipsType_HaveNoEmployee,        //无店员
    TipsType_HaveFreeze,            //冻结
    TipsType_HaveNoRecomment,       //无推荐
    TipsType_HaveNoShanglian,       //无赏脸
    TipsType_HaveNoAttention,       //无关注
    TipsType_HaveNoFound,           //找不到页面
    TipsType_HaveNoQuestion,        //无提问
    TipsType_HaveNoAnswer,          //无回答
};
@interface LhkhEmptyViewManager : NSObject

/*
 *单例*
 */
+ (instancetype)sharedTipsManager;

/*
 *展示到当前view*
 */
- (void)showTipsViewType:(TipsType)type toView:(UIView *)view;

/*
 *展示自定义的tips到当前view*
 */
- (void)showCustomTipsViewType:(NSDictionary*)dic toView:(UIView *)view;

/*
 *从当前view移除*
 */
- (void)removeTipsViewFromView:(UIView *)view;
@end
