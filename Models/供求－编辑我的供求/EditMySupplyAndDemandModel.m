//
//  EditMySupplyAndDemandModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EditMySupplyAndDemandModel.h"

@implementation EditMySupplyAndDemandModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"termid" : @"data.termid",
             @"lxtype" : @"data.lxtype",
             @"supplyId" : @"data.supplyId",
             @"telphoneType" : @"data.telphoneType",
             @"sellbuyimage1s":@"data.sellbuyimage1s",
             @"sellbuyimage1":@"data.sellbuyimage1",
             @"content" : @"data.content"};
}

@end
