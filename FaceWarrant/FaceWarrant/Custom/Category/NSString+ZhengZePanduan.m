//
//  NSString+ZhengZePanduan.m
//  LhkhBase
//
//  Created by LHKH on 2017/11/6.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "NSString+ZhengZePanduan.h"

@implementation NSString (ZhengZePanduan)
#pragma 正则匹配手机号(包含港澳手机号码)
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1(3[0-9]|4[0-9]|5[0-35-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$|^([6|9])\\d{7}$|^[6]([8|6])\\d{5}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:telNumber];
}
#pragma 正则匹配身份证号
+ (BOOL)checkIDCard:(NSString *) idCard
{
    NSLog(@"idCard===%@",idCard);
    
    //判断位数
    if ([idCard length] != 15 ||[idCard length] != 18) {
        return NO;
    }
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:idCard];
    if ([idCard length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        idCard = mString;
    }
    
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:idCard]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex  = [[idCard substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum      += subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [idCard substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
    
    /*方法二
     NSString *value = [idCard copy];
     value = [value stringByReplacingOccurrencesOfString:@"X" withString:@"x"];
     value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     int length = 0;
     if (!value) {
     return NO;
     }else {
     length = (int)value.length;
     if (length != 15 && length !=18) {
     return NO;
     }
     }
     // 省份代码
     NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
     NSString *valueStart2 = [value substringToIndex:2];
     BOOL areaFlag = NO;
     for (NSString *areaCode in areasArray) {
     if ([areaCode isEqualToString:valueStart2]) {
     areaFlag = YES;
     break;
     }
     }
     if (!areaFlag) {
     return NO;
     }
     NSRegularExpression *regularExpression;
     NSUInteger numberofMatch;
     int year = 0;
     switch (length) {
     case 15:
     year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
     if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
     regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"                   options:NSRegularExpressionCaseInsensitive error:nil];// 测试出生日期的合法性
     }else {
     regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"           options:NSRegularExpressionCaseInsensitive error:nil];// 测试出生日期的合法性
     }
     numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
     if(numberofMatch > 0) {
     return YES;
     }else {
     return NO;
     }
     case 18:
     year = [value substringWithRange:NSMakeRange(6,4)].intValue;
     if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
     regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"options:NSRegularExpressionCaseInsensitive error:nil];// 测试出生日期的合法性
     
     }else {
     regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
     options:NSRegularExpressionCaseInsensitive error:nil];// 测试出生日期的合法性
     }
     numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
     if(numberofMatch > 0) {
     int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
     int Y = S % 11;
     NSString *M = @"F";
     NSString *JYM = @"10X98765432";
     M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
     if ([M isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]]) {
     return YES;// 检测ID的校验位
     }else {
     return NO;
     }
     }else {
     return NO;
     }
     
     default:
     return NO;
     }
     return NO;*/
}
    
#pragma 正则匹配邮箱
+ (BOOL) checkEmail:(NSString *) email
{
    NSLog(@"Email===%@",email);
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [pred evaluateWithObject:email];
}
    
#pragma 正则匹配银行卡
+ (BOOL) checkBankCard:(NSString *) bankCard
{
    NSLog(@"bankCard===%@",bankCard);
    if(bankCard.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < bankCard.length; i++)
    {
        c = [bankCard characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
    
}
    
#pragma 正则匹配车牌号
+ (BOOL) checkCarNo:(NSString *) CarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [pred evaluateWithObject:CarNo];
}
    
#pragma 正则匹配邮政编码
+ (BOOL) checkPostalcode :(NSString *) Postalcode
{
    NSString *phoneRegex = @"^[0-8]\\d{5}(?!\\d)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [pred evaluateWithObject:Postalcode];
}
    
#pragma 正则匹配网址
+ (BOOL) checkUrl :(NSString *) Url
{
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:Url];
}
#pragma 正则匹配IP
+ (BOOL) checkIP :(NSString *) IP
{
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pred evaluateWithObject:IP];
    
    if (rc) {
        NSArray *componds = [IP componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        
        return v;
    }
    
    return NO;
}
#pragma 正则匹配纯汉字
+ (BOOL) checkChinese :(NSString *) Chinese
{
    NSString *phoneRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [pred evaluateWithObject:Chinese];
}
#pragma 正则匹配工商税号
+ (BOOL) checkTaxNo :(NSString *) TaxNo
{
    NSString *emailRegex = @"[0-9]\\d{13}([0-9]|X)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [pred evaluateWithObject:TaxNo];
}
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
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}
    
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
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}
    
/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
    
/** 去掉html格式 */
- (NSString *)removeHtmlFormat
{
    NSString *str = [NSString stringWithFormat:@"%@", self];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        str = [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@"$2$1"];
    } else {
        NSLog(@"%@", error);
    }
    
    NSArray *html_code = @[
                           @"\"", @"'", @"&", @"<", @">",
                           @"", @"¡", @"¢", @"£", @"¤",
                           @"¥", @"¦", @"§", @"¨", @"©",
                           @"ª", @"«", @"¬", @"", @"®",
                           @"¯", @"°", @"±", @"²", @"³",
                           
                           @"´", @"µ", @"¶", @"·", @"¸",
                           @"¹", @"º", @"»", @"¼", @"½",
                           @"¾", @"¿", @"×", @"÷", @"À",
                           @"Á", @"Â", @"Ã", @"Ä", @"Å",
                           @"Æ", @"Ç", @"È", @"É", @"Ê",
                           
                           @"Ë", @"Ì", @"Í", @"Î", @"Ï",
                           @"Ð", @"Ñ", @"Ò", @"Ó", @"Ô",
                           @"Õ", @"Ö", @"Ø", @"Ù", @"Ú",
                           @"Û", @"Ü", @"Ý", @"Þ", @"ß",
                           @"à", @"á", @"â", @"ã", @"ä",
                           
                           @"å", @"æ", @"ç", @"è", @"é",
                           @"ê", @"ë", @"ì", @"í", @"î",
                           @"ï", @"ð", @"ñ", @"ò", @"ó",
                           @"ô", @"õ", @"ö", @"ø", @"ù",
                           @"ú", @"û", @"ü", @"ý", @"þ",
                           
                           @"ÿ", @"∀", @"∂", @"∃", @"∅",
                           @"∇", @"∈", @"∉", @"∋", @"∏",
                           @"∑", @"−", @"∗", @"√", @"∝",
                           @"∞", @"∠", @"∧", @"∨", @"∩",
                           @"∪", @"∫", @"∴", @"∼", @"≅",
                           
                           @"≈", @"≠", @"≡", @"≤", @"≥",
                           @"⊂", @"⊃", @"⊄", @"⊆", @"⊇",
                           @"⊕", @"⊗", @"⊥", @"⋅", @"Α",
                           @"Β", @"Γ", @"Δ", @"Ε", @"Ζ",
                           @"Η", @"Θ", @"Ι", @"Κ", @"Λ",
                           
                           @"Μ", @"Ν", @"Ξ", @"Ο", @"Π",
                           @"Ρ", @"Σ", @"Τ", @"Υ", @"Φ",
                           @"Χ", @"Ψ", @"Ω", @"α", @"β",
                           @"γ", @"δ", @"ε", @"ζ", @"η",
                           @"θ", @"ι", @"κ", @"λ", @"μ",
                           
                           @"ν", @"ξ", @"ο", @"π", @"ρ",
                           @"ς", @"σ", @"τ", @"υ", @"φ",
                           @"χ", @"ψ", @"ω", @"ϑ", @"ϒ",
                           @"ϖ", @"Œ", @"œ", @"Š", @"š",
                           @"Ÿ", @"ƒ", @"ˆ", @"˜", @"",
                           
                           @"", @"", @"", @"", @"",
                           @"", @"–", @"—", @"‘", @"’",
                           @"‚", @"“", @"”", @"„", @"†",
                           @"‡", @"•", @"…", @"‰", @"′",
                           @"″", @"‹", @"›", @"‾", @"€",
                           
                           @"™", @"←", @"↑", @"→", @"↓",
                           @"↔", @"↵", @"⌈", @"⌉", @"⌊",
                           @"⌋", @"◊", @"♠", @"♣", @"♥",
                           @"♦",
                           ];
    NSArray *code = @[
                      @"&quot;", @"&apos;", @"&amp;", @"&lt;", @"&gt;",
                      @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;",
                      @"&yen;", @"&brvbar;", @"&sect;", @"&uml;", @"&copy;",
                      @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                      @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;",
                      
                      @"&acute;", @"&micro;", @"&para;", @"&middot;", @"&cedil;",
                      @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;", @"&frac12;",
                      @"&frac34;", @"&iquest;", @"&times;", @"&divide;", @"&Agrave;",
                      @"&Aacute;", @"&Acirc;", @"&Atilde;", @"&Auml;", @"&Aring;",
                      @"&AElig;", @"&Ccedil;", @"&Egrave;", @"&Eacute;", @"&Ecirc;",
                      
                      @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                      @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;",
                      @"&Otilde;", @"&Ouml;", @"&Oslash;", @"&Ugrave;", @"&Uacute;",
                      @"&Ucirc;", @"&Uuml;", @"&Yacute;", @"&THORN;", @"&szlig;",
                      @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                      
                      @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;",
                      @"&ecirc;", @"&euml;", @"&igrave;", @"&iacute;", @"&icirc;",
                      @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;", @"&oacute;",
                      @"&ocirc;", @"&otilde;", @"&ouml;", @"&oslash;", @"&ugrave;",
                      @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;",
                      
                      @"&yuml;", @"&forall;", @"&part;", @"&exists;", @"&empty;",
                      @"&nabla;", @"&isin;", @"&notin;", @"&ni;", @"&prod;",
                      @"&sum;", @"&minus;", @"&lowast;", @"&radic;", @"&prop;",
                      @"&infin;", @"&ang;", @"&and;", @"&or;", @"&cap;",
                      @"&cup;", @"&int;", @"&there4;", @"&sim;", @"&cong;",
                      
                      @"&asymp;", @"&ne;", @"&equiv;", @"&le;", @"&ge;",
                      @"&sub;", @"&sup;", @"&nsub;", @"&sube;", @"&supe;",
                      @"&oplus;", @"&otimes;", @"&perp;", @"&sdot;", @"&Alpha;",
                      @"&Beta;", @"&Gamma;", @"&Delta;", @"&Epsilon;", @"&Zeta;",
                      @"&Eta;", @"&Theta;", @"&Iota;", @"&Kappa;", @"&Lambda;",
                      
                      @"&Mu;", @"&Nu;", @"&Xi;", @"&Omicron;", @"&Pi;",
                      @"&Rho;", @"&Sigma;", @"&Tau;", @"&Upsilon;", @"&Phi;",
                      @"&Chi;", @"&Psi;", @"&Omega;", @"&alpha;", @"&beta;",
                      @"&gamma;", @"&delta;", @"&epsilon;", @"&zeta;", @"&eta;",
                      @"&theta;", @"&iota;", @"&kappa;", @"&lambda;", @"&mu;",
                      
                      @"&nu;", @"&xi;", @"&omicron;", @"&pi;", @"&rho;",
                      @"&sigmaf;", @"&sigma;", @"&tau;", @"&upsilon;", @"&phi;",
                      @"&chi;", @"&psi;", @"&omega;", @"&thetasym;", @"&upsih;",
                      @"&piv;", @"&OElig;", @"&oelig;", @"&Scaron;", @"&scaron;",
                      @"&Yuml;", @"&fnof;", @"&circ;", @"&tilde;", @"&ensp;",
                      
                      @"&emsp;", @"&thinsp;", @"&zwnj;", @"&zwj;", @"&lrm;",
                      @"&rlm;", @"&ndash;", @"&mdash;", @"&lsquo;", @"&rsquo;",
                      @"&sbquo;", @"&ldquo;", @"&rdquo;", @"&bdquo;", @"&dagger;",
                      @"&Dagger;", @"&bull;", @"&hellip;", @"&permil;", @"&prime;",
                      @"&Prime;", @"&lsaquo;", @"&rsaquo;", @"&oline;", @"&euro;",
                      
                      @"&trade;", @"&larr;", @"&uarr;", @"&rarr;", @"&darr;",
                      @"&harr;", @"&crarr;", @"&lceil;", @"&rceil;", @"&lfloor;",
                      @"&rfloor;", @"&loz;", @"&spades;", @"&clubs;", @"&hearts;",
                      @"&diams;",
                      ];
    //    NSArray *code_hex = @[
    //                          @"&#34;", @"&#39;", @"&#38;", @"&#60;", @"&#62;",
    //                          @"&#160;", @"&#161;", @"&#162;", @"&#163;", @"&#164;",
    //                          @"&#165;", @"&#166;", @"&#167;", @"&#168;", @"&#169;",
    //                          @"&#170;", @"&#171;", @"&#172;", @"&#173;", @"&#174;",
    //                          @"&#175;", @"&#176;", @"&#177;", @"&#178;", @"&#179;",
    //
    //                          @"&#180;", @"&#181;", @"&#182;", @"&#183;", @"&#184;",
    //                          @"&#185;", @"&#186;", @"&#187;", @"&#188;", @"&#189;",
    //                          @"&#190;", @"&#191;", @"&#215;", @"&#247;", @"&#192;",
    //                          @"&#193;", @"&#194;", @"&#195;", @"&#196;", @"&#197;",
    //                          @"&#198;", @"&#199;", @"&#200;", @"&#201;", @"&#202;",
    //
    //                          @"&#203;", @"&#204;", @"&#205;", @"&#206;", @"&#207;",
    //                          @"&#208;", @"&#209;", @"&#210;", @"&#211;", @"&#212;",
    //                          @"&#213;", @"&#214;", @"&#216;", @"&#217;", @"&#218;",
    //                          @"&#219;", @"&#220;", @"&#221;", @"&#222;", @"&#223;",
    //                          @"&#224;", @"&#225;", @"&#226;", @"&#227;", @"&#228;",
    //
    //                          @"&#229;", @"&#230;", @"&#231;", @"&#232;", @"&#233;",
    //                          @"&#234;", @"&#235;", @"&#236;", @"&#237;", @"&#238;",
    //                          @"&#239;", @"&#240;", @"&#241;", @"&#242;", @"&#243;",
    //                          @"&#244;", @"&#245;", @"&#246;", @"&#248;", @"&#249;",
    //                          @"&#250;", @"&#251;", @"&#252;", @"&#253;", @"&#254;",
    //
    //                          @"&#255;", @"&#8704;", @"&#8706;", @"&#8707;", @"&#8709;",
    //                          @"&#8711;", @"&#8712;", @"&#8713;", @"&#8715;", @"&#8719;",
    //                          @"&#8721;", @"&#8722;", @"&#8727;", @"&#8730;", @"&#8733;",
    //                          @"&#8734;", @"&#8736;", @"&#8743;", @"&#8744;", @"&#8745;",
    //                          @"&#8746;", @"&#8747;", @"&#8756;", @"&#8764;", @"&#8773;",
    //
    //                          @"&#8776;", @"&#8800;", @"&#8801;", @"&#8804;", @"&#8805;",
    //                          @"&#8834;", @"&#8835;", @"&#8836;", @"&#8838;", @"&#8839;",
    //                          @"&#8853;", @"&#8855;", @"&#8869;", @"&#8901;", @"&#913;",
    //                          @"&#914;", @"&#915;", @"&#916;", @"&#917;", @"&#918;",
    //                          @"&#919;", @"&#920;", @"&#921;", @"&#922;", @"&#923;",
    //
    //                          @"&#924;", @"&#925;", @"&#926;", @"&#927;", @"&#928;",
    //                          @"&#929;", @"&#931;", @"&#932;", @"&#933;", @"&#934;",
    //                          @"&#935;", @"&#936;", @"&#937;", @"&#945;", @"&#946;",
    //                          @"&#947;", @"&#948;", @"&#949;", @"&#950;", @"&#951;",
    //                          @"&#952;", @"&#953;", @"&#954;", @"&#923;", @"&#956;",
    //
    //                          @"&#925;", @"&#958;", @"&#959;", @"&#960;", @"&#961;",
    //                          @"&#962;", @"&#963;", @"&#964;", @"&#965;", @"&#966;",
    //                          @"&#967;", @"&#968;", @"&#969;", @"&#977;", @"&#978;",
    //                          @"&#982;", @"&#338;", @"&#339;", @"&#352;", @"&#353;",
    //                          @"&#376;", @"&#402;", @"&#710;", @"&#732;", @"&#8194;",
    //
    //                          @"&#8195;", @"&#8201;", @"&#8204;", @"&#8205;", @"&#8206;",
    //                          @"&#8207;", @"&#8211;", @"&#8212;", @"&#8216;", @"&#8217;",
    //                          @"&#8218;", @"&#8220;", @"&#8221;", @"&#8222;", @"&#8224;",
    //                          @"&#8225;", @"&#8226;", @"&#8230;", @"&#8240;", @"&#8242;",
    //                          @"&#8243;", @"&#8249;", @"&#8250;", @"&#8254;", @"&#8364;",
    //
    //                          @"&#8482;", @"&#8592;", @"&#8593;", @"&#8594;", @"&#8595;",
    //                          @"&#8596;", @"&#8629;", @"&#8968;", @"&#8969;", @"&#8970;",
    //                          @"&#8971;", @"&#9674;", @"&#9824;", @"&#9827;", @"&#9829;",
    //                          @"&#9830;",
    //                          ];
    //
    NSInteger idx = 0;
    for (NSString *obj in code) {
        str = [str stringByReplacingOccurrencesOfString:(NSString *)obj withString:html_code[idx]];
        idx++;
    }
    return str;
}
@end
