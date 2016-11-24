//
//  TopMenuView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "TopMenuView.h"

#define KTag 10
@interface TopMenuView ()
{
    UIButton* _allBtn;
    UIButton* _gongYingBtn;
    UIButton* _qiuGouBtn;
}
@end

@implementation TopMenuView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}

-(void)changeTextColorWithBtn:(UIButton*)btn
{
    UIView* Superview = [btn superview];
    for (UIView* view in Superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* selectBtn = (UIButton*)view;
            selectBtn.selected = NO;
        }
    }
    btn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(topViewMenuDidClickWithBtn:)]) {
        [self.delegate topViewMenuDidClickWithBtn:btn];
    }
}

-(void)creatSubViews
{
    _allBtn = [[UIButton alloc]init];
    [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [_allBtn setTitleColor:getColor(@"a6a6a6") forState:UIControlStateNormal];
    [_allBtn setTitleColor:getColor(@"3fbffb") forState:UIControlStateSelected];
    [_allBtn setImage:[UIImage imageNamed:@"quanbuSelect"] forState:UIControlStateSelected];
    [_allBtn setImage:[UIImage imageNamed:@"quanbuNormal"] forState:UIControlStateNormal];
    [_allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    _allBtn.titleLabel.font = DEF_FontSize_13;
    [_allBtn addTarget:self action:@selector(changeTextColorWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    _allBtn.tag = KTag + 1;
    _allBtn.selected = YES;
    [self addSubview:_allBtn];
    
    _gongYingBtn = [[UIButton alloc]init];
    [_gongYingBtn setTitle:@"供应" forState:UIControlStateNormal];
    [_gongYingBtn setTitleColor:getColor(@"a6a6a6") forState:UIControlStateNormal];
    [_gongYingBtn setTitleColor:getColor(@"3fbffb") forState:UIControlStateSelected];
    [_gongYingBtn setImage:[UIImage imageNamed:@"gongyingSelect"] forState:UIControlStateSelected];
    [_gongYingBtn setImage:[UIImage imageNamed:@"gongyingNormal"] forState:UIControlStateNormal];
    [_gongYingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_gongYingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    _gongYingBtn.titleLabel.font = DEF_FontSize_13;
    _gongYingBtn.tag = KTag + 2;
    [_gongYingBtn addTarget:self action:@selector(changeTextColorWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gongYingBtn];
    
    _qiuGouBtn = [[UIButton alloc]init];
    [_qiuGouBtn setTitle:@"求购" forState:UIControlStateNormal];
    [_qiuGouBtn setTitleColor:getColor(@"a6a6a6") forState:UIControlStateNormal];
    [_qiuGouBtn setTitleColor:getColor(@"3fbffb") forState:UIControlStateSelected];
    [_qiuGouBtn setImage:[UIImage imageNamed:@"qiugouSelect"] forState:UIControlStateSelected];
    [_qiuGouBtn setImage:[UIImage imageNamed:@"qiugouNormal"] forState:UIControlStateNormal];
    [_qiuGouBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_qiuGouBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_qiuGouBtn addTarget:self action:@selector(changeTextColorWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    _qiuGouBtn.titleLabel.font = DEF_FontSize_13;
    _qiuGouBtn.tag = KTag + 3;
    [self addSubview:_qiuGouBtn];
    
    UIView* firstLineView = [[UIView alloc]init];
    firstLineView.backgroundColor = getColor(@"abe5fe");
    [self addSubview:firstLineView];
    
    UIView* secondLineView = [[UIView alloc]init];
    secondLineView.backgroundColor = getColor(@"abe5fe");
    [self addSubview:secondLineView];
    
    UIView* bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = getColor(@"3ebdfb");
    [self addSubview:bottomLineView];
    
    bottomLineView.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .heightIs(1);
    
    _allBtn.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,1)
    .widthIs((SCREEN_WIDTH - 2)/3);
    
    firstLineView.sd_layout
    .leftSpaceToView(_allBtn,0)
    .topSpaceToView(self,getNumWithScanf(22))
    .bottomSpaceToView(self,getNumWithScanf(22))
    .widthIs(1);
    
    _gongYingBtn.sd_layout
    .leftSpaceToView(firstLineView,0)
    .widthIs((SCREEN_WIDTH - 2)/3)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,1);
    
    secondLineView.sd_layout
    .leftSpaceToView(_gongYingBtn,0)
    .topSpaceToView(self,getNumWithScanf(22))
    .bottomSpaceToView(self,getNumWithScanf(22))
    .widthIs(1);
    
    _qiuGouBtn.sd_layout
    .leftSpaceToView(secondLineView,0)
    .widthIs((SCREEN_WIDTH - 2)/3)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
