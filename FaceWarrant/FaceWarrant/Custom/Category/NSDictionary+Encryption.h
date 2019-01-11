//
//  NSDictionary+Encryption.h
//  Lhkh
//
//  Created by Lhkh on 17-4-18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Encryption)


/**
 *  @brief  字典参数加密
 *
 *  @param  dictionary 字典
 *  @param  secret     秘钥
 *
 */
+ (NSDictionary *)encryption:(NSDictionary *)dictionary withSecret:(NSString *)secret;

@end
