//
//  BeInvitedJoinTheCricleModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BeInvitedJoinTheCricleModel.h"

@implementation BeInvitedJoinTheCricleModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dataList" : @"data.dataList",
             };
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"companyid" : @"data.companyid",
//             @"unionid" : @"data.unionid",
//             @"companyname" : @"data.companyname",
//             @"memo" : @"data.memo",
//             @"unionname" : @"data.unionname"};
//}

@end
