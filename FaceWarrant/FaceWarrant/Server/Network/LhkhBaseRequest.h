//
//  LhkhBaseRequest.h
//  LhkhBaseDemo
//
//  Created by Lhkh on 2017/4/24.
//  Copyright © 2017年 Lhkh. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LhkhBaseResponse;

@interface LhkhBaseRequest : NSObject


- (void)GET:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LhkhBaseResponse *response))completion;


- (void)POST:(NSString *)URLString parameters:(id)parameters completion:(void(^)(LhkhBaseResponse *response))completion;


@end
