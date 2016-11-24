//
//  CommonModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Data;


@interface CommonModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSArray* data;

@end
