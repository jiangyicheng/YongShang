//
//  EnterPriseSelectedTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseSelectedTableViewCell.h"

@interface EnterPriseSelectedTableViewCell ()
{
    UILabel* _companyName;      //公司名称
    UILabel* _label;            //主营（不变）
    UILabel* _mainBusinessLab;  //主营
    UIImageView* _certificationImage; //认证
}
@end

@implementation EnterPriseSelectedTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)setModel:(YSEnterPriseRoomModel *)model
{
    _model = model;
    _companyName.text = model.companyname;
    NSString* mainBussinessStr = model.mainbusiness;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _mainBusinessLab.text = mainBussinessStr;
    if ([model.status isEqualToString:@"0"]) {
        _certificationImage.hidden = YES;
    }else if ([model.status isEqualToString:@"1"]){
        _certificationImage.hidden = YES;
    }else if ([model.status isEqualToString:@"2"])
    {
        _certificationImage.hidden = NO;
    }
}

-(void)creatSubViews
{
    //公司名称
    _companyName = [[UILabel alloc]init];
    _companyName.textColor = getColor(@"333333");
    _companyName.font = DEF_FontSize_13;
    _companyName.text = @"上海科匠信息有限公司";
    [self.contentView addSubview:_companyName];
    
    _label = [[UILabel alloc]init];
    _label.textColor = getColor(@"595959");
    _label.font = DEF_FontSize_13;
    _label.text = @"主营:";
    [self.contentView addSubview:_label];
    
    //主营
    _mainBusinessLab = [[UILabel alloc]init];
    _mainBusinessLab.textColor = getColor(@"595959");
    _mainBusinessLab.font = DEF_FontSize_13;
    _mainBusinessLab.text = @"各类陶瓷玩具";
    [self.contentView addSubview:_mainBusinessLab];
    
    //认证
    _certificationImage = [[UIImageView alloc]init];
    _certificationImage.image = [UIImage imageNamed:@"certification"];
    [self.contentView addSubview:_certificationImage];
    
    [self layout];
}

-(void)layout
{
    _companyName.sd_layout
    .topSpaceToView(self.contentView,getNumWithScanf(12))
    .leftSpaceToView(self.contentView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(self.contentView,getNumWithScanf(70));
    
    _label.sd_layout
    .topSpaceToView(_companyName,getNumWithScanf(10))
    .leftSpaceToView(self.contentView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26))
    .widthIs(getNumWithScanf(70));
    
    _mainBusinessLab.sd_layout
    .leftSpaceToView(_label,3)
    .topSpaceToView(_companyName,getNumWithScanf(10))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(self.contentView,getNumWithScanf(70));
    
    _certificationImage.sd_layout
    .rightSpaceToView(self.contentView,getNumWithScanf(14))
    .widthIs(getNumWithScanf(42))
    .heightIs(getNumWithScanf(42))
    .topSpaceToView(self.contentView,getNumWithScanf(19));
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
