//
//  BeInvitedTheCricleModel.h
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeInvitedTheCricleModel : NSObject

//被邀请企业编号
@property (nonatomic,copy) NSString* companyid;

//企业圈子编号
@property (nonatomic,copy) NSString* unionid;

//被邀请企业名称
@property (nonatomic,copy) NSString* companyname;

//备注
@property (nonatomic,copy) NSString* memo;

//企业圈子名称
@property (nonatomic,copy) NSString* unionname;

@end
