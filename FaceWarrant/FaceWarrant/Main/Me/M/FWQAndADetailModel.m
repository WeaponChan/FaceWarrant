//
//  FWQAndADetailModel.m
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWQAndADetailModel.h"

@implementation FWQAndADetailModel

+ (NSDictionary*)objectAnswerInfoListClassInDictionary
{
    return @{@"answerInfoList":[AnswerInfoListModel class]};
}

@end


@implementation AnswerInfoListModel
+ (NSDictionary*)objectReleaseGoodsDtoListClassInDictionary
{
    return @{@"releaseGoodsDtoList":[ReleaseGoodsDtoListModel class]};
}

@end

@implementation ReleaseGoodsDtoListModel


@end
