//
//  LhkhEmptyViewManager.m
//  LhkhEmptyView
//
//  Created by LHKH on 2018/2/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "LhkhEmptyViewManager.h"
#import "LhkhEmptyView.h"
static TipsType currentType;
static LhkhEmptyViewManager *instance = nil;
@implementation LhkhEmptyViewManager


+ (instancetype)sharedTipsManager
{
    return [[self alloc] init];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}

- (id)init
{
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super init];
        });
    }
    return instance;
}

- (void)showTipsViewType:(TipsType)type toView:(UIView *)view
{
    //回收上一次的tipView,如果有
    [self removeTipsViewFromView:view];
    
    LhkhEmptyView *tipsView = [[LhkhEmptyView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    tipsView.type = type;
    [view addSubview:tipsView];
    
    currentType = type;
    
    if (type == TipsType_NetWorkLost) {
        
        tipsView.tipsImage.image = Image(@"tip_NetWork");
        tipsView.tipsLabel.text = @"呀，没网了？";
        [tipsView.tipsButton setTitle:@"刷新试试~" forState:UIControlStateNormal];
        
    }else if (type == TipsType_HaveNoOrder) {
        
        tipsView.tipsImage.image = Image(@"tip_Order");
        tipsView.tipsLabel.text = @"您暂时没有相关订单哦~";
        
    }else if (type == TipsType_HaveNoSearchResult) {
        
        tipsView.tipsImage.image = Image(@"tip_Search");
        tipsView.tipsLabel.text = @"竟然没有你想要的结果？换个词试试？";
        
    }else if (type == TipsType_HaveNoMessage) {
        
        tipsView.tipsImage.image = Image(@"tip_Message");
        tipsView.tipsLabel.text = @"太低调了，一条消息都没有额~";
        
    }else if (type == TipsType_HaveNoFavourite) {
        
        tipsView.tipsImage.image = Image(@"tip_Xinyuan");
        tipsView.tipsLabel.text = @"心愿单里还没有物品额~";
        [tipsView.tipsButton setTitle:@"随便逛逛~" forState:UIControlStateNormal];
        
    }else if (type == TipsType_HaveNoComment) {
        
        tipsView.tipsImage.image = Image(@"tip_Comment");
        tipsView.tipsLabel.text = @"暂时还没有评论哦~";
        
    }else if (type == TipsType_HaveNoRecomment) {
        
        tipsView.tipsImage.image = Image(@"tip_Content");
        tipsView.tipsLabel.text = @"呀！空空如也~";
        
    }else if (type == TipsType_HaveNoShanglian) {
        
        tipsView.tipsImage.image = Image(@"tip_Shanglian");
        tipsView.tipsLabel.text = @"好凄凉，还没有人给你赏脸呢~";
        
    }else if (type == TipsType_HaveNoAttention) {
        
        tipsView.tipsImage.image = Image(@"tip_Attention");
        tipsView.tipsLabel.text = @"这么高冷，你还没有关注过别人呢~";
        
    }else if (type == TipsType_HaveNoFound) {
        
        tipsView.tipsImage.image = Image(@"tip_Page");
        tipsView.tipsLabel.text = @"啊！页面不存在了~可能已被删除,看看别的吧！";
        
    }else if (type == TipsType_HaveNoQuestion) {
        
        tipsView.tipsImage.image = Image(@"tip_Question");
        tipsView.tipsLabel.text = @"您还没有发布过问题哦~";
        [tipsView.tipsButton setTitle:@"去提问~" forState:UIControlStateNormal];
        
    }else if (type == TipsType_HaveNoAnswer) {
        
        tipsView.tipsImage.image = Image(@"tip_Answer");
        tipsView.tipsLabel.text = @"一字千金吖~您还没有回答过别人的问题哦~";
    }else if (type == TipsType_LocationOff) {
        
        tipsView.tipsImage.image = Image(@"无地图");
        tipsView.tipsLabel.text = @"你好像走丢了额~";
    }else if (type == TipsType_HaveNoAddress) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"无地址"];
        tipsView.tipsLabel.text = @"暂无常用地址额~";
    }else if (type == TipsType_HaveNoGoods) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"goodsblank"];
        tipsView.tipsLabel.text = @"暂无商品额~";
    }else if (type == TipsType_HaveNoTips) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"无标签"];
        tipsView.tipsLabel.text = @"暂无标签额~";
    }else if (type == TipsType_HaveNoCoupon) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"couponblank"];
        tipsView.tipsLabel.text = @"暂无优惠券额~";
    }else if (type == TipsType_HaveNoCats) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"无标签"];
        tipsView.tipsLabel.text = @"暂无类别额~";
    }else if (type == TipsType_HaveFreeze) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"dongjieblank"];
        tipsView.tipsLabel.text = @"暂无冻结金额~";
    }else if (type == TipsType_HaveNoHistory) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"orderblank"];
        tipsView.tipsLabel.text = @"暂无记录额~";
    }else if (type == TipsType_HaveNoJob) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"noJob"];
        tipsView.tipsLabel.text = @"暂无招聘信息~";
    }else if (type == TipsType_HaveNoEmployee) {
        
        tipsView.tipsImage.image = [UIImage imageNamed:@"noEmployee"];
        tipsView.tipsLabel.text = @"暂无店员~";
    }
}

- (void)showCustomTipsViewType:(NSDictionary*)dic toView:(UIView *)view
{
    //回收上一次的tipView,如果有
    [self removeTipsViewFromView:view];
    LhkhEmptyView *tipsView = [[LhkhEmptyView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view addSubview:tipsView];

}

-(void)removeTipsViewFromView:(UIView *)view
{
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[LhkhEmptyView class]]) {
            LhkhEmptyView *tipsView = (LhkhEmptyView *)sub;
            [tipsView removeFromSuperview];
            tipsView = nil;
        }
    }
}

@end
