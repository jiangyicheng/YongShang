//
//  MyDisPlayRoomNormalTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MyDisPlayRoomNormalTableViewCell.h"

@implementation MyDisPlayRoomNormalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews
{
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.text = @"请假天数";
    self.nameLab.textColor = getColor(@"333333");
    self.nameLab.font = DEF_FontSize_13;
    [self.contentView addSubview:self.nameLab];
    
    self.leavingDaysTextField = [[UITextField alloc]init];
    self.leavingDaysTextField.placeholder = @"(例:一天6小时)";
    [self.leavingDaysTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [self.leavingDaysTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    self.leavingDaysTextField.font = DEF_FontSize_12;
    self.leavingDaysTextField.textColor = getColor(@"4d4d4d");
    self.leavingDaysTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.leavingDaysTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.leavingDaysTextField];
    
    //布局
    __weak typeof (self)weakSelf = self;
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.top);
        make.bottom.equalTo(weakSelf.bottom);
        make.left.equalTo(weakSelf.left).offset(20);
    }];
    
    __weak typeof (self.nameLab)weaklab = self.nameLab;
    [self.leavingDaysTextField makeConstraints:^(MASConstraintMaker *make) {
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
