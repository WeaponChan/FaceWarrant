//
//  FWConfig.h
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef FWConfig_h
#define FWConfig_h

//API接口域名
//#define FWBaseUrl @"http://10.5.21.95:8081"
//#define FWBaseMethod @"fwms"

//#define FWBaseUrl @"http://10.5.63.249:1010"
//#define FWBaseMethod @"fwms-gateway"

//开发
//#define FWBaseUrl @"http://47.106.166.255:9080"
//#define FWBaseMethod @"fwms-gateway"

//测试
#define FWBaseUrl @"https://test.facewarrant.com.cn"
#define FWBaseMethod @"fwms-gateway"

//生产
//#define FWBaseUrl @"https://www.facewarrant.com.cn"
//#define FWBaseMethod @"fwms-gateway"


#define pageSize  @"20"

//弱引用/强引用
#define LhkhWeakSelf(type)  __weak typeof(type) weak##type = type
#define LhkhStrongSelf(type)  __strong typeof(type) strong##type = weak##type;

//字符拼接
#define StringConnect(a,b)  [NSString stringWithFormat:@"%@%@",a,b]

//域名拼接
#define APIURLStringConnect(a)  [NSString stringWithFormat:@"%@/%@%@",FWBaseUrl,FWBaseMethod,a]

//alert
#define LhkhAlertShow(messageText,cancelbuttonName,surebuttonName) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:(messageText) \
delegate:self cancelButtonTitle:(buttonName) otherButtonTitles:(surebuttonName)];\
[alert show];

//输出日志
#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr,"File:%s Line%d Log: %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...)
#endif

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#endif /* FWConfig_h */
