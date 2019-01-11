//
//  FWQAndADetailModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWQAndADetailModel : NSObject
//questionId : 10,
//headUrl : http://image.facewarrant.com.cn/HeadImage/31363276689520180416131157.jpg,
//questionContent : ***女朋友生气了,买个口红哄哄,据说香奈儿的不错,那个色号好,#包#也行,
//createTime : 08-10 18:34,
//answerCount : 3,
//answerInfoList : [
//                  {
//                      headUrl : http://image.facewarrant.com.cn/android/head/file/20170510205558image.jpg,
//                      answerTime : 今天 14:02,
//                      answerUserId : 1268,
//                      answerType : 0,
//                      answerId : 5,
//                      questionId : 10,
//                      questionContent : ***女朋友生气了,买个口红哄哄,据说香奈儿的不错,那个色号好,#包#也行,
//                      answerContent : 忽视的功夫爱上我,
//                      createTime : 2018-08-10 18:34:15
//                  }

@property (copy, nonatomic)NSString *questionId;
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *questionContent;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *answerCount;
@property (strong, nonatomic)NSArray *answerInfoList;
@property (copy, nonatomic)NSString *questionUser;
@property (copy, nonatomic)NSString *questionUserId;

@end

@interface AnswerInfoListModel : NSObject

@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *answerTime;
@property (copy, nonatomic)NSString *answerUserId;
@property (copy, nonatomic)NSString *answerType;
@property (copy, nonatomic)NSString *answerId;
@property (strong, nonatomic)NSArray *questionId;
@property (copy, nonatomic)NSString *questionContent;
@property (copy, nonatomic)NSString *answerContent;
@property (strong, nonatomic)NSArray *createTime;
@property (copy, nonatomic)NSString *answerUser;
@property (strong, nonatomic)NSArray *releaseGoodsDtoList;
@property (copy, nonatomic)NSString *answerContentTime;
@end

@interface ReleaseGoodsDtoListModel : NSObject

@property (copy, nonatomic)NSString *modelUrl;
@property (copy, nonatomic)NSString *releaseGoodsId;
@property (copy, nonatomic)NSString *modelType;

@end
