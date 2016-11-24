//
//  GQSupplyAndBuyModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataList;
@class Friendids;

@interface GQSupplyAndBuyModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSArray* dataList;

@property (nonatomic,strong) NSArray* friendids;

@end
