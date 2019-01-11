//
//  FWFaceValueModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceValueModel : NSObject
//incomeType    int    类型：1推荐  2 订单 3积分
//incomeFee    string    收入金额
//createTime    string    时间
//orderId    string     订单号
//brandName    string    品牌名称
//goodsName    string    商品名称
//trueName    string    来源用户姓名

@property (copy, nonatomic)NSString *incomeType;
@property (copy, nonatomic)NSString *incomeFee;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *orderId;
@property (copy, nonatomic)NSString *brandName;
@property (copy, nonatomic)NSString *goodsName;
@property (copy, nonatomic)NSString *trueName;

@end
