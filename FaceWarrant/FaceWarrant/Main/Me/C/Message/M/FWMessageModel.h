//
//  FWMessageModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWMessageModel : NSObject
//questionToMeCount                int    对我提问  新消息数量   结果是0则表示无
//answerToMeCount            modelUrl    int    回答我的  新消息数量    结果是0 则表示无
//favoriteNewCount                int    赏脸   新消息数量   结果是0则表示无
//likeNewCount            modelUrl    int    点赞   新消息数量    结果是0 则表示无（包含点赞评论和回复）
//collectionCount                int    收藏 新消息数量   结果是0则表示无
//attentionNewCount            brand    int    关注   新消息数量    结果是0则表示无
//commendNewCount            buyNo     int    评论和回复   新消息数量  结果是0则表示无

@property (copy, nonatomic)NSString *questionToMeCount;
@property (copy, nonatomic)NSString *answerToMeCount;
@property (copy, nonatomic)NSString *favoriteNewCount;
@property (copy, nonatomic)NSString *likeNewCount;
@property (copy, nonatomic)NSString *collectionCount;
@property (copy, nonatomic)NSString *attentionNewCount;
@property (copy, nonatomic)NSString *commendNewCount;

@end
