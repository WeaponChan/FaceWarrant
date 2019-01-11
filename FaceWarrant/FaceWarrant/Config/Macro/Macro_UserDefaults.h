//
//  Macro_UserDefaults.h
//  LHKHBase
//
//  Created by LHKH on 2017/11/17.
//  Copyright © 2017 LHKH. All rights reserved.
//

#ifndef Macro_UserDefaults_h
#define Macro_UserDefaults_h

/*********************************************************************************/
/*               NSUserDefaults键名                */
/*********************************************************************************/
#define UD_GPS_Openen              @"UD_GPS_Openen"                 //GPS 定位是否开启
#define UD_LocatedCity             @"UD_LocatedCity"                //GPS 定位城市
#define UD_CurrentLoginAccount     @"UD_CurrentLoginAccount"        //当前登录账号的token
#define UD_VisitorID               @"UD_VisitorID"                  //当前游客ID
#define UD_FirstLogin              @"UD_FirstLogin"                 //首次登陆
#define UD_VisitorCityName         @"UD_VisitorCityName"            //当前选择的城市名字
#define UD_VisitorCityId           @"UD_VisitorCityId"              //当前选择的城市ID
#define UD_RememberPWD             @"UD_RememberPWD"                //记住密码
#define UD_UserID                  @"UD_UserID"                     //用户id
#define UD_UserShopID              @"UD_UserShopID"                 //用户店铺id
#define UD_UserPhone               @"UD_UserPhone"                  //用户手机号
#define UD_UserPwd                 @"UD_UserPwd"                    //记住密码
#define UD_UserHeadImg             @"UD_UserHeadImg"                //用户头像
#define UD_AppDidUpdate            @"UD_AppDidUpdate"               //app是否更新
#define UD_UserType                @"UD_UserType"                   //用户类别
#define UD_DeviceToken             @"UD_DeviceToken"                //用户友盟deviceToken
#define UD_ZFBID                   @"UD_ZFBID"                      //用户支付宝ID
#define UD_ZFBName                 @"UD_ZFBName"                    //用户支付宝姓名

#define JPushRegistrationID        @"JPushRegistrationID"           //极光推送获取到的RegistrationID
#define UD_ISO                     @"UD_ISO"                        //手机SIM卡的国家编码
#define UD_Code                    @"UD_Code"                       //手机SIM卡的国家编码
#define UD_LoginType               @"UD_LoginType"                  //登录类型
#define UD_SortType                @"UD_SortType"                   //个人主页搜索状态
#define UD_CountryName             @"UD_CountryName"                //根据SIM卡的ISO获取到的国家名称
#define UD_CountryCode             @"UD_CountryCode"                //根据SIM卡的ISO获取到的国家国际编码
#define UD_CountryID               @"UD_CountryID"                  //根据SIM卡的ISO获取到的国家ID
#define UD_OSSTOKEN                @"UD_OSSTOKEN"                   //获取到OSS的token
#define UD_VideoTimeLimit          @"UD_VideoTimeLimit"             //短视频时长
#define UD_RecordingTimeLimit      @"UD_RecordingTimeLimit"         //录音时长
#define UD_VoiceTimeLimit          @"UD_VoiceTimeLimit"             //语音时长
#define UD_IdInfo                  @"UD_IdInfo"                     //身份
#define UD_UserFaceValue           @"UD_UserFaceValue"              //用户的脸值
#define UD_IsShowBuy               @"UD_IsShowBuy"                  //根据此判断是否显示购买  和脸值
#define UD_FaceLibraryChange       @"UD_FaceLibraryChange"          //face库出现了修改
#define UD_AppVersionCancel        @"UD_AppVersionCancel"           //当提醒了版本更新过后 用来标记取消的

//用户偏好相关
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#endif /* Macro_UserDefaults_h */
