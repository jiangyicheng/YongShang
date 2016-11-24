//
//  YSTopInfoDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTopInfoDetailModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

//标题
@property (nonatomic,copy) NSString* title;

//图片访问地址
@property (nonatomic,copy) NSString* imageurl;

//时间
@property (nonatomic,copy) NSString* createtime;

//正文
@property (nonatomic,copy) NSString* context;

@end
