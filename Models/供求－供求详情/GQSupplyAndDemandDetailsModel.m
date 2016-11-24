//
//  GQSupplyAndDemandDetailsModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "GQSupplyAndDemandDetailsModel.h"

@implementation GQSupplyAndDemandDetailsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"companyname" : @"data.companyname",
             @"typeName" : @"data.typename",
             @"linkman" : @"data.linkman",
             @"telphoneType" : @"data.telphoneType",
             @"telphone" : @"data.telphone",
             @"qcid" : @"data.qcid",
             @"companyid":@"data.companyid",
             @"headimgurl":@"data.headimgurl",
             @"sellbuyimage1s":@"data.sellbuyimage1s",
             @"sellbuyimage1":@"data.sellbuyimage1",
             @"publishstatus":@"data.publishstatus",
             @"content" : @"data.content"};
}

@end
