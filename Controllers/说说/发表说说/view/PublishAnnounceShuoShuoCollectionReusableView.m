//
//  PublishAnnounceShuoShuoCollectionReusableView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "PublishAnnounceShuoShuoCollectionReusableView.h"
#define MAX_LIMIT_NUMS  1000     //来限制最大输入只能1000个字符
@interface PublishAnnounceShuoShuoCollectionReusableView ()<UITextViewDelegate>

@end

@implementation PublishAnnounceShuoShuoCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self CreateSubviews];
    }
    return self;
}

-(void)CreateSubviews
{
    _personImageBtn = [[UIImageView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(20), getNumWithScanf(82), getNumWithScanf(82))];
    _personImageBtn.layer.cornerRadius = getNumWithScanf(41);
    _personImageBtn.layer.masksToBounds = YES;
    [self addSubview:_personImageBtn];
    
    _nameAndCompanyLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(122), getNumWithScanf(30), SCREEN_WIDTH - getNumWithScanf(142), getNumWithScanf(26))];
    _nameAndCompanyLab.font = DEF_FontSize_12;
    _nameAndCompanyLab.textColor = getColor(@"595959");
    _nameAndCompanyLab.text = [NSString stringWithFormat:@"%@",[UserModel shareInstanced].name];
    [self addSubview:_nameAndCompanyLab];
    
    _companyLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(122), getNumWithScanf(56), SCREEN_WIDTH - getNumWithScanf(142), getNumWithScanf(40))];
    _companyLab.font = DEF_FontSize_12;
    _companyLab.textColor = getColor(@"595959");
    _companyLab.text = [NSString stringWithFormat:@"%@",[UserModel shareInstanced].nickName];
    [self addSubview:_companyLab];
    
    _publishContentTextField = [[PlaceHoderTextView alloc]init];
    _publishContentTextField.placeHoder = @"输入要发表的内容～";
    _publishContentTextField.placeHoderColor = getColor(@"999999");
    _publishContentTextField.font = DEF_FontSize_12;
    _publishContentTextField.layer.cornerRadius = 5;
    _publishContentTextField.delegate = self;
    _publishContentTextField.layer.masksToBounds = YES;
    _publishContentTextField.layer.borderColor = getColor(@"dddddd").CGColor;
    _publishContentTextField.layer.borderWidth = 0.5;
    [self addSubview:_publishContentTextField];
    
    _publishContentTextField.sd_layout
    .leftEqualToView(_nameAndCompanyLab)
    .topSpaceToView(_companyLab,5)
    .rightSpaceToView(self,getNumWithScanf(20))
    .bottomSpaceToView(self,10);
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }else{
        return NO;
    }
}

@end
