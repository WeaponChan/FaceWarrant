//
//  FWMeQuestionModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWMeQuestionModel : NSObject
//questionId : 10,
//questionContent : ***女朋友生气了,买个口红哄哄,据说香奈儿的不错,那个色号好,#包#也行,
//createTime : 08-10 18:34,
//answerCount : 0

@property (copy, nonatomic)NSString *questionId;
@property (copy, nonatomic)NSString *questionContent;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *answerCount;
@end
