//
//  EnterPriseListTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseListTableViewCell.h"

@interface EnterPriseListTableViewCell ()
{
    UIView* _bgView;            //背景view
    UILabel* _companyName;      //公司名称
    UILabel* _label;            //主营（不变）
    UILabel* _mainBusinessLab;  //主营
    UIImageView* _certificationImage; //认证
    UIButton* _selectBtn;      //选择Btn
}
@end

@implementation EnterPriseListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _selectBtn.selected = isSelected;
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

-(void)setDetailModel:(YSEnterPriseDetailModel *)detailModel
{
    _detailModel = detailModel;
    _companyName.text = detailModel.companyname;
    NSString* mainBussinessStr = detailModel.mainbusiness;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _mainBusinessLab.text = mainBussinessStr;
    if ([detailModel.status isEqualToString:@"0"]) {
        _certificationImage.hidden = YES;
    }else if ([detailModel.status isEqualToString:@"1"]){
        _certificationImage.hidden = YES;
    }else if ([detailModel.status isEqualToString:@"2"])
    {
        _certificationImage.hidden = NO;
    }
}

-(void)creatSubViews
{
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.borderColor = getColor(@"e6e6e6").CGColor;
    _bgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:_bgView];
    
    //公司名称
    _companyName = [[UILabel alloc]init];
    _companyName.textColor = getColor(@"333333");
    _companyName.font = DEF_FontSize_13;
    _companyName.text = @"上海科匠信息有限公司";
    [_bgView addSubview:_companyName];
    
    _label = [[UILabel alloc]init];
    _label.textColor = getColor(@"595959");
    _label.font = DEF_FontSize_13;
    _label.text = @"主营:";
    [_bgView addSubview:_label];
    
    //主营
    _mainBusinessLab = [[UILabel alloc]init];
    _mainBusinessLab.textColor = getColor(@"595959");
    _mainBusinessLab.font = DEF_FontSize_13;
    _mainBusinessLab.text = @"各类陶瓷玩具";
    [_bgView addSubview:_mainBusinessLab];
    
    //认证
    _certificationImage = [[UIImageView alloc]init];
    _certificationImage.image = [UIImage imageNamed:@"certification"];
    [_bgView addSubview:_certificationImage];
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn setImage:[UIImage imageNamed:@"listNormal"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"listSelected"] forState:UIControlStateSelected];
    _selectBtn.userInteractionEnabled = NO;
    [_bgView addSubview:_selectBtn];
    
    [self layout];
}

-(void)layout
{
    _bgView.sd_layout
    .leftSpaceToView(self.contentView,getNumWithScanf(13))
    .rightSpaceToView(self.contentView,getNumWithScanf(13))
    .topSpaceToView(self.contentView,getNumWithScanf(6))
    .bottomSpaceToView(self.contentView,getNumWithScanf(6));
    
    _companyName.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(30))
    .leftSpaceToView(_bgView,getNumWithScanf(50))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(_bgView,getNumWithScanf(65));
    
    _selectBtn.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(49))
    .leftSpaceToView(_bgView,getNumWithScanf(10))
    .widthIs(getNumWithScanf(30))
    .heightIs(getNumWithScanf(30));
    
    _label.sd_layout
    .leftSpaceToView(_bgView,getNumWithScanf(50))
    .heightIs(getNumWithScanf(26))
    .widthIs(getNumWithScanf(70))
    .topSpaceToView(_companyName,getNumWithScanf(20));
    
    _mainBusinessLab.sd_layout
    .leftSpaceToView(_label,3)
    .topSpaceToView(_companyName,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(_bgView,getNumWithScanf(70));
    
    _certificationImage.sd_layout
    .rightSpaceToView(_bgView,getNumWithScanf(19))
    .widthIs(getNumWithScanf(42))
    .heightIs(getNumWithScanf(42))
    .topSpaceToView(_bgView,getNumWithScanf(19));
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    if (selected) {
//        _selectBtn.selected = !_selectBtn.selected;
//    }
    // Configure the view for the selected state
}

@end
