//
//  YSEnterPriseCertificationModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEnterPriseCertificationModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

//企业名称
@property (nonatomic,copy) NSString* name;

//营业执照
@property (nonatomic,copy) NSString* businesscard;

//营业执照缩略图
@property (nonatomic,copy) NSString* businesscards;

//有效期
@property (nonatomic,copy) NSString* termtime;

//状态
@property (nonatomic,copy) NSString* status;

//审批不通过的理由
@property (nonatomic,copy) NSString* applynoly;



@end
