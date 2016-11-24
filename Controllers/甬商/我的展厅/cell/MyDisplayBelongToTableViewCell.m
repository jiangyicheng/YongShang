//
//  MyDisplayBelongToTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MyDisplayBelongToTableViewCell.h"

@implementation MyDisplayBelongToTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews
{
    //请假天数
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.text = @"请假天数";
    self.nameLab.textColor = getColor(@"333333");
    self.nameLab.font = DEF_FontSize_13;
    [self.contentView addSubview:self.nameLab];
    
    //输入请假天数
    self.dropDownMenu = [[JYCDropDownMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, getNumWithScanf(64))];
    self.dropDownMenu.layer.masksToBounds = YES;
    self.dropDownMenu.layer.cornerRadius = 5;
    self.dropDownMenu.layer.borderWidth = 0.7;
    self.dropDownMenu.layer.borderColor = getColor(@"3fbefc").CGColor;
    self.dropDownMenu.NumOfRow = 4;
    [self.dropDownMenu createOneMenuTitleArray:@[@"建筑行业",@"计算机行业",@"盛大行业",@"金融行业"]];
    [self.contentView addSubview:self.dropDownMenu];
    
    //布局
    __weak typeof (self)weakSelf = self;
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top);
        make.bottom.equalTo(weakSelf.bottom);
        make.left.equalTo(weakSelf.left).offset(20);
    }];
    
    __weak typeof (self.nameLab)weaklab = self.nameLab;
    [self.dropDownMenu makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.centerY);
        make.right.equalTo(weakSelf.right).offset(-20);
        make.height.equalTo(getNumWithScanf(64));
        make.left.equalTo(weaklab.right).offset(getNumWithScanf(10));
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
