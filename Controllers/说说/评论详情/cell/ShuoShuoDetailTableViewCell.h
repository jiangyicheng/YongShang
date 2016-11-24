//
//  ShuoShuoDetailTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTalkTalkDetailModel.h"

@protocol IconViewClickDelegate <NSObject>

-(void)iconViewDidClick:(UITableViewCell*)cell;

@end

@interface ShuoShuoDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *companyAndNameLab;

@property (nonatomic,strong) SSTalkTalkDetailModel* model;
@property (nonatomic,assign) id<IconViewClickDelegate> delegate;

@end
