//
//  FWOSSResponse.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWOSSResponse : NSObject
@property (nonatomic, copy) NSString *APK_SERVER_DOMAIN;
@property (nonatomic, copy) NSString *IMAGE_SERVER_DOMAIN;
@property (nonatomic, copy) NSString *OSS_BUCKET_NAME;
@property (nonatomic, copy) NSString *OSS_accessKeyId;
@property (nonatomic, copy) NSString *OSS_accessKeySecret;
@property (nonatomic, copy) NSString *OSS_endpoint;
@property (nonatomic, copy) NSString *OSS_FW_interval_endpoint;
@end
