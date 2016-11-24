//
//  GQSupplyAndBuyModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "GQSupplyAndBuyModel.h"

@implementation GQSupplyAndBuyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dataList" : @"data.dataList",
             @"friendids" : @"data.friendids"};
}

@end
