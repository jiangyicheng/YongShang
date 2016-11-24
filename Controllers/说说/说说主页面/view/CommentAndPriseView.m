//
//  CommentAndPriseView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/6.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "CommentAndPriseView.h"

@interface CommentAndPriseView ()
{
    UIView* _topLineView;
    UIView* _vertivalLineView;
}
@end

@implementation CommentAndPriseView

-(void)creatCommentAndPriseView
{
    _topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 5)];
    _topLineView.backgroundColor = getColor(@"dbdbdb");
    
    _vertivalLineView = [[UIView alloc]init];
    _vertivalLineView.backgroundColor = getColor(@"dbdbdb");
    [self addSubview:_vertivalLineView];
    
    _commentBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - getNumWithScanf(120))/2, self.frame.origin.y+1, getNumWithScanf(120), getNumWithScanf(69))];
    [_commentBtn setTitle:@"20" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:getColor(@"878787") forState:UIControlStateNormal];
    [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_commentBtn setImage:[UIImage imageNamed:@"liuyanNormal"] forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:@"liuyan"] forState:UIControlStateSelected];
    [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    _commentBtn.userInteractionEnabled = NO;
    [self addSubview:_commentBtn];
    
    _priseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + (SCREEN_WIDTH/2 - getNumWithScanf(120))/2, self.frame.origin.y+1, getNumWithScanf(120), getNumWithScanf(69))];
    [_priseBtn setTitle:@"45" forState:UIControlStateNormal];
    [_priseBtn setTitleColor:getColor(@"878787") forState:UIControlStateNormal];
    [_priseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_priseBtn setImage:[UIImage imageNamed:@"zanNormal"] forState:UIControlStateNormal];
    [_priseBtn setImage:[UIImage imageNamed:@"zanSelected"] forState:UIControlStateSelected];
    [_priseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self addSubview:_priseBtn];
    [self addSubview:_topLineView];
    
    _vertivalLineView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(_topLineView,getNumWithScanf(15))
    .bottomSpaceToView(self,getNumWithScanf(15))
    .widthIs(0.7);
    
    _topLineView.sd_layout
    .topSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .heightIs(0.7);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
