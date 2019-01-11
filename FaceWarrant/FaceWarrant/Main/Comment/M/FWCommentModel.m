//
//  FWCommentModel.m
//  FaceWarrant
//
//  Created by FW on 2018/8/1.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentModel.h"

@implementation FWCommentModel

+ (NSDictionary *)objectCommendReplyResponseDtoListClassInDictionary{
    return @{@"commendReplyResponseDtoList":[FWCommendReplyModel class]};
}
@end


@implementation FWCommendReplyModel

+ (NSDictionary *)objectReplyResponseDtoListClassInDictionary{
    return @{@"replyResponseDtoList":[FWReplyModel class]};
}

@end


@implementation FWReplyModel


@end
