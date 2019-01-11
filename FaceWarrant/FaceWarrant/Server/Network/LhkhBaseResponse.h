//
//  LhkhBaseResponse.h
//  LhkhBaseDemo
//
//  Created by Lhkh on 2017/4/24.
//  Copyright © 2017年 Lhkh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LhkhBaseResponse : NSObject


/** error  */
@property (nonatomic, strong) NSError *error;

/** error内容 */
@property (nonatomic, copy) NSString *errorMsg;

/** 请求接收到的状态码 */
@property (assign, nonatomic) NSInteger statusCode;

/** 请求头 */
@property (nonatomic, copy) NSMutableDictionary *headers;

/** 接收到的内容 */
@property (nonatomic, strong) id responseObject;

@end
