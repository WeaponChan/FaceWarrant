//
//  FWMeAnswerModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWMeAnswerModel : NSObject
@property (copy, nonatomic)NSString *answerId;
@property (copy, nonatomic)NSString *questionId;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *questionContent;
@property (copy, nonatomic)NSString *answerType;
@property (copy, nonatomic)NSString *answerContent;
@property (copy, nonatomic)NSString *answerTime;
@property (copy, nonatomic)NSString *answerContentTime;
@end
