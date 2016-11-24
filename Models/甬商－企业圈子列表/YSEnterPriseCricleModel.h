//
//  YSEnterPriseCricleModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/19.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEnterPriseCricleModel : NSObject

//企业圈子编号
@property (nonatomic,copy) NSString* unionId;

//企业圈子名称
@property (nonatomic,copy) NSString* unionName;

//是否是创建者（1:创建者 2:加盟者）
@property (nonatomic,copy) NSString* type;

@end
