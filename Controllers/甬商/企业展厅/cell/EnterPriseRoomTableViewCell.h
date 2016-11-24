//
//  EnterPriseRoomTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSEnterPriseRoomModel.h"
#import "YSEnterPriseDetailModel.h"
#import "GQSupplyAndBuyDetailModel.h"

@interface EnterPriseRoomTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString* gongqiuStr;
@property (nonatomic,strong) YSEnterPriseRoomModel* model;
@property (nonatomic,strong) YSEnterPriseRoomModel* friendModel;
@property (nonatomic,strong) YSEnterPriseDetailModel* detailModel;
@property (nonatomic,strong) GQSupplyAndBuyDetailModel* GQModel;

@end
