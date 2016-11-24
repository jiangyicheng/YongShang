//
//  AlertView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()

{
    UIButton* _confirmBtn;
    UIButton* _cancleBtn;
    UIView* _horizontalLineView;
    UIView* _verticalLineView;
}

@end

@implementation AlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _contentlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/5*3)];
        _contentlab.textColor = getColor(@"595959");
        _contentlab.textAlignment = NSTextAlignmentCenter;
        _contentlab.font = DEF_FontSize_12;
        [self addSubview:_contentlab];
        
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height/5*3, frame.size.width/2, frame.size.height/5*2)];
        _confirmBtn.backgroundColor = [UIColor clearColor];
        _confirmBtn.titleLabel.font = DEF_FontSize_13;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitleColor:getColor(@"595959") forState:UIControlStateNormal];
        [self addSubview:_confirmBtn];
        
        _cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/5*3, frame.size.width/2, frame.size.height/5*2)];
        _cancleBtn.backgroundColor = [UIColor clearColor];
        _cancleBtn.titleLabel.font = DEF_FontSize_13;
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setTitleColor:getColor(@"3fbefc") forState:UIControlStateNormal];
        [self addSubview:_cancleBtn];
        
        _horizontalLineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/5*3, frame.size.width, 0.5)];
        _horizontalLineView.backgroundColor = getColor(@"dddddd");
        [self addSubview:_horizontalLineView];
        
        _verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/5*3, 0.5, frame.size.height/5*2)];
        _verticalLineView.backgroundColor = getColor(@"dddddd");
        [self addSubview:_verticalLineView];
    }
    return self;
}

-(void)confirmBtnDidClick
{
    if ([self.delegate respondsToSelector:@selector(alertViewConfirmBtnClick)]) {
        [self.delegate alertViewConfirmBtnClick];
    }
}

-(void)cancleBtnDidClick
{
    if ([self.delegate respondsToSelector:@selector(alertViewCancleBtnClick)]) {
        [self.delegate alertViewCancleBtnClick];
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
