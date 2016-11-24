//
//  EnterPriseDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterPriseDetailModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

//产品图片1
@property (nonatomic,copy) NSString* producturl1;

//产品图片2
@property (nonatomic,copy) NSString* producturl2;

//产品图片3
@property (nonatomic,copy) NSString* producturl3;

//产品图片4
@property (nonatomic,copy) NSString* producturl4;

//产品图片5
@property (nonatomic,copy) NSString* producturl5;

//产品图片6
@property (nonatomic,copy) NSString* producturl6;

//产品图片1
@property (nonatomic,copy) NSString* producturl1s;

//产品图片2
@property (nonatomic,copy) NSString* producturl2s;

//产品图片3
@property (nonatomic,copy) NSString* producturl3s;

//产品图片4
@property (nonatomic,copy) NSString* producturl4s;

//产品图片5
@property (nonatomic,copy) NSString* producturl5s;

//产品图片6
@property (nonatomic,copy) NSString* producturl6s;

//企业唯一编号
@property (nonatomic,copy) NSString* enterPriseId;

//企业归属
@property (nonatomic,copy) NSString* tradename;

//公司名称
@property (nonatomic,copy) NSString* companyName;

//联系人
@property (nonatomic,copy) NSString* linkman;

//联系电话
@property (nonatomic,copy) NSString* phone;

//主营业务
@property (nonatomic,copy) NSString* mainbusiness;

//认证状态  1:待认证 2:已认证 0:未通过认证
@property (nonatomic,copy) NSString* status;

//1. 已申请 2.已是好友 11.被申请 0无任何关系
@property (nonatomic,copy) NSString* type;

//联系地址
@property (nonatomic,copy) NSString* linkaddress;

@end
