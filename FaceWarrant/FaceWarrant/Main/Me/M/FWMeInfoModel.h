//
//  FWMeInfoModel.h
//  FaceWarrantDel
//
//  Created by FW on 2018/8/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWMeInfoModel : NSObject

/*{
    headUrl : http://image.facewarrant.com.cn/HeadImage/31363276689520180416131157.jpg,
    fansCount : 135,
    balanceId : 93,
    memberClass : corporate_executives,
    balance : 6.2,
    releaseGoodsCount : 12,
    userId : 1263,
    collectionCount : 13,
    attentionCount : 366,
    accountId : 12444,
    remainderPoints : 0,
    favouriteCount : 3,
    messageCount : 2,
    name : Adam
}*/
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *fansCount;
@property (copy, nonatomic)NSString *balanceId;
@property (copy, nonatomic)NSString *memberClass;
@property (copy, nonatomic)NSString *balance;
@property (copy, nonatomic)NSString *releaseGoodsCount;
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *collectionCount;
@property (copy, nonatomic)NSString *attentionCount;
@property (copy, nonatomic)NSString *accountId;
@property (copy, nonatomic)NSString *remainderPoints;
@property (copy, nonatomic)NSString *favouriteCount;
@property (copy, nonatomic)NSString *messageCount;
@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *isSignOn;
@property (copy, nonatomic)NSString *backgroundPicture;
@property (copy, nonatomic)NSString *pointsRegister;
@property (copy, nonatomic)NSString *phoneNo;
@property (copy, nonatomic)NSString *defaultHeadUrl;
@end
