//
//  ReadOfflineMessageModel.h
//  YongShang
//
//  Created by 姜易成 on 16/10/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadOfflineMessageModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSArray* dataList;

@end
