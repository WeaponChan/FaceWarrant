//
//  FWFaceValueCashItemModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceValueCashItemModel : NSObject
//accountIncomeInfoList : [
//                         {
//                             status : 1,
//                             fromUserId : 1263,
//                             mobile : 15050316692,
//                             afterFee : 8.199999999999999,
//                             incomeFee : 2,
//                             trueName : Adam,
//                             createTime : 08-21 18:26,
//                             nickName :
//                         }
//dateYearMonth : 2018-08
@property (strong, nonatomic)NSArray *accountIncomeInfoList;
@property (copy, nonatomic)NSString *dateYearMonth;

@end

@interface FWAccountIncomeInfoListModel : NSObject

@property (copy, nonatomic)NSString *afterFee;
@property (copy, nonatomic)NSString *fromUserId;
@property (copy, nonatomic)NSString *incomeFee;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *nickName;
@property (copy, nonatomic)NSString *trueName;
@property (copy, nonatomic)NSString *mobile;
@property (copy, nonatomic)NSString *orderId;
@property (copy, nonatomic)NSString *brandName;
@property (copy, nonatomic)NSString *goodsName;
@property (copy, nonatomic)NSString *brandUrl;
@end
