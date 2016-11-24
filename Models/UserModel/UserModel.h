//
//  UserModel.h
//  XinChengOA
//
//  Created by 姜易成 on 16/8/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/**
 *  上传到第几张图片失败
 */
@property (nonatomic,strong,readonly) NSString* imageLastCount;
-(void)setImageLastCount:(NSString*)imageLastCount;

/**
 *  上传图片的总数
 */
@property (nonatomic,strong,readonly) NSString* imageTotalCount;
-(void)setImageTotalCount:(NSString *)imageTotalCount;

/**
 *  保存framework的路径
 */
@property (nonatomic,strong,readonly) NSString* root_bundle;
-(void)setRoot_bundle:(NSString *)root_bundle;

/**
 *  用户权限
 */
@property (nonatomic,strong,readonly) NSString* userType;
-(void)setUserType:(NSString *)userType;

/**
 *  性别
 */
@property (nonatomic,strong,readonly) NSString* sex;
-(void)setSex:(NSString *)sex;

/**
 *  用户头像
 */
@property (nonatomic,strong,readonly) NSString* icon;
-(void)setIcon:(NSString *)icon;

/**
 *  用户token值
 */
@property (nonatomic,strong,readonly) NSString* userToken;
-(void)setUserToken:(NSString *)userToken;

/**
 *  用户说说id
 */
@property (nonatomic,strong,readonly) NSString* shuoshuoId;
-(void)setShuoshuoId:(NSString *)shuoshuoId;

/**
 *  公司Id
 */
@property (nonatomic,strong,readonly) NSString* companyId;
-(void)setCompanyId:(NSString *)companyId;

/**
 *  商会Id
 */
@property (nonatomic,strong,readonly) NSString* tradeId;
-(void)setTradeId:(NSString *)tradeId;

/**
 *  手机号
 */
@property (nonatomic,strong,readonly) NSString* mobileNum;

-(void)setMobileNum:(NSString *)mobileNum;

/**
 *  用户ID
 */
@property (nonatomic,strong,readonly) NSString* userID;
-(void)setUserID:(NSString *)userID;

/**
 *  头像
 */
@property (nonatomic,strong,readonly) NSString* avatar_path;
-(void)setAvatar_path:(NSString *)avatar_path;

/**
 *  昵称
 */
@property (nonatomic,strong,readonly) NSString* nickName;
-(void)setNickName:(NSString *)nickName;

/**
 *  邮箱
 */
@property (nonatomic,strong,readonly) NSString* email;
-(void)setEmail:(NSString *)email;

/**
 *  姓名
 */
@property (nonatomic,strong,readonly) NSString* name;
-(void)setName:(NSString *)name;


/**
 *  部门
 */
@property (nonatomic,strong,readonly) NSString* department;

/**
 *  ucode
 */
@property (nonatomic,strong,readonly) NSString* postName;
-(void)setPostName:(NSString *)postName;

+(UserModel*)shareInstanced;



@end
