//
//  loginModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loginModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

//登录企业的编号
@property (nonatomic,copy) NSString* createcompanyid;

//所属商会编号
@property (nonatomic,copy) NSString* tradeId;

//用户编号
@property (nonatomic,copy) NSString* userId;

//用户名
@property (nonatomic,copy) NSString* userName;

//联系人头像
@property (nonatomic,copy) NSString* headimgurl;

//说说供求权限
@property (nonatomic,copy) NSString* talkAndSellbuyStatus;

@end
