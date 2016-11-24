//
//  EnterPriseListTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSEnterPriseRoomModel.h"
#import "YSEnterPriseDetailModel.h"

@interface EnterPriseListTableViewCell : UITableViewCell

@property (nonatomic) BOOL isSelected;
@property(nonatomic,strong)YSEnterPriseRoomModel* model;
@property (nonatomic,strong) YSEnterPriseDetailModel* detailModel;

@end
