//
//  MySupplyAndDemandTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/4.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQSupplyAndBuyDetailModel.h"

@protocol MySupplyAndDemandDelegate <NSObject>

-(void)MySupplyAndDemandCellDidClick:(UIButton*)btn withCell:(UITableViewCell*)cell;

@end

@interface MySupplyAndDemandTableViewCell : UITableViewCell

@property (nonatomic,assign) id<MySupplyAndDemandDelegate> delegate;

@property (nonatomic,strong) GQSupplyAndBuyDetailModel* detailModel;


@end
