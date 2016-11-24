//
//  OffLineMessageModel.h
//  YongShang
//
//  Created by 姜易成 on 16/10/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffLineMessageModel : NSObject

//头像地址
@property (nonatomic,copy) NSString* portal;

//企业名称
@property (nonatomic,copy) NSString* company;

//联系人
@property (nonatomic,copy) NSString* linkman;

//消息文本
@property (nonatomic,copy) NSString* msg;

//联系电话
@property (nonatomic,copy) NSString* tel;

//0:文本；1:图片
@property (nonatomic,copy) NSString* type;

//留言编号
@property (nonatomic,copy) NSString* commentId;

//发送者名称
@property (nonatomic,copy) NSString* name;

//供求信息内容
@property (nonatomic,copy) NSString* info;

//发送者id
@property (nonatomic,copy) NSString* fromDeviceId;

//发送时间戳
@property (nonatomic,copy) NSString* sendTime;

//供求编号
@property (nonatomic,copy) NSString* sellbuyid;

@end
