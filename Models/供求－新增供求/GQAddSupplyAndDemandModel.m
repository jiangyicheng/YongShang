//
//  GQAddSupplyAndDemandModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "GQAddSupplyAndDemandModel.h"

@implementation GQAddSupplyAndDemandModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"sellbuyid" : @"data.sellbuyid"};
}

@end
