//
//  MotifityMemoView.m
//  YongShang
//
//  Created by 姜易成 on 16/11/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MotifityMemoView.h"

@implementation MotifityMemoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, getNumWithScanf(80))];
        _titleLab.text = @"修改圈子备注";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = DEF_FontSize_13;
        [self addSubview:_titleLab];
        
        _memoTextView = [[PlaceHoderTextView alloc]initWithFrame:CGRectMake(15, getNumWithScanf(80), self.frame.size.width - 30, self.frame.size.height - getNumWithScanf(190))];
        _memoTextView.placeHoder = @"输入内容～";
        _memoTextView.placeHoderColor = getColor(@"999999");
        _memoTextView.layer.masksToBounds = YES;
        _memoTextView.layer.cornerRadius = 5;
        _memoTextView.layer.borderWidth = 0.5;
        _memoTextView.layer.borderColor = getColor(@"e6e6e6").CGColor;
        _memoTextView.textColor = getColor(@"333333");
        [self addSubview:_memoTextView];
        
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - getNumWithScanf(90), self.frame.size.width - 30, getNumWithScanf(70))];
        [_confirmBtn setTitle:@"修改备注" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = getColor(@"3fbefc");
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn addTarget:self action:@selector(quitBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = DEF_FontSize_13;
        [self addSubview:_confirmBtn];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenKeyBoard)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)hidenKeyBoard
{
    [_memoTextView resignFirstResponder];
}

-(void)quitBtnDidClick
{
    if ([self.delegate respondsToSelector:@selector(MotifityMemoDidSelect)]) {
        [self.delegate MotifityMemoDidSelect];
    }
}


@end
