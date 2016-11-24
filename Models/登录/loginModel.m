//
//  loginModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "loginModel.h"

@implementation loginModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"createcompanyid" : @"data.companyid",
            @"tradeId":@"data.orgid",
             @"userName":@"data.u_name",
             @"talkAndSellbuyStatus":@"data.talkAndSellbuyStatus",
             @"headimgurl":@"data.headimgurl",
             @"userId":@"data.uid"};
}

@end
