//
//  FWCommentModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/1.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWCommentModel : NSObject

@property (copy, nonatomic)NSString *favorites;
@property (copy, nonatomic)NSString *goodsCategoryId;
@property (strong, nonatomic)NSArray *commendReplyResponseDtoList;
@property (copy, nonatomic)NSString *hasBuy;
@property (copy, nonatomic)NSString *releaseGoodsId;
@property (copy, nonatomic)NSString *commentCount;
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *headUrl;

@end


@interface FWCommendReplyModel : NSObject

@property (copy, nonatomic)NSString *isLike;
@property (copy, nonatomic)NSString *commentId;
@property (copy, nonatomic)NSString *replyId;
@property (copy, nonatomic)NSString *commentFromUserId;
@property (copy, nonatomic)NSString *commentContent;
@property (copy, nonatomic)NSString *commentFromUser;
@property (copy, nonatomic)NSString *commentFromUserHeadUrl;
@property (copy, nonatomic)NSString *commentLikeCount;
@property (copy, nonatomic)NSString *replyContent;
@property (copy, nonatomic)NSString *releaseGoodsTime;
@property (copy, nonatomic)NSString *replyToUser;
@property (copy, nonatomic)NSString *commentTime;
@property (copy, nonatomic)NSString *replyCount;
@property (copy, nonatomic)NSString *replyTime;
@property (strong, nonatomic)NSArray *replyResponseDtoList;
@property (assign, nonatomic)BOOL isSpread;

@end

@interface FWReplyModel :NSObject

@property (copy, nonatomic)NSString *isLike;
@property (copy, nonatomic)NSString *replyTime;
@property (copy, nonatomic)NSString *replyFromUser;
@property (copy, nonatomic)NSString *replyFromUserId;
@property (copy, nonatomic)NSString *replyFromUserHeadUrl;
@property (copy, nonatomic)NSString *replyContent;
@property (copy, nonatomic)NSString *replyToUser;
@property (copy, nonatomic)NSString *commentId;
@property (copy, nonatomic)NSString *replyId;
@property (copy, nonatomic)NSString *replyToUserId;
@property (copy, nonatomic)NSString *replyCount;
@property (copy, nonatomic)NSString *replyLikeCount;
@property (copy, nonatomic)NSString *replyType;
@end
