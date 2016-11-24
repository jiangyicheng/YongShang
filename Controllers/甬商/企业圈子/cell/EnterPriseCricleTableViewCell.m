//
//  EnterPriseCricleTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseCricleTableViewCell.h"

@implementation EnterPriseCricleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLab = [[UILabel alloc]init];
        self.nameLab.textColor = getColor(@"333333");
        self.nameLab.font = DEF_FontSize_13;
        [self.contentView addSubview:self.nameLab];
        
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = getColor(@"dddddd");
        [self.contentView addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .bottomEqualToView(self.contentView)
        .heightIs(0.5);
        
        self.nameLab.sd_layout
        .leftSpaceToView(self.contentView,15)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .rightSpaceToView(self.contentView,getNumWithScanf(70));
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
