//
//  MySupplyAndDemandTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/4.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MySupplyAndDemandTableViewCell.h"

@interface MySupplyAndDemandTableViewCell ()
{
    UIView* _bgView;            //背景view
    UILabel* _companyName;      //公司名称
    UILabel* _label;            //主营（不变）
    UILabel* _mainBusinessLab;  //主营
    UIImageView* _certificationImage; //认证
    UIButton* _stateBtn;         //发布状态
}
@end

@implementation MySupplyAndDemandTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)setDetailModel:(GQSupplyAndBuyDetailModel *)detailModel
{
    _detailModel = detailModel;
    _companyName.text = detailModel.companyname;
    _label.text = [NSString stringWithFormat:@"%@:",detailModel.typeName];
    NSString* mainBussinessStr = detailModel.content;
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
    if ([detailModel.publishstatus isEqualToString:@"1"]) {
        [_stateBtn setTitle:@"取消发布" forState:UIControlStateNormal];
    }else if ([detailModel.publishstatus isEqualToString:@"0"]){
        [_stateBtn setTitle:@"重新发布" forState:UIControlStateNormal];
    }
    [_label setSingleLineAutoResizeWithMaxWidth:getNumWithScanf(260)];
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
    
    //发布状态
    _stateBtn = [[UIButton alloc]init];
    [_stateBtn setTitle:@"取消发布" forState:UIControlStateNormal];
    [_stateBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _stateBtn.backgroundColor = getColor(@"3fbefc");
    _stateBtn.titleLabel.font = DEF_FontSize_13;
    _stateBtn.layer.masksToBounds = YES;
    _stateBtn.layer.cornerRadius = 5;
    [_stateBtn addTarget:self action:@selector(stateBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_stateBtn];
    
    [self layout];
}

-(void)stateBtnDidClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(MySupplyAndDemandCellDidClick: withCell:)]) {
        [self.delegate MySupplyAndDemandCellDidClick:btn withCell:self];
    }
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
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(_bgView,getNumWithScanf(65));
    
    _label.sd_layout
    .topSpaceToView(_companyName,getNumWithScanf(20))
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26))
    .widthIs(getNumWithScanf(70));
    
    _mainBusinessLab.sd_layout
    .leftSpaceToView(_label,3)
    .topEqualToView(_label)
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(_bgView,getNumWithScanf(65));
    
    _certificationImage.sd_layout
    .rightSpaceToView(_bgView,getNumWithScanf(19))
    .widthIs(getNumWithScanf(42))
    .heightIs(getNumWithScanf(42))
    .topSpaceToView(_bgView,getNumWithScanf(19));
    
    _stateBtn.sd_layout
    .rightSpaceToView(_bgView,getNumWithScanf(20))
    .bottomSpaceToView(_bgView,getNumWithScanf(20))
    .widthIs(getNumWithScanf(260))
    .heightIs(getNumWithScanf(60));
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
