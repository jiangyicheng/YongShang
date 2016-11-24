//
//  SaveTheChatMessageModel.m
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "SaveTheChatMessageModel.h"

@implementation SaveTheChatMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"chatimage" : @"data.chatimage",
             @"chatimagesl" : @"data.chatimagesl"};
}

@end
