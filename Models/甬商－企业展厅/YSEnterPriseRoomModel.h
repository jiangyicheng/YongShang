//
//  YSEnterPriseRoomModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEnterPriseRoomModel : NSObject

//企业唯一编号
@property (nonatomic,copy) NSString* enterPriseId;

//企业名称
@property (nonatomic,copy) NSString* companyname;

//主营业务
@property (nonatomic,copy) NSString* mainbusiness;

//认证状态  1:待认证 2:已认证 0:未通过认证
@property (nonatomic,copy) NSString* status;

//1.已申请 2.已是好友 11 被申请 0无关系
@property (nonatomic,copy) NSString* type;

//是否被选中
@property (nonatomic,assign,getter=isSelected) BOOL selected;


@end
