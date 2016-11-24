//
//  GQAddSupplyAndDemandModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQAddSupplyAndDemandModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;

@property (nonatomic,strong) NSString* data;

//供求编号
@property (nonatomic,copy) NSString* sellbuyid;

@end
