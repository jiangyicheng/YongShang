//
//  GQSupplyAndBuyDetailModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "GQSupplyAndBuyDetailModel.h"

@implementation GQSupplyAndBuyDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"supplyInfoId" : @"id",
             @"typeName":@"typename"};
}

@end
