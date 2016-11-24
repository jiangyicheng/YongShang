//
//  ReprotTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ReprotTableViewCell.h"

@interface ReprotTableViewCell ()
{
    UIView* _lineView;
}
@end

@implementation ReprotTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews
{
    //举报内容
    _companyName = [[UILabel alloc]init];
    _companyName.textColor = getColor(@"333333");
    _companyName.font = DEF_FontSize_13;
    [self.contentView addSubview:_companyName];
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn setImage:[UIImage imageNamed:@"listNormal"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"listSelected"] forState:UIControlStateSelected];
    _selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectBtn];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = getColor(@"dddddd");
    [self.contentView addSubview:_lineView];
    
    [self layout];
}

-(void)layout
{
    _selectBtn.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,getNumWithScanf(20))
    .widthIs(getNumWithScanf(30))
    .heightIs(getNumWithScanf(30));
    
    _companyName.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,getNumWithScanf(70))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(self.contentView,getNumWithScanf(30));
    
    _lineView.sd_layout
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

    // Configure the view for the selected state
}

@end
