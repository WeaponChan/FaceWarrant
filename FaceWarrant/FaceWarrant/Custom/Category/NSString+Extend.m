//
//  NSString+Extend.m
//  Lhkh
//
//  Created by Lhkh on 17-4-18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

/************字符串过滤************/
#define DECIMALNUMBER @"0123456789.\n"
#define INTEGERNUMBER @"0123456789\n"
#define ALPHANUMBER   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.\n"

/************小数配置************/
#define kDecimalLength 2                                                                // 保留的小数位数
#define kNumberFormatStr [NSString stringWithFormat:@"%%.0%dlf", kDecimalLength]        // 小数位数的格式化字符串

#import "NSString+Extend.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extend)

#pragma mark - Filter String

- (BOOL)filterString:(NSString *)string {
    // 去反字符,把所有的除了数字的字符都找出来
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:string] invertedSet];
    
    // componentsSep 把输入框输入的字符根据cs中字符一个一个去除cs字符并分割成单字符并转化为NSArray
    // componentsJoi 是把NSArray的字符通过""无间隔连接成一个NSString字符赋给filtered,就只剩数字
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL result = [self isEqualToString:filtered];
    
    return result;
}

- (BOOL)filterDecimalNumber {
    return [self filterString:DECIMALNUMBER];
}

- (BOOL)filterIntegerNumber {
    return [self filterString:INTEGERNUMBER];
}

- (BOOL)filterEmoji {
    __block BOOL isEomji = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
             
         }
     }];

    return isEomji;
}

//利用正则表达式验证

-(BOOL)filterEmail {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

#pragma mark - String Format

+ (NSString *)numberString:(double)number {
    return [NSString stringWithFormat:kNumberFormatStr, number];
}

+ (NSString *)stringFromNumber:(NSNumber *)number
{
    if (number.doubleValue == INFINITY || isnan(number.doubleValue)) {
        number = @0;
    }
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSMutableString *formatStr = [NSMutableString stringWithString:@"###,##0."];
    for (int i = 0; i< kDecimalLength; i++) {
        [formatStr appendString:@"0"];
    }
    [numberFormatter setPositiveFormat:formatStr];
    return [numberFormatter stringFromNumber: number];
}

#pragma mark - String size

- (CGSize)sizeFromFont:(UIFont *)font
{
    NSDictionary *textAttributes=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size=[self sizeWithAttributes:textAttributes];
    return size;
}

- (CGSize)sizeFromFont:(UIFont *)font width:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize textSize = CGSizeZero;
    // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
    CGRect rect = [self boundingRectWithSize:maxSize options:opts attributes:attributes context:nil];
    textSize = rect.size;
    
    return textSize;
}

- (BOOL)compareWithMin:(int)min max:(int)max subLength:(int)subLength
{
    NSString *temp = [self substringFromIndex:subLength];
    int num = temp.intValue;
    if (num >= min && num <= max) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - String Judge
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

+ (BOOL) validateUserName:(NSString *)name
{
    NSString*  regName1=@"^[\u4e00-\u9fa5]{2,15}$";//2-15位中文
    NSString*  regName2=@"^[A-Za-z]{4,30}$";//2-15位中文
    
    NSPredicate *userNamePredicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regName1];
    NSPredicate *userNamePredicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regName2];
    
    if([userNamePredicate1 evaluateWithObject:name] ||  [userNamePredicate2 evaluateWithObject:name])
    {
        return YES;
    }
    return NO;
}

+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    if(identityCard.length!=18)
    {
        return NO;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL) checkCardNo:(NSString*) cardNo
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

+ (NSString*)getIDCardSex:(NSString*)card
{
    card=[card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([card length]!=18)
    {
        return @"身份证长度错误";
    }
    NSInteger number=[[card substringWithRange:NSMakeRange(16,1)]integerValue];
    if(number%2==0)
    {//偶数为女
        return @"女";
    }else{
        return @"男";
    }
}

+ (BOOL)isEmpty:(NSString *)str
{
    if([NSString isBlank:str])return YES;
    if(![NSString isString:str])return YES;
    return str.length == 0;
}

+ (BOOL)isNotEmpty:(NSString *)str{
    return ![self isEmpty:str];
}

+ (BOOL)isBlank:(NSString *)str
{
    if([NSString isBlank:str])return YES;
    if(![NSString isString:str])return YES;
    for(int i = 0; i < str.length; i++){
        if([[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "]==NO){
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isString:(NSString *)str
{
    return [str isKindOfClass:[NSString class]]||str == nil;
}

+ (BOOL)isNotBlank:(NSString *)str
{
    return ![self isBlank:str];
}

+ (BOOL)isNumeric:(NSString *)str
{
    if([NSString isBlank:str])return YES;
    if(![NSString isString:str])return NO;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [str isEqualToString:filtered];
}

-(BOOL)isBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - String SaveForLogin
- (NSString *)md5String
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

#pragma mark - String Directory
+ (NSString *)bunldPath:(NSString *)filePath
{
    return [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
}

#pragma mark-获取中间字符串-（根据开始和结束字符串截取）
-(NSString*)GetStringRangefirst:(NSString*)firststring laststring:(NSString*)laststring TargetString:(NSString*)string
{
    
    NSRange firstrange =[string rangeOfString:firststring];
    NSRange lastrange=[string rangeOfString:laststring];
    NSInteger index=firstrange.location+firstrange.length;
    NSString* newstring=[string substringWithRange:NSMakeRange(index,lastrange.location-index)];
    NSString* strs =[newstring stringByRemovingPercentEncoding];

    return strs;
}

#pragma mark-截取之后的字符串
+ (NSString*)GetLastString:(NSString*)laststring   TargetString:(NSString*)string
{
    NSRange firstrange =[string rangeOfString:laststring];
    NSInteger index=firstrange.location+firstrange.length;
    return [string substringFromIndex:index];
}

+ (NSArray *)split:(NSString *)src separator:(NSString *)separator
{
    if([self isEmpty:src])return nil;
    if([self isEmpty:separator])return nil;
    if(src == nil || separator == nil || src.length == 0 || separator.length == 0)return [NSArray array];
    return [src componentsSeparatedByString:separator];
}

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

@end
