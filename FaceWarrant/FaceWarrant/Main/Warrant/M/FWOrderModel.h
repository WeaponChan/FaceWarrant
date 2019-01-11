//
//  FWOrderModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWOrderModel : NSObject
//code : 200,
//message : 成功下单！,
//microMallCode : ,
//microMallOrderId : ,
//buyUrl : https://www.31philliplim.com/,
//orderId : FW037703918611861105201809130004
@property (copy, nonatomic)NSString *code;
@property (copy, nonatomic)NSString *message;
@property (copy, nonatomic)NSString *microMallCode;
@property (copy, nonatomic)NSString *microMallOrderId;
@property (copy, nonatomic)NSString *buyUrl;
@property (copy, nonatomic)NSString *orderId;
@end
