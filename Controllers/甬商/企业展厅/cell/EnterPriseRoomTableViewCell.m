//
//  EnterPriseRoomTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseRoomTableViewCell.h"

@interface EnterPriseRoomTableViewCell ()
{
    UIView* _bgView;            //背景view
    UILabel* _companyName;      //公司名称
    UILabel* _label;            //主营（不变）
    UILabel* _mainBusinessLab;  //主营
    UIImageView* _certificationImage; //认证
    UILabel* _unPasslabel;      //未通过
}
@end

@implementation EnterPriseRoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

-(void)setGongqiuStr:(NSString *)gongqiuStr
{
    _gongqiuStr = gongqiuStr;
    _label.text = _gongqiuStr;
}

/**
 *  企业展厅
 *
 *  @param model model
 */
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
    [_label setSingleLineAutoResizeWithMaxWidth:getNumWithScanf(260)];
}

/**
 *  好友企业
 *
 *  @param friendModel model
 */
-(void)setFriendModel:(YSEnterPriseRoomModel *)friendModel
{
    _friendModel = friendModel;
    _companyName.text = friendModel.companyname;
    NSString* mainBussinessStr = friendModel.mainbusiness;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _mainBusinessLab.text = mainBussinessStr;
    if ([friendModel.status isEqualToString:@"0"]) {
        _certificationImage.hidden = YES;
    }else if ([friendModel.status isEqualToString:@"1"]){
        _certificationImage.hidden = YES;
    }else if ([friendModel.status isEqualToString:@"2"])
    {
        _certificationImage.hidden = NO;
    }
    
    if ([friendModel.type isEqualToString:@"11"]||[friendModel.type isEqualToString:@"1"]) {
        _companyName.textColor = getColor(@"fe9493");
        _label.textColor = getColor(@"fe9493");
        _mainBusinessLab.textColor = getColor(@"fe9493");
    }else
    {
        _companyName.textColor = getColor(@"595959");
        _label.textColor = getColor(@"595959");
        _mainBusinessLab.textColor = getColor(@"595959");
    }
    [_label setSingleLineAutoResizeWithMaxWidth:getNumWithScanf(260)];
}

/**
 *  企业圈子详情
 *
 *  @param detailModel
 */
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
    NSLog(@"detailModel.qzstatus---%@",detailModel.qzstatus);
    if ([detailModel.qzstatus isEqualToString:@"1"]) {
        //待验证
        _companyName.textColor = getColor(@"fe9493");
        _label.textColor = getColor(@"fe9493");
        _mainBusinessLab.textColor = getColor(@"fe9493");
        _unPasslabel.hidden = NO;
    }else {
        //接受邀请
        _companyName.textColor = getColor(@"595959");
        _label.textColor = getColor(@"595959");
        _mainBusinessLab.textColor = getColor(@"595959");
        _unPasslabel.hidden = YES;
    }
    [_label setSingleLineAutoResizeWithMaxWidth:getNumWithScanf(260)];
}

-(void)setGQModel:(GQSupplyAndBuyDetailModel *)GQModel
{
    _GQModel = GQModel;
    _companyName.text = GQModel.companyname;
    NSString* mainBussinessStr = GQModel.content;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _mainBusinessLab.text = mainBussinessStr;
    _label.text = [NSString stringWithFormat:@"%@:",GQModel.typeName];
    [_label setSingleLineAutoResizeWithMaxWidth:getNumWithScanf(260)];
    if ([GQModel.status isEqualToString:@"0"]) {
        _certificationImage.hidden = YES;
    }else if ([GQModel.status isEqualToString:@"1"]){
        _certificationImage.hidden = YES;
    }else if ([GQModel.status isEqualToString:@"2"])
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
    
    //未通过
    _unPasslabel = [[UILabel alloc]init];
    _unPasslabel.textColor = getColor(@"fe9493");
    _unPasslabel.font = DEF_FontSize_12;
    _unPasslabel.textAlignment = NSTextAlignmentRight;
    _unPasslabel.text = @"未通过";
    _unPasslabel.hidden = YES;
    [_bgView addSubview:_unPasslabel];
    
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
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(_bgView,getNumWithScanf(65));
    
    _label.sd_layout
    .bottomSpaceToView(_bgView,getNumWithScanf(30))
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(26));
    
    _mainBusinessLab.sd_layout
    .leftSpaceToView(_label,3)
    .topEqualToView(_label)
    .heightIs(getNumWithScanf(26))
    .rightSpaceToView(_bgView,getNumWithScanf(95));
    
    _certificationImage.sd_layout
    .rightSpaceToView(_bgView,getNumWithScanf(19))
    .widthIs(getNumWithScanf(42))
    .heightIs(getNumWithScanf(42))
    .topSpaceToView(_bgView,getNumWithScanf(19));

    _unPasslabel.sd_layout
    .rightEqualToView(_certificationImage)
    .topEqualToView(_label)
    .heightIs(getNumWithScanf(26))
    .widthIs(getNumWithScanf(76));
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
