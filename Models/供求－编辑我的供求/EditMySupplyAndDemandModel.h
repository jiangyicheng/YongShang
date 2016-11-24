//
//  EditMySupplyAndDemandModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditMySupplyAndDemandModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

//有效期
@property (nonatomic,copy) NSString* termid;

//供应/求购
@property (nonatomic,copy) NSString* lxtype;

//供求信息编号
@property (nonatomic,copy) NSString* supplyId;

//联系电话状态
@property (nonatomic,copy) NSString* telphoneType;

//内容
@property (nonatomic,copy) NSString* content;

@property (nonatomic,copy) NSString* sellbuyimage1;

@property (nonatomic,copy) NSString* sellbuyimage1s;


@end
