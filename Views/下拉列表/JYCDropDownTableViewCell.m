//
//  JYCDropDownTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "JYCDropDownTableViewCell.h"

@implementation JYCDropDownTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews
{
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = getColor(@"595959");
    self.titleLab.font = DEF_FontSize_13;
    [self.contentView addSubview:self.titleLab];
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = getColor(@"dddddd");
    [self.contentView addSubview:lineView];
    
    self.titleLab.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,getNumWithScanf(10))
    .bottomSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0);
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .heightIs(0.5)
    .bottomSpaceToView(self.contentView,0);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
//        self.titleLab.textColor = getColor(@"ff7e02");
        self.contentView.backgroundColor = getColor(@"ABE5FE");
    }else
    {
//        self.titleLab.textColor = getColor(@"666666");
        self.contentView.backgroundColor = getColor(@"ffffff");
    }
    // Configure the view for the selected state
}

@end
