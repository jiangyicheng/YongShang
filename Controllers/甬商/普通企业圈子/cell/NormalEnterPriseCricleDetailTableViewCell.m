//
//  NormalEnterPriseCricleDetailTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "NormalEnterPriseCricleDetailTableViewCell.h"

@implementation NormalEnterPriseCricleDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton* confirmBtn = [[UIButton alloc]init];
        [confirmBtn setTitle:@"退出" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        confirmBtn.backgroundColor = getColor(@"3fbefc");
        confirmBtn.layer.masksToBounds = YES;
        confirmBtn.layer.cornerRadius = 5;
        [confirmBtn addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.titleLabel.font = DEF_FontSize_13;
        [self.contentView addSubview:confirmBtn];
        
        confirmBtn.sd_layout
        .topSpaceToView(self.contentView,getNumWithScanf(74))
        .leftSpaceToView(self.contentView,getNumWithScanf(30))
        .rightSpaceToView(self.contentView,getNumWithScanf(30))
        .bottomSpaceToView(self.contentView,getNumWithScanf(74));
    }
    return self;
}

-(void)confirmBtnDidClick
{
    if ([self.delegate respondsToSelector:@selector(quitBtnDidClick)]) {
        [self.delegate quitBtnDidClick];
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
