//
//  NSDictionary+Encryption.m
//  Lhkh
//
//  Created by Lhkh on 17-4-18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "NSDictionary+Encryption.h"
#import "NSString+Extend.h"
#import "UIDevice+Machine.h"

@implementation NSDictionary (Encryption)

+ (NSDictionary *)encryption:(NSDictionary *)dictionary withSecret:(NSString *)secret
{
    NSMutableString *signString = [NSMutableString string]; // 待验签的字符串
    NSString *sign; // // 生成的签名
    NSMutableDictionary *resultDic;/// 最终的结果字典
    
    // 添加额外的设备UUID参数
    if (dictionary.allKeys.count > 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [dic setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"uuid"];
        dictionary = [NSDictionary dictionaryWithDictionary:dic];
    } else {
        dictionary = @{@"uuid":[[UIDevice currentDevice] uniqueDeviceIdentifier]};
    }
    
    // 如果有参数则对参数进行处理，生成待验签字符串，否则初始化字典
    if (dictionary && dictionary.allKeys.count > 0) {
        resultDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        // 取出所有key值后进行排序
        NSArray *keyArray = [dictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
        // 拼接所有非空参数
        for (NSString *key in keyArray) {
            NSString *value = [dictionary objectForKey:key];
            
            // 如果是Number类型需要判断处理
            if ([value isKindOfClass:[NSNumber class]]) {
                value = ((NSNumber *)value).stringValue;
            }
            
            if (key && value && ![key isEqualToString:@""] && ![value isEqualToString:@""]) {
                [signString appendFormat:@"%@=%@&", key, value];
            }
     
        }
    } else {
        resultDic = [NSMutableDictionary dictionary];
    }
    // 拼接密钥，生成签名，添加到参数中
    [signString appendFormat:@"secret=%@", secret];
    sign = signString.md5String.uppercaseString;
    [resultDic setObject:sign forKey:@"sign"];
    
    return resultDic;
}

@end
