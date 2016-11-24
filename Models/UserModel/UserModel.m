//
//  UserModel.m
//  XinChengOA
//
//  Created by 姜易成 on 16/8/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "UserModel.h"

static NSString* const KEY_IMAGECOUNT = @"com.YS.imageCount";
static NSString* const KEY_IMAGETOTALCOUNT = @"com.YS.imageTotalCount";
static NSString* const KEY_BUNDLE = @"com.YS.root_bundle";
static NSString* const KEY_USERTOKEN = @"com.YS.userToken";
static NSString* const KEY_SHUOSHUOID = @"com.YS.shuoshuoId";
static NSString* const KEY_USERTYPE = @"com.YS.userType";
static NSString* const KEY_SEX = @"com.YS.sex";
static NSString* const KEY_ICON = @"com.YS.icon";
static NSString* const KEY_COMPANYID = @"com.YS.companyId";
static NSString* const KEY_TRADEID = @"com.YS.tradeId";
static NSString* const KEY_USERID = @"com.YS.userID";
static NSString* const KEY_MOBILENUM = @"com.YS.mobileNum";
static NSString* const KEY_AVATAR_PATH = @"com.YS.avatarpath";
static NSString* const KEY_NICKNAME = @"com.YS.nickName";
static NSString* const KEY_EMAIL = @"com.YS.email";
static NSString* const KEY_NAME = @"com.YS.name";
static NSString* const KEY_COMPANY = @"com.YS.company";
static NSString* const KEY_DEPARTMENT = @"com.YS.department";
static NSString* const KEY_POSTNAME = @"com.YS.postname";

@implementation UserModel

+(UserModel*)shareInstanced
{
    static UserModel* _userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserModel alloc]init];
    });
    return _userInfo;
}

-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

#pragma mark - imageLastCount

-(NSString *)imageLastCount
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_IMAGECOUNT:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IMAGECOUNT];
}

-(void)setImageLastCount:(NSString *)imageLastCount
{
    if (!imageLastCount) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_IMAGECOUNT];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:imageLastCount forKey:KEY_IMAGECOUNT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - imageTotalCount

-(NSString *)imageTotalCount
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_IMAGETOTALCOUNT:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IMAGETOTALCOUNT];
}

-(void)setImageTotalCount:(NSString *)imageTotalCount
{
    if (!imageTotalCount) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_IMAGETOTALCOUNT];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:imageTotalCount forKey:KEY_IMAGETOTALCOUNT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - root_bundle

-(NSString *)root_bundle
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_BUNDLE:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BUNDLE];
}

-(void)setRoot_bundle:(NSString *)root_bundle
{
    if (!root_bundle) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_BUNDLE];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:root_bundle forKey:KEY_BUNDLE];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - userType

-(NSString *)userType
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_USERTYPE:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERTYPE];
}

-(void)setUserType:(NSString *)userType
{
    if (!userType) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USERTYPE];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userType forKey:KEY_USERTYPE];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - sex

-(NSString *)sex
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_SEX:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SEX];
}

-(void)setSex:(NSString *)sex
{
    if (!sex) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_SEX];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sex forKey:KEY_SEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - icon

-(NSString *)icon
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_ICON:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ICON];
}

-(void)setIcon:(NSString *)icon
{
    if (!icon) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_ICON];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:icon forKey:KEY_ICON];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - userToken

-(NSString *)userToken
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_USERTOKEN:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERTOKEN];
}

-(void)setUserToken:(NSString *)userToken
{
    if (!userToken) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USERTOKEN];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:KEY_USERTOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - shuoshuoId

-(NSString *)shuoshuoId
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_SHUOSHUOID:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHUOSHUOID];
}

-(void)setShuoshuoId:(NSString *)shuoshuoId
{
    if (!shuoshuoId) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_SHUOSHUOID];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:shuoshuoId forKey:KEY_SHUOSHUOID];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - companyID

-(NSString *)companyId
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_COMPANYID:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_COMPANYID];
}

-(void)setCompanyId:(NSString *)companyId
{
    if (!companyId) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_COMPANYID];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:companyId forKey:KEY_COMPANYID];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - tradeId

-(NSString *)tradeId
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_TRADEID:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TRADEID];
}

-(void)setTradeId:(NSString *)tradeId
{
    if (!tradeId) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_TRADEID];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tradeId forKey:KEY_TRADEID];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - userID

-(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_USERID:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERID];
}

-(void)setUserID:(NSString *)userID
{
    if (!userID) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USERID];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:KEY_USERID];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - mobilePhone

-(NSString *)mobileNum
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_MOBILENUM:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_MOBILENUM];
}

-(void)setMobileNum:(NSString *)mobileNum
{
    if (!mobileNum) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_MOBILENUM];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mobileNum forKey:KEY_MOBILENUM];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 头像

-(NSString *)avatar_path
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_AVATAR_PATH:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AVATAR_PATH];
}

-(void)setAvatar_path:(NSString *)avatar_path
{
    if (!avatar_path) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_AVATAR_PATH];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:avatar_path forKey:KEY_AVATAR_PATH];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 昵称

-(NSString *)nickName
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_NICKNAME:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_NICKNAME];
}

-(void)setNickName:(NSString *)nickName
{
    if (!nickName) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_NICKNAME];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:KEY_NICKNAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - email

-(NSString *)email
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_EMAIL:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_EMAIL];
}

-(void)setEmail:(NSString *)email
{
    if (!email) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_EMAIL];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:KEY_EMAIL];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 姓名

-(NSString *)name
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_NAME:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_NAME];
}

-(void)setName:(NSString *)name
{
    if (!name) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_NAME];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_NAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark - 部门

-(NSString *)department
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_DEPARTMENT:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_DEPARTMENT];
}

-(void)setDepartment:(NSString *)department
{
    if (!department) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_DEPARTMENT];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:department forKey:KEY_DEPARTMENT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - ucode

-(NSString *)postName
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{KEY_POSTNAME:@""}];
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_POSTNAME];
}

-(void)setPostName:(NSString *)postName
{
    if (!postName) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_POSTNAME];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:postName forKey:KEY_POSTNAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
}








@end
