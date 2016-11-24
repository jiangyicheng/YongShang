//
//  YSEnterPriseDetailModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/19.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSEnterPriseDetailModel.h"

@implementation YSEnterPriseDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"companyname" : @"companyname",
             @"enterPriseId" : @"id",
             @"mainbusiness" : @"mainbusiness",
             @"qzstatus":@"qzstatus",
             @"status":@"status"};
}

@end
