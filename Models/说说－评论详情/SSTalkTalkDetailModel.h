//
//  SSTalkTalkDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/28.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSTalkTalkDetailModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSArray* dataList;

//说说内容
@property (nonatomic,copy) NSString* talkcontext;

//发布时间
@property (nonatomic,copy) NSString* talkpublishtime;

//用户编号
@property (nonatomic,copy) NSString* creatcid;

//头像
@property (nonatomic,copy) NSString* headimgurl;

//公司ID
@property (nonatomic,copy) NSString* companyId;

//联系人
@property (nonatomic,copy) NSString* linkman;

//公司名称
@property (nonatomic,copy) NSString* companyname;

//说说编号
@property (nonatomic,copy) NSString* talkid;

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
