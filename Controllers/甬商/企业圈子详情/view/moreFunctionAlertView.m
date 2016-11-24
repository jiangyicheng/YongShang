//
//  moreFunctionAlertView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "moreFunctionAlertView.h"

@interface moreFunctionAlertView ()

@end

@implementation moreFunctionAlertView

-(void)setFirstBtnString:(NSString *)firstBtnString
{
    _firstBtnString = firstBtnString;
    [_addNewEpBtn setTitle:_firstBtnString forState:UIControlStateNormal];
}

-(void)setSecondBtnString:(NSString *)secondBtnString
{
    _secondBtnString = secondBtnString;
    [_deleteEpBtn setTitle:self.secondBtnString forState:UIControlStateNormal];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = getColor(@"545454");
        
        _addNewEpBtn = [[UIButton alloc]init];
        _addNewEpBtn.backgroundColor = [UIColor clearColor];
        [_addNewEpBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        _addNewEpBtn.titleLabel.font = DEF_FontSize_14;
        [_addNewEpBtn addTarget:self action:@selector(addNewEnterPriseClick) forControlEvents:UIControlEventTouchUpInside];
        [_addNewEpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [self addSubview:_addNewEpBtn];
        
        _deleteEpBtn = [[UIButton alloc]init];
        _deleteEpBtn.backgroundColor = [UIColor clearColor];
        [_deleteEpBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        _deleteEpBtn.titleLabel.font = DEF_FontSize_14;
        [_deleteEpBtn addTarget:self action:@selector(deleteEnterPriseClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteEpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [self addSubview:_deleteEpBtn];
        
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = getColor(@"808080");
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .heightIs(0.5)
        .centerYEqualToView(self);
        
        _addNewEpBtn.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(self,0)
        .bottomSpaceToView(lineView,0);
        
        _deleteEpBtn.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(lineView,0)
        .bottomSpaceToView(self,0);
    }
    return self;
}

-(void)addNewEnterPriseClick
{
    if ([self.delegate respondsToSelector:@selector(firstfunctionDidSelect)]) {
        [self.delegate firstfunctionDidSelect];
    }
}

-(void)deleteEnterPriseClick
{
    if ([self.delegate respondsToSelector:@selector(secondFunctionDidSelect)]) {
        [self.delegate secondFunctionDidSelect];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
