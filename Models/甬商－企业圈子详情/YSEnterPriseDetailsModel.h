//
//  YSEnterPriseDetailsModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/19.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataList;

@interface YSEnterPriseDetailsModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSArray* dataList;

//企业圈子编号
@property (nonatomic,copy) NSString* enterPriseCricleId;

//企业圈子名称
@property (nonatomic,copy) NSString* unionname;

//备注
@property (nonatomic,copy) NSString* memo;

@end
