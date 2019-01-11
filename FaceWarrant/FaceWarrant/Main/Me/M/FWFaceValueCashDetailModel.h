//
//  FWFaceValueCashDetailModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/23.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceValueCashDetailModel : NSObject
//withdrawFee : 188,
//beforeFee : 1583.2,
//status : 2,
//bankUrl : http://image.facewarrant.com.cn/web/bank/CEB.png,
//withdrawalsTime : 2018-08-23 16:39:43,
//realName : 陈,
//afterFee : 1395.2,
//balanceId : 93,
//bankId : 3007,
//bankName : 光大银行,
//bankAccountNumber : 65258665266826636565,
//expendType : 0,
//accountId : 12444,
//userId : 1263

@property (copy, nonatomic)NSString *withdrawFee;
@property (copy, nonatomic)NSString *beforeFee;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *bankUrl;
@property (copy, nonatomic)NSString *withdrawalsTime;
@property (copy, nonatomic)NSString *realName;
@property (copy, nonatomic)NSString *afterFee;
@property (copy, nonatomic)NSString *balanceId;
@property (copy, nonatomic)NSString *bankId;
@property (copy, nonatomic)NSString *bankName;
@property (copy, nonatomic)NSString *bankAccountNumber;
@property (copy, nonatomic)NSString *expendType;
@property (copy, nonatomic)NSString *accountId;
@property (copy, nonatomic)NSString *userId;
@end
