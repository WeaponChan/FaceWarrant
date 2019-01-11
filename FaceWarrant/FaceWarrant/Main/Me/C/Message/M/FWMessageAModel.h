//
//  FWMessageAModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWMessageAModel : NSObject
/*{
    headUrl : http://image.facewarrant.com.cn/android/head/file/20170510205558image.jpg,
    messageId : 20,
    answerContent : 华东大厦回答,
    fromUser : Sally,
    hasAttention : 1,
    isAttention : 1,
    questionContent : ewqrewqr,
    fromUserId : 1268,
    toUserId : 1263,
    questionId : 1,
    createTime : 2018-08-02 16:44:13.0,
    answerId : 2,
    status : 0
}*/
@property (copy, nonatomic)NSString *messageId;
@property (copy, nonatomic)NSString *fromUserId;
@property (copy, nonatomic)NSString *toUserId;
@property (copy, nonatomic)NSString *fromUser;
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *hasAttention;
@property (copy, nonatomic)NSString *isAttention;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *questionId;
@property (copy, nonatomic)NSString *questionContent;
@property (copy, nonatomic)NSString *answerType;
@property (copy, nonatomic)NSString *answerId;
@property (copy, nonatomic)NSString *answerContent;
@property (copy, nonatomic)NSString *type;
@property (copy, nonatomic)NSString *commentContent;
@property (copy, nonatomic)NSString *replyContent;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *releaseGoodsId;
@property (copy, nonatomic)NSString *releaseGoodsStatus;
@property (copy, nonatomic)NSString *releaseGoodsType;
@property (copy, nonatomic)NSString *releaseGoodsName;
@property (copy, nonatomic)NSString *modelUrl;
@property (copy, nonatomic)NSString *brandName;
@property (copy, nonatomic)NSString *answerContentTime;
@property (copy, nonatomic)NSString *answerStatus;
@property (copy, nonatomic)NSString *questionStatus;
@property (assign, nonatomic)BOOL isSpread;
@end
