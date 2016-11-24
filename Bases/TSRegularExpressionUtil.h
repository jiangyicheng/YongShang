//
//  TSRegularExpressionUtil.h
//  haihang
//
//  Created by pset on 1/1/15.
//  Copyright (c) 2015 zhanglu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  error_username = 0,
  error_password,
  error_verificationcode,
  success,
  verificationcodesuccess,
  inputTypecount
} inputType;

@interface TSRegularExpressionUtil : NSObject

//邮箱
+ (BOOL)validateEmail:(NSString *)email;
//年月日
+ (BOOL) validateMonthAndYear:(NSString *)date;
//验证码
+ (BOOL) verificationCode:(NSString*)code;
//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile;
//电话号码验证
+ (BOOL)validateTelephone:(NSString *)telephone;
//车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo;
//车型
+ (BOOL)validateCarType:(NSString *)CarType;
//用户名
+ (BOOL)validateUserName:(NSString *)name;
//密码
+ (BOOL)validatePassword:(NSString *)passWord;
//昵称
+ (BOOL)validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard;
//银行卡
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber;
//银行卡后四位
+ (BOOL)validateBankCardLastNumber:(NSString *)bankCardNumber;
// CVN
+ (BOOL)validateCVNCode:(NSString *)cvnCode;
// month
+ (BOOL)validateMonth:(NSString *)month;
// month
+ (BOOL)validateYear:(NSString *)year;
// verifyCode
+ (BOOL)validateVerifyCode:(NSString *)verifyCode;
//金额正则
+ (BOOL)validatePureFloat:(NSString *)string;

@end
