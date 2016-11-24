//
//  GQSupplyAndDemandDetailsModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQSupplyAndDemandDetailsModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

//企业名称
@property (nonatomic,copy) NSString* companyname;

//企业ID
@property (nonatomic,copy) NSString* companyid;

//供应/求购
@property (nonatomic,copy) NSString* typeName;

//联系人
@property (nonatomic,copy) NSString* linkman;

//联系电话状态
@property (nonatomic,copy) NSString* telphoneType;

//内容
@property (nonatomic,copy) NSString* content;

//联系电话
@property (nonatomic,copy) NSString* telphone;

//联系人编号
@property (nonatomic,copy) NSString* qcid;

//联系人头像
@property (nonatomic,copy) NSString* headimgurl;

@property (nonatomic,copy) NSString* publishstatus;

@property (nonatomic,copy) NSString* sellbuyimage1;

@property (nonatomic,copy) NSString* sellbuyimage1s;

@end
