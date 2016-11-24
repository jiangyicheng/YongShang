//
//  EnterPriseDetailModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseDetailModel.h"

@implementation EnterPriseDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"enterPriseId" : @"data.id",
             @"tradename" : @"data.tradename",
             @"linkman" : @"data.linkman",
             @"phone" : @"data.phone",
             @"companyName":@"data.companyname",
             @"type":@"data.type",
             @"linkaddress":@"data.linkaddress",
             @"mainbusiness" : @"data.mainbusiness",
             @"producturl1" : @"data.producturl1",
             @"producturl2" : @"data.producturl2",
             @"producturl3" : @"data.producturl3",
             @"producturl4" : @"data.producturl4",
             @"producturl5" : @"data.producturl5",
             @"producturl6" : @"data.producturl6",
             @"producturl1s" : @"data.producturl1s",
             @"producturl2s" : @"data.producturl2s",
             @"producturl3s" : @"data.producturl3s",
             @"producturl4s" : @"data.producturl4s",
             @"producturl5s" : @"data.producturl5s",
             @"producturl6s" : @"data.producturl6s",
             @"status":@"data.status"};
}

@end
