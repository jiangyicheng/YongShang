//
//  SSTalkTalkCommonDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/28.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSTalkTalkCommonDetailModel : NSObject

//联系人
@property (nonatomic,copy) NSString* linkman;

//企业编号
@property (nonatomic,copy) NSString* clicklikecid;

//联系人头像
@property (nonatomic,copy) NSString* headimageurl;

//留言
@property (nonatomic,copy) NSString* message;

//时间
@property (nonatomic,copy) NSString* createtime;

//类型
@property (nonatomic,copy) NSString* type;

//留言编号
@property (nonatomic,copy) NSString* commentId;

//发表留言用户编号
@property (nonatomic,copy) NSString* uid;

@end
