//
//  SSAllTalkDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/26.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSAllTalkDetailModel : NSObject

//用户编号
@property (nonatomic,copy) NSString* quid;

//好友联系人名称
@property (nonatomic,copy) NSString* linkman;

//说说内容
@property (nonatomic,copy) NSString* context;

//好友企业名称
@property (nonatomic,copy) NSString* companyname;

//用户头像
@property (nonatomic,copy) NSString* headimgurl;

//说说唯一编号
@property (nonatomic,copy) NSString* shuoshuoId;

//说说发布时间
@property (nonatomic,copy) NSString* createtime;

//点赞数
@property (nonatomic,copy) NSString* clickliketotal;

//留言数
@property (nonatomic,copy) NSString* messagetotal;

//是否点赞（0否1是）
@property (nonatomic,copy) NSString* is_clicklike;

//是否留言（0否1是）
@property (nonatomic,copy) NSString* is_talkmessage;

//好友企业编号
@property (nonatomic,copy) NSString* companyid;

//图片路径
@property (nonatomic,copy) NSString* imageurl1;

//图片路径
@property (nonatomic,copy) NSString* imageurl1s;

//图片路径
@property (nonatomic,copy) NSString* imageurl2;

//图片路径
@property (nonatomic,copy) NSString* imageurl2s;

//图片路径
@property (nonatomic,copy) NSString* imageurl3;

//图片路径
@property (nonatomic,copy) NSString* imageurl3s;

//图片路径
@property (nonatomic,copy) NSString* imageurl4;

//图片路径
@property (nonatomic,copy) NSString* imageurl4s;

//图片路径
@property (nonatomic,copy) NSString* imageurl5;

//图片路径
@property (nonatomic,copy) NSString* imageurl5s;

//图片路径
@property (nonatomic,copy) NSString* imageurl6;

//图片路径
@property (nonatomic,copy) NSString* imageurl6s;

//图片路径
@property (nonatomic,copy) NSString* imageurl7;

//图片路径
@property (nonatomic,copy) NSString* imageurl7s;

//图片路径
@property (nonatomic,copy) NSString* imageurl8;

//图片路径
@property (nonatomic,copy) NSString* imageurl8s;

//图片路径
@property (nonatomic,copy) NSString* imageurl9;

//图片路径
@property (nonatomic,copy) NSString* imageurl9s;


@end
