//
//  GQSupplyAndBuyDetailModel.h
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQSupplyAndBuyDetailModel : NSObject

//企业名称
@property (nonatomic,copy) NSString* companyname;

//供求信息编号
@property (nonatomic,copy) NSString* supplyInfoId;

//内容
@property (nonatomic,copy) NSString* content;

//供应/求购
@property (nonatomic,copy) NSString* typeName;

//发布状态
@property (nonatomic,copy) NSString* publishstatus;

//认证状态
@property (nonatomic,copy) NSString* status;

@end
