//
//  MessageModel.m
//  XinChengOA
//
//  Created by 姜易成 on 16/7/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+(id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel* messModel = [[MessageModel alloc]init];
    messModel.text = dict[@"text"];
    messModel.time = dict[@"time"];
    messModel.type = [dict[@"type"] intValue];
    
    return messModel;
}

@end
