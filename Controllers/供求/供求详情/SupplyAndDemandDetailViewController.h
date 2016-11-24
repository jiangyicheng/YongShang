//
//  SupplyAndDemandDetailViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"

@interface SupplyAndDemandDetailViewController : BaseViewController

//供求信息编号
@property (nonatomic,strong) NSString* flagId;

//状态 1:我的
@property (nonatomic,strong) NSString* status;

//发布状态
@property (nonatomic,strong) NSString* publishStatus;

//供求信息编号
@property (nonatomic,strong) NSString* supplyInfoId;

/**
 *  所有好友企业
 */
@property (nonatomic,strong) NSArray* friendsId;

@end
