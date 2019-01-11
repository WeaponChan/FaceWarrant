//
//  FWWarrantDetailModel.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/30.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWWarrantDetailModel : NSObject

/*    {
 collectCount : 0,
 isAttention : 0,
 favorites : 0,
 goodsCategoryId : 9303,
 goodsName : Apple Watch,
 commendReplyResponseDtoList : [
 {
 isLike : 0,
 commentId : 9,
 commentFromUserId : 1263,
 commentContent : 这是5289的第二条评论,
 commentFromUser : Adam,
 commentLikeCount : 0,
 commentTime : 2018-07-16 10:44:14,
 replyCount : 0
 },
 {
 isLike : 0,
 commentId : 1,
 replyId : 1,
 replyFromUser : Sophie,
 commentFromUserId : 1263,
 commentContent : 这是5289的第一条评论,
 commentFromUser : Adam,
 commentLikeCount : 0,
 replyContent : 这是回复1263的5298碑它商品哦1,
 replyToUser : Adam,
 commentTime : 2018-07-11 14:42:09,
 replyCount : 1,
 replyTime : 2018-07-11 16:24:37
 }
 ],
 modelUrl : http://image.facewarrant.com.cn/WarrantImage/11810000061720180403131808.jpg,
 goodsBtype : 居家,
 goodsStype : 手表,
 useDetail :         休闲的apple watch曾伴随拉尼娅王后去参加过义务活动。看来，这位约旦王后的手表选择其实比较随性一点，显得很有亲和力。,
 isCollect : 0,
 faceName : 亚辛·拉尼娅 Rania,
 faceId : 2165,
 brandName : Apple 苹果,
 hasBuy : 1,
 headUrl : http://image.facewarrant.com.cn/HeadImage/11816899309620180402162125.jpg,
 releaseGoodsId : 5289,
 favoriteCount : 0,
 releaseGoodsTime : 2018-04-03 13:18:08,
 isFavorite : 0,
 commentCount : 2,
 width : 338,
 height : 339,
 brandSynopsis :         苹果公司（Apple Inc. ）是美国的一家高科技公司。由史蒂夫·乔布斯、斯蒂夫·沃兹尼亚克和罗·韦恩(Ron Wayne)等人于1976年4月1日创立，并命名为美国苹果电脑公司（Apple Computer Inc. ），2007年1月9日更名为苹果公司，总部位于加利福尼亚州的库比蒂诺。
 
 苹果公司创立之初，主要开发和销售的个人电脑，截至2014年致力于设计、开发和销售消费电子、计算机软件、在线服务和个人计算机。苹果的Apple II于1970年代开启了个人电脑革命，其后的Macintosh接力于1980年代持续发展。
 
 该公司硬件产品主至2014年致力于设计、开发和销售消费电子、计算机软件、在线服务和个人计算机。苹果的Apple II于1970年代开启了个人电脑革命，其后的Macintosh接力于1980年代持续发展。
 
 该公司硬件产品主\350\246要是Mac电脑系列、iPod媒体播放器、iPhone智能手机和iPad平板电脑；在线服务包括iCloud、iTunes Store和App Store；消费软件包括OS X和iOS操作系统、iTunes多媒体浏览器、Safari网络浏览器，还有iLife和iWork创至2014年致力于设计、开发和销售消费电子、计算机软件、在线服务和个人计算机。苹果的Apple II于1970年代开启了个人电脑革命，其后的Macintosh接力于1980年代持续发展。
 
 该公司硬件产品主\350\246要是Mac电脑系列、iPod媒体播放器、iPhone智能手机和iPad平板电脑；在线服务包括iCloud、iTunes Store和App Store；消费软件包括OS X和iOS操作系统、iTunes多媒体浏览器、Safari网络浏览器，还有iLife和iWork创\346\204意和生产套件。苹果公司在高科技企业中以创新而闻名世界。,
 userId : 0
 }*/

@property (copy, nonatomic)NSString *collectCount;
@property (copy, nonatomic)NSString *isAttention;
@property (copy, nonatomic)NSString *favorites;
@property (copy, nonatomic)NSString *goodsCategoryId;
@property (copy, nonatomic)NSString *goodsName;
@property (copy, nonatomic)NSString *modelUrl;
@property (copy, nonatomic)NSString *modelType;
@property (copy, nonatomic)NSString *videoUrl;
@property (copy, nonatomic)NSString *width;
@property (copy, nonatomic)NSString *height;
@property (copy, nonatomic)NSString *goodsBtype;
@property (copy, nonatomic)NSString *goodsStype;
@property (copy, nonatomic)NSString *useDetail;
@property (copy, nonatomic)NSString *isCollect;
@property (copy, nonatomic)NSString *faceId;
@property (copy, nonatomic)NSString *brandName;
@property (copy, nonatomic)NSString *hasBuy;
@property (copy, nonatomic)NSString *releaseGoodsId;
@property (copy, nonatomic)NSString *favoriteCount;
@property (copy, nonatomic)NSString *isFavorite;
@property (copy, nonatomic)NSString *faceName;
@property (copy, nonatomic)NSString *releaseGoodsTime;
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *commentCount;
@property (copy, nonatomic)NSString *brandSynopsis;
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *brandId;
@property (assign, nonatomic)BOOL isExpand;
@property (strong, nonatomic)NSArray *commendReplyResponseDtoList;

@end


/*
isLike : 0,
commentId : 1,
replyId : 1,
replyFromUser : Sophie,
commentFromUserId : 1263,
commentContent : 这是5289的第一条评论,
commentFromUser : Adam,
commentLikeCount : 0,
replyContent : 这是回复1263的5298碑它商品哦1,
replyToUser : Adam,
commentTime : 2018-07-11 14:42:09,
replyCount : 1,
replyTime : 2018-07-11 16:24:37*/
@interface CommendReplyModel :NSObject

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
@property (assign, nonatomic)CGFloat commentViewH; //评论下面的高度
@property (assign, nonatomic)CGFloat TopImageViewH; //评论上面的三角高度
@end


/*
replyTime : 07-11,
replyFromUser : Sophie,
replyFromUserId : 1266,
replyContent : 这是回复1263的5298碑它商品哦1,
replyToUser : Adam,
commentId : 1,
replyId : 1,
replyToUserId : 1263*/
@interface ReplyModel :NSObject

@property (copy, nonatomic)NSString *replyTime;
@property (copy, nonatomic)NSString *replyFromUser;
@property (copy, nonatomic)NSString *replyFromUserId;
@property (copy, nonatomic)NSString *replyContent;
@property (copy, nonatomic)NSString *replyToUser;
@property (copy, nonatomic)NSString *commentId;
@property (copy, nonatomic)NSString *replyId;
@property (copy, nonatomic)NSString *replyToUserId;
@property (copy, nonatomic)NSString *replyType;
@end
