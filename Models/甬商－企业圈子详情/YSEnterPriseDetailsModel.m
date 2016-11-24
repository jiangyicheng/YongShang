//
//  YSEnterPriseDetailsModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/19.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSEnterPriseDetailsModel.h"

@implementation YSEnterPriseDetailsModel

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"dataList" : @"Data.DataList"};
//}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"enterPriseCricleId" : @"data.id",
             @"unionname" : @"data.unionname",
             @"memo" : @"data.memo",
             @"dataList" : @"data.dataList"
             };
}

@end
