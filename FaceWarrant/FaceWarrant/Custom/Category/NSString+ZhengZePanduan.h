//
//  NSString+ZhengZePanduan.h
//  LhkhBase
//
//  Created by LHKH on 2017/11/6.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZhengZePanduan)
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配身份证号
+ (BOOL)checkIDCard:(NSString *) idCard;
#pragma 正则匹配邮箱
+ (BOOL) checkEmail:(NSString *) email;
#pragma 正则匹配银行卡
+ (BOOL) checkBankCard:(NSString *) bankCard;
#pragma 正则匹配车牌号
+ (BOOL) checkCarNo:(NSString *) CarNo;
#pragma 正则匹配邮政编码
+ (BOOL) checkPostalcode :(NSString *) Postalcode;
#pragma 正则匹配网址
+ (BOOL) checkUrl :(NSString *) Url;
#pragma 正则匹配IP
+ (BOOL) checkIP :(NSString *) IP;
#pragma 正则匹配纯汉字
+ (BOOL) checkChinese :(NSString *) Chinese;
#pragma 正则匹配工商税号
+ (BOOL) checkTaxNo :(NSString *) TaxNo;
/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

/** 去掉html格式 */
- (NSString *)removeHtmlFormat;
@end
