//
//  YSEnterPriseCertificationModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSEnterPriseCertificationModel.h"

@implementation YSEnterPriseCertificationModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name" : @"data.name",
             @"businesscard" : @"data.businesscard",
             @"businesscards" : @"data.businesscards",
             @"termtime" : @"data.termtime",
             @"status" : @"data.status",
             @"applynoly":@"data.applynoly"};
}

@end
