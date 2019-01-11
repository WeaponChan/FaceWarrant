//
//  FWWarrantDetailModel.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/30.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantDetailModel.h"

@implementation FWWarrantDetailModel

+ (NSDictionary *)objectCommendReplyResponseDtoListClassInDictionary{
    return @{@"commendReplyResponseDtoList":[CommendReplyModel class]};
}
@end


@implementation CommendReplyModel

+ (NSDictionary *)objectReplyResponseDtoListClassInDictionary{
    return @{@"replyResponseDtoList":[ReplyModel class]};
}

@end



@implementation ReplyModel


@end
