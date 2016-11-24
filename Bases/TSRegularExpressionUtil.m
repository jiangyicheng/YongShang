//
//  TSRegularExpressionUtil.m
//  haihang
//
//  Created by pset on 1/1/15.
//  Copyright (c) 2015 zhanglu. All rights reserved.
//

#import "TSRegularExpressionUtil.h"

@implementation TSRegularExpressionUtil

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//年月日  ^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$

+ (BOOL) validateMonthAndYear:(NSString *)date
{
    NSString *dateRegex = @"^(?:(?!0000)[0-9]{4}([\\u002E])(?:(?:0?[1-9]|1[0-2])\\1(?:0?[1-9]|1[0-9]|2[0-8])|(?:0?[13-9]|1[0-2])\\1(?:29|30)|(?:0?[13578]|1[02])\\1(?:31))|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)([\\u002E]?)0?2\\2(?:29))$";
//    NSString *dateRegex = @"^(?:(?!0000)[0-9]{4}([\\u002E]?)(?:(?:0?[1-9]|1[0-2])\\1(?:0?[1-9]|1[0-9]|2[0-8])|(?:0?[13-9]|1[0-2])\\1(?:29|30)|(?:0?[13578]|1[02])\\1(?:31))|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)([\\u002E]?)0?2\\2(?:29))$";
    NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dateRegex];
    return [dateTest evaluateWithObject:date];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    NSString *Regex = @"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneNumberText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneNumberText evaluateWithObject:mobile];

}

//验证码验证
+ (BOOL) verificationCode:(NSString*)code{
    NSString *phoneRegex = @"^[0-9]{6}$";
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [telephoneTest evaluateWithObject:code];
}
//电话号码验证
+ (BOOL) validateTelephone:(NSString*)telephone{
//    NSString *phoneRegex = @"(^(0\\d{2})(\\d{8})$)|(^(0\\d{3})(\\d{7})$)";
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[0-9]|17[0-9]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [telephoneTest evaluateWithObject:telephone];
}
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}
//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z][A-Za-z0-9]{5,19}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *Regex = @"^[0-9a-zA-Z]{6,16}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return[emailTest evaluateWithObject:passWord];
}
//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//CVN
+ (BOOL) validateCVNCode: (NSString *)cvnCode
{
    BOOL flag;
    if (cvnCode.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{3})";
    NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [cvnCodePredicate evaluateWithObject:cvnCode];
}
//month
+ (BOOL) validateMonth: (NSString *)month
{
    BOOL flag;
    if (!(month.length == 2)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"(^(0)([0-9])$)|(^(1)([0-2])$)";
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [monthPredicate evaluateWithObject:month];
}
//month
+ (BOOL) validateYear: (NSString *)year
{
    BOOL flag;
    if (!(year.length == 2)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([1-3])([0-9])$";
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [yearPredicate evaluateWithObject:year];
}
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode
{
    BOOL flag;
    if (!(verifyCode.length == 6)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}
//金额正则
+ (BOOL) validatePureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
@end

