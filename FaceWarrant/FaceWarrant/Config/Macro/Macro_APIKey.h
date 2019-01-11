//
//  Macro_APIKey.h
//  LHKHBase
//
//  Created by LHKH on 2017/10/23.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#ifndef Macro_APIKey_h
#define Macro_APIKey_h


/*********************************************************************************/
/*               讯飞AppID            */
//*******************************************************************************
#define IFlyAPPID @"5b14afc4"

/*********************************************************************************/
/*               百度地图appkey             */
//*******************************************************************************
#define BMKMap_apiKey @"W4i5VeV1K0GS4gvvhK7K25AR4utqEG8s"

/*********************************************************************************/
/*               极光推送             */
/*********************************************************************************/
#define JPush_Appkey @"533f4b68472df6dc9c72a28d"
#define JPush_Secret @"f744de78ada638861146472d"

/*********************************************************************************/
/*               微信                 */
/*********************************************************************************/

#define WeChatAppID  @"wx28f0c9388121329e"
#define WeChatAppSecret  @"8e38fe9b8e0546ed411376c3e4424744"


/*********************************************************************************/
/*               支付宝          */
/*********************************************************************************/

#define AliPayAppID  @"2018082961165782"
#define AliPayPID @"2088621239071283"


/*********************************************************************************/
/*               新浪微博          */
/*********************************************************************************/

#define SinaWeiboAppKey  @"3530069199"
#define SinaWeiboAppSecret @"7d90b600cb45e3b5b19268af052b8dc3"

/*********************************************************************************/
/*               阿里云OSS  从后台取到的数据 偏好设置           */
/*********************************************************************************/

#define FW_IMAGE_SERVER_DOMAIN   [USER_DEFAULTS objectForKey:@"IMAGE_SERVER_DOMAIN"]
#define OSS_AccessKey  [USER_DEFAULTS objectForKey:@"OSS_accessKeyId"]
#define OSS_SecretKey [USER_DEFAULTS objectForKey:@"OSS_accessKeySecret"]
#define OSS_EndPoint  [USER_DEFAULTS objectForKey:@"OSS_endpoint"]
#define OSS_BucketName [USER_DEFAULTS objectForKey:@"OSS_BUCKET_NAME"]
#define OSS_interval_endpoint [USER_DEFAULTS objectForKey:@"OSS_interval_endpoint"]

/*********************************************************************************/
/*               服务端API秘钥             */
/*********************************************************************************/
#define kSecretKey @"FCEAJRSDOQHMYQJUETU3RMWE7GX5KVKUNR2G7KS9A0QXWGHRE9HAXYZP3WARNT"//生产环境
#endif /* Macro_APIKey_h */
