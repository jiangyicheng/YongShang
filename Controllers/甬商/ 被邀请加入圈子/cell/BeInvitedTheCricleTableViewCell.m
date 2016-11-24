//
//  BeInvitedTheCricleTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BeInvitedTheCricleTableViewCell.h"

@implementation BeInvitedTheCricleTableViewCell

- (void)awakeFromNib {
    self.normalLab.font = DEF_FontSize_13;
    self.normalLab.text = @"邀请企业";
    self.normalLab.hidden = YES;
    self.companynameLab.font = DEF_FontSize_13;
    self.companynameLab.textColor = getColor(@"de3535");
    self.normalLab.textColor = getColor(@"333333");
    
    self.normalLab.sd_layout
    .leftSpaceToView(self.contentView,getNumWithScanf(30))
    .topSpaceToView(self.contentView,getNumWithScanf(5))
    .heightIs(getNumWithScanf(26))
    .widthIs(getNumWithScanf(130));
    
    self.companynameLab.sd_layout
    .leftSpaceToView(self.normalLab,getNumWithScanf(5))
    .topSpaceToView(self.contentView,getNumWithScanf(0))
    .rightSpaceToView(self.contentView,getNumWithScanf(20))
    .autoHeightRatio(0);
}

-(void)setModel:(BeInvitedTheCricleModel *)model
{
    _model = model;
    self.companynameLab.text = model.companyname;
    [self setupAutoHeightWithBottomView:self.companynameLab bottomMargin:getNumWithScanf(5)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
