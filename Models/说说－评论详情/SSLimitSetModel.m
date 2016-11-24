//
//  SSLimitSetModel.m
//  YongShang
//
//  Created by 姜易成 on 16/10/9.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "SSLimitSetModel.h"

@implementation SSLimitSetModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fseemtalk" : @"data.fseemtalk",
             @"mseeftalk" : @"data.mseeftalk",
             };
}

@end
