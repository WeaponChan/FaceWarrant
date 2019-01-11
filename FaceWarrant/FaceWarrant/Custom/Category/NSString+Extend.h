//
//  NSString+Extend.h
//  Lhkh
//
//  Created by Lhkh on 17-4-18.
//  Copyright © 2017年 LHKH. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extend)

#pragma mark - Filter String

/**
 *  @brief  过滤字符串
 *
 *  @param  string 过滤条件字符串
 *
 *  @return Yes/No 如果只包含过滤条件中的字符串则返回Yes, 否则返回No
 */
- (BOOL)filterString:(NSString *)string;

/**
 *  @brief  过滤小数和数字
 *
 *
 *  @return Yes/No 如果只包含数字和小数点则返回Yes, 否则返回No
 */
- (BOOL)filterDecimalNumber;

/**
 *  @brief  过滤数字
 *
 *
 *  @return Yes/No 如果只包含数字则返回Yes, 否则返回No
 */
- (BOOL)filterIntegerNumber;

/**
 *  @brief  过滤Emoji表情
 *
 *
 *  @return Yes/No 如果包含Emoji表情则返回Yes, 否则返回No
 */
- (BOOL)filterEmoji;

/**
 *  @brief  过滤Email字符串
 *
 *
 *  @return Yes/No 如果是email格式则返回Yes, 否则返回No
 */
- (BOOL)filterEmail;

#pragma mark - String Format

/**
 *  @brief  格式化小数，将double类型的数字转成保留小数位的字符串
 *
 *  @param number double类型的数字
 *
 *  @return string 保留小数位的字符串
 */
+ (NSString *)numberString:(double)number;

/**
 *  Number转为格式化的金额字符串 000,000.00
 *
 *  @param number NSNumber
 *
 *  @return string
 */
+ (NSString *)stringFromNumber:(NSNumber *)number;

#pragma mark - String size

/**
 *  通过字体计算字符串所占大小
 *
 *  @param font  字体 UIFont
 *
 *  @return CGSize
 */
- (CGSize)sizeFromFont:(UIFont *)font;

/**
 *  通过字体计算字符串所占大小
 *
 *  @param font  字体 UIFont
 *  @param width 宽度
 *
 *  @return CGSize
 */
- (CGSize)sizeFromFont:(UIFont *)font width:(CGFloat)width;

/**
 *  @brief  比较字符串是否在范围内
 *
 *  @param  min          最小值
 *  @param  max          最大值
 *  @param  subLength    需要截取比较的长度(截取前缀)
 *
 *  @return bool         是否在范围内
 */
- (BOOL)compareWithMin:(int)min max:(int)max subLength:(int)subLength;

#pragma mark - String Judge
/**
 *  @brief  邮箱验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 *  @brief  手机号码验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 *  @brief  车牌号验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateCarNo:(NSString *)carNo;

/**
 *  @brief  车型验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateCarType:(NSString *)CarType;

/**
 *  @brief  用户名验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateUserName:(NSString *)name;

/**
 *  @brief  密码验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validatePassword:(NSString *)passWord;

/**
 *  @brief  昵称验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateNickname:(NSString *)nickname;

/**
 *  @brief  身份证号验证
 *
 *  @return Yes/No表示验证结果
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 *  校验银行卡
 *
 *  @param cardNo 银行卡
 *
 *  @return 是否有效
 */
+ (BOOL)checkCardNo:(NSString*)cardNo;


/**
 *  @brief  得到身份证的性别（男 女）****这个方法中不做身份证校验，请确保传入的是正确身份证
 *
 *  @return 性别
 */
+(NSString*)getIDCardSex:(NSString*)card;

/**
 *  @brief  是否为空
 *
 *  @return Yes/No表示验证结果
 */
+(BOOL)isEmpty:(NSString *)str;

/**
 *  @brief  是否为空白
 *
 *  @return Yes/No表示验证结果
 */
+(BOOL)isBlank:(NSString *)str;

/**
 *  @brief  是否不为空
 *
 *  @return Yes/No表示验证结果
 */
+(BOOL)isNotEmpty:(NSString *)str;

/**
 *  @brief  是否不为空白
 *
 *  @return Yes/No表示验证结果
 */
+(BOOL)isNotBlank:(NSString *)str;

/**
 *  @brief  是否为数字
 *
 *  @return Yes/No表示验证结果
 */
+(BOOL)isNumeric:(NSString *)str;

/**
 *  @brief  是否为空字符串
 *
 *  @return Yes/No表示验证结果
 */
-(BOOL)isBlankString;

#pragma mark - String MD5

/**
 *  @brief  MD5加密算法
 *
 *  @return 加密结果
 */
- (NSString *)md5String;

#pragma mark - String Directory
/**
 *  @brief  获取bunld目录下的路径
 *
 *  @return dic          密码
 */
+ (NSString *)bunldPath:(NSString *)filePath;

#pragma mark - String Split
/**
 *  @brief  获取中间字符串-（根据开始和结束字符串截取）
 *
 *  @return 结果字符
 */
-(NSString*)GetStringRangefirst:(NSString*)firststring laststring:(NSString*)laststring TargetString:(NSString*)string;

/**
 *  @brief  截取之后的字符串
 *
 *  @return 结果字符
 */
+(NSString*)GetLastString:(NSString*)laststring   TargetString:(NSString*)string;

/**
 *  @brief  分割字符串
 *
 *  @return 结果字符
 */
+(NSArray *)split:(NSString *)src separator:(NSString *)separator;

#pragma mark String ChangeLineSpaceAndWordSpace

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
