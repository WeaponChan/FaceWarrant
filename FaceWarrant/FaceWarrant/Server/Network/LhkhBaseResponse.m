//
//  LhkhBaseResponse.m
//  LhkhBaseDemo
//
//  Created by Lhkh on 2017/4/24.
//  Copyright © 2017年 Lhkh. All rights reserved.
//

#import "LhkhBaseResponse.h"

@implementation LhkhBaseResponse


- (NSString *)description
{
    return [NSString stringWithFormat:@"\n状态吗: %zd,\n错误: %@,\n响应头: %@,\n响应体: %@", self.statusCode, self.error, self.headers, self.responseObject];
}

- (void)setError:(NSError *)error {
    _error = error;
    self.statusCode = error.code;
    self.errorMsg = error.localizedDescription;
}

@end
