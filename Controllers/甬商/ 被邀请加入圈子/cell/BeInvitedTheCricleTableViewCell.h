//
//  BeInvitedTheCricleTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeInvitedTheCricleModel.h"

@interface BeInvitedTheCricleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *normalLab;
@property (weak, nonatomic) IBOutlet UILabel *companynameLab;
@property (nonatomic,strong) BeInvitedTheCricleModel* model;
@end
