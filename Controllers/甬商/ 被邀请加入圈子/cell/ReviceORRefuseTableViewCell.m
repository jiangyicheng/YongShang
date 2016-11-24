//
//  ReviceORRefuseTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ReviceORRefuseTableViewCell.h"

@implementation ReviceORRefuseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton* reciveBtn = [[UIButton alloc]init];
        [reciveBtn setTitle:@"接受邀请" forState:UIControlStateNormal];
        [reciveBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        reciveBtn.backgroundColor = getColor(@"3fbefc");
        reciveBtn.layer.masksToBounds = YES;
        reciveBtn.layer.cornerRadius = 5;
        [reciveBtn addTarget:self action:@selector(reciveInviteClick) forControlEvents:UIControlEventTouchUpInside];
        reciveBtn.titleLabel.font = DEF_FontSize_13;
        [self.contentView addSubview:reciveBtn];
        
        UIButton* refuseBtn = [[UIButton alloc]init];
        [refuseBtn setTitle:@"拒绝邀请" forState:UIControlStateNormal];
        [refuseBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        refuseBtn.backgroundColor = getColor(@"3fbefc");
        refuseBtn.layer.masksToBounds = YES;
        refuseBtn.layer.cornerRadius = 5;
        refuseBtn.titleLabel.font = DEF_FontSize_13;
        [refuseBtn addTarget:self action:@selector(refuseInviteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:refuseBtn];
        
        reciveBtn.sd_layout
        .leftSpaceToView(self.contentView,getNumWithScanf(30))
        .heightIs(getNumWithScanf(80))
        .topSpaceToView(self.contentView,getNumWithScanf(120))
        .widthIs((SCREEN_WIDTH - getNumWithScanf(90))/2);
        
        refuseBtn.sd_layout
        .rightSpaceToView(self.contentView,getNumWithScanf(30))
        .heightIs(getNumWithScanf(80))
        .topSpaceToView(self.contentView,getNumWithScanf(120))
        .widthIs((SCREEN_WIDTH - getNumWithScanf(90))/2);
    }
    return self;
}

-(void)reciveInviteClick
{
    if ([self.delegate respondsToSelector:@selector(reviceBtnDidClick)]) {
        [self.delegate reviceBtnDidClick];
    }
}

-(void)refuseInviteClick
{
    if ([self.delegate respondsToSelector:@selector(refuseBtnDidClick)]) {
        [self.delegate refuseBtnDidClick];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
