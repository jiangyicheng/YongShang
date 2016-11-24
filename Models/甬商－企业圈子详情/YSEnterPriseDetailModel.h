//
//  YSEnterPriseDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/19.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEnterPriseDetailModel : NSObject

//企业名称
@property (nonatomic,copy) NSString* companyname;

//企业编号
@property (nonatomic,copy) NSString* enterPriseId;

//主营业务
@property (nonatomic,copy) NSString* mainbusiness;

//状态（1:待验证 2:已接受邀请）
@property (nonatomic,copy) NSString* qzstatus;

//认证状态
@property (nonatomic,copy) NSString* status;

//是否被选中
@property (nonatomic,assign,getter=isSelected) BOOL selected;

@end
