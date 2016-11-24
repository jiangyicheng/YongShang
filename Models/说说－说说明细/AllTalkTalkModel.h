//
//  AllTalkTalkModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllTalkTalkModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSArray* dataList;

//相册封面
@property (nonatomic,copy) NSString* talkurl;

//头像
@property (nonatomic,copy) NSString* headimageurl;

//用户名
@property (nonatomic,copy) NSString* linkman;

//企业名称
@property (nonatomic,copy) NSString* companyname;

@end
