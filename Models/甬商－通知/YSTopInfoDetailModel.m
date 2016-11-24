//
//  YSTopInfoDetailModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSTopInfoDetailModel.h"

@implementation YSTopInfoDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" : @"data.title",
             @"imageurl" : @"data.imageurl",
             @"createtime" : @"data.createtime",
             @"context":@"data.context"};
}

@end
