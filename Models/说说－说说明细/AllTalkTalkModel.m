//
//  AllTalkTalkModel.m
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "AllTalkTalkModel.h"

@implementation AllTalkTalkModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dataList" : @"data.dataList",
             @"headimageurl" : @"data.headimageurl",
             @"linkman" : @"data.linkman",
             @"companyname" : @"data.companyname",
             @"talkurl" : @"data.talkurl"};
}

@end
