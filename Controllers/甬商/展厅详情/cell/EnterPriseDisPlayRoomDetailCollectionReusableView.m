//
//  EnterPriseDisPlayRoomDetailCollectionReusableView.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseDisPlayRoomDetailCollectionReusableView.h"
#import "MyLabel.h"

@interface EnterPriseDisPlayRoomDetailCollectionReusableView ()
{
    MyLabel* _companyLab;           //公司名称
    UILabel* _firstLab;             //企业归属（不变）
    UILabel* _secondLab;            //联系人（不变）
    UILabel* _thirdLab;             //联系电话（不变）
    UILabel* _newLab;               //联系地址（不变）
    UILabel* _fourthLab;            //主营业务（不变）
    UILabel* _fivthLab;             //产品图片（不变）
    UILabel* _belongsToLab;         //企业归属
    UILabel* _contactpeopleLab;     //联系人
    UILabel* _contactTelLab;        //联系电话
    MyLabel* _addressLab;           //联系地址
    MyLabel* _businessLab;          //主营业务
    CGFloat addressHeight;
}

@end

@implementation EnterPriseDisPlayRoomDetailCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self createSubViews];
        
        
    }
    return self;
}

-(void)setModel:(EnterPriseDetailModel *)model
{
    _model = model;
    _belongsToLab.text = model.tradename;
    _companyLab.text = model.companyName;
    
    NSString* contactPeopleStr = model.linkman;
    contactPeopleStr = [contactPeopleStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    _contactpeopleLab.text = contactPeopleStr;
    _contactTelLab.text = model.phone;
    
    NSString* mainBussinessStr = model.mainbusiness;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _businessLab.text = mainBussinessStr;
    
    _addressLab.text = model.linkaddress;
    addressHeight = MAX( [self kdetailTextHeight:model.linkaddress width:SCREEN_WIDTH - getNumWithScanf(194) - 5] , getNumWithScanf(26) );
    [self layout];
}

//根据字的个数确定labe的高
- (CGFloat)kdetailTextHeight:(NSString *)text width:(CGFloat)width{
    
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :DEF_FontSize_13} context:nil];
    return rectToFit.size.height;
}

-(void)createSubViews
{
    //公司名称
    _companyLab = [[MyLabel alloc]init];
    _companyLab.textColor = getColor(@"333333");
    _companyLab.font = DEF_FontSize_13;
    _companyLab.numberOfLines = 0;
//    _companyLab.backgroundColor = [UIColor redColor];
    _companyLab.textAlignment = NSTextAlignmentCenter;
//    _companyLab.textAlignment = NSTextAlignmentLeft;
    _companyLab.lineBreakMode = NSLineBreakByWordWrapping;
    [_companyLab setVerticalAlignment:VerticalAlignmentMiddle];
    
    _companyLab.text = @"上海科匠信息有限公司";
    [self addSubview:_companyLab];
    
    _firstLab = [[UILabel alloc]init];
    _firstLab.textColor = getColor(@"595959");
    _firstLab.font = DEF_FontSize_13;
    _firstLab.text = @"细分市场:";
    [self addSubview:_firstLab];
    
    _secondLab = [[UILabel alloc]init];
    _secondLab.textColor = getColor(@"595959");
    _secondLab.font = DEF_FontSize_13;
    _secondLab.text = @"联系人:";
    [self addSubview:_secondLab];
    
    _thirdLab = [[UILabel alloc]init];
    _thirdLab.textColor = getColor(@"595959");
    _thirdLab.font = DEF_FontSize_13;
    _thirdLab.text = @"联系电话:";
    [self addSubview:_thirdLab];
    
    _fourthLab = [[UILabel alloc]init];
    _fourthLab.textColor = getColor(@"595959");
    _fourthLab.font = DEF_FontSize_13;
    _fourthLab.text = @"主营业务:";
    [self addSubview:_fourthLab];
    
    _newLab = [[UILabel alloc]init];
    _newLab.textColor = getColor(@"595959");
    _newLab.font = DEF_FontSize_13;
    _newLab.text = @"联系地址:";
    [self addSubview:_newLab];
    
    _fivthLab = [[UILabel alloc]init];
    _fivthLab.textColor = getColor(@"595959");
    _fivthLab.font = DEF_FontSize_13;
    _fivthLab.text = @"产品图片:";
    [self addSubview:_fivthLab];
    
    _belongsToLab = [[UILabel alloc]init];
    _belongsToLab.textColor = getColor(@"595959");
    _belongsToLab.font = DEF_FontSize_13;
    _belongsToLab.text = @"软件行业";
    [self addSubview:_belongsToLab];
    
    _contactpeopleLab = [[UILabel alloc]init];
    _contactpeopleLab.textColor = getColor(@"595959");
    _contactpeopleLab.font = DEF_FontSize_13;
    _contactpeopleLab.text = @"姜益达";
    [self addSubview:_contactpeopleLab];
    
    _contactTelLab = [[UILabel alloc]init];
    _contactTelLab.textColor = getColor(@"595959");
    _contactTelLab.font = DEF_FontSize_13;
    _contactTelLab.text = @"13130133045";
    [self addSubview:_contactTelLab];
    
    _businessLab = [[MyLabel alloc]init];
    _businessLab.textColor = getColor(@"595959");
    _businessLab.font = DEF_FontSize_13;
//    _businessLab.backgroundColor = [UIColor redColor];
    _businessLab.textAlignment = NSTextAlignmentLeft;
    _businessLab.lineBreakMode = NSLineBreakByWordWrapping;
    [_businessLab setVerticalAlignment:VerticalAlignmentTop];
    _businessLab.numberOfLines = 0;
    [self addSubview:_businessLab];
    
    _addressLab = [[MyLabel alloc]init];
    _addressLab.textColor = getColor(@"595959");
    _addressLab.font = DEF_FontSize_13;
    //    _businessLab.backgroundColor = [UIColor redColor];
    _addressLab.textAlignment = NSTextAlignmentLeft;
    _addressLab.lineBreakMode = NSLineBreakByWordWrapping;
    [_addressLab setVerticalAlignment:VerticalAlignmentTop];
    _addressLab.numberOfLines = 0;
    [self addSubview:_addressLab];
}

-(void)layout
{
    _companyLab.sd_layout
    .leftSpaceToView(self,getNumWithScanf(15))
    .rightSpaceToView(self,getNumWithScanf(15))
    .topSpaceToView(self,getNumWithScanf(10))
    .heightIs(getNumWithScanf(70));
    
    _firstLab.sd_layout
    .topSpaceToView(_companyLab,getNumWithScanf(10))
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(self,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130));
    
    _secondLab.sd_layout
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(self,getNumWithScanf(20))
    .topSpaceToView(_firstLab,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130));
    
    _belongsToLab.sd_layout
    .topEqualToView(_firstLab)
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(_firstLab,5)
    .rightSpaceToView(self,getNumWithScanf(20));
    
    _thirdLab.sd_layout
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(self,getNumWithScanf(20))
    .topSpaceToView(_secondLab,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130));
    
    _contactpeopleLab.sd_layout
    .topEqualToView(_secondLab)
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(_secondLab,5)
    .rightSpaceToView(self,getNumWithScanf(20));
    
    _contactTelLab.sd_layout
    .topEqualToView(_thirdLab)
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(_thirdLab,5)
    .rightSpaceToView(self,getNumWithScanf(20));
    
    _newLab.sd_layout
    .topSpaceToView(_thirdLab,getNumWithScanf(20))
    .leftSpaceToView(self,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130))
    .heightIs(getNumWithScanf(28));
    
    _addressLab.sd_layout
    .topSpaceToView(_thirdLab,getNumWithScanf(17))
    .leftSpaceToView(_newLab,5)
    .rightSpaceToView(self,getNumWithScanf(20))
    .heightIs(addressHeight);
    
    _fourthLab.sd_layout
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(self,getNumWithScanf(20))
    .topSpaceToView(_addressLab,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130));
    
    _fivthLab.sd_layout
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(self,getNumWithScanf(20))
    .bottomSpaceToView(self,getNumWithScanf(30))
    .widthIs(getNumWithScanf(130));
    
    _businessLab.sd_layout
    .topSpaceToView(_addressLab,getNumWithScanf(17))
    .bottomSpaceToView(_fivthLab,getNumWithScanf(20))
    .leftSpaceToView(_fourthLab,5)
    .rightSpaceToView(self,getNumWithScanf(20));
    
    
    
}







@end
