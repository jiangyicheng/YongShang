//
//  DeleteAndStickChatView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "DeleteAndStickChatView.h"


@implementation DeleteAndStickChatView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = getColor(@"ffffff");
        
        _stickChatBtn = [[UIButton alloc]init];
        _stickChatBtn.backgroundColor = [UIColor clearColor];
        [_stickChatBtn setTitleColor:getColor(@"595959") forState:UIControlStateNormal];
        _stickChatBtn.titleLabel.font = DEF_FontSize_14;
        [_stickChatBtn setTitle:@"置顶聊天" forState:UIControlStateNormal];
        [_stickChatBtn addTarget:self action:@selector(stickChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _stickChatBtn.hidden = YES;
        [self addSubview:_stickChatBtn];
        
        _deleteChatBtn = [[UIButton alloc]init];
        _deleteChatBtn.backgroundColor = [UIColor clearColor];
        [_deleteChatBtn setTitleColor:getColor(@"595959") forState:UIControlStateNormal];
        _deleteChatBtn.titleLabel.font = DEF_FontSize_14;
        [_deleteChatBtn setTitle:@"删除聊天" forState:UIControlStateNormal];
        [_deleteChatBtn addTarget:self action:@selector(deleteChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteChatBtn.hidden = YES;
        [self addSubview:_deleteChatBtn];
        
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = getColor(@"dddddd");
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .heightIs(0.5)
        .centerYEqualToView(self);
        
        _stickChatBtn.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(self,0)
        .bottomSpaceToView(lineView,0);
        
        _deleteChatBtn.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(lineView,0)
        .bottomSpaceToView(self,0);
    }
    return self;
}

-(void)stickChatBtnClick
{
    if ([self.delegate respondsToSelector:@selector(firstStickBtnDidSelect)]) {
        [self.delegate firstStickBtnDidSelect];
    }
}

-(void)deleteChatBtnClick
{
    if ([self.delegate respondsToSelector:@selector(secondDeleteBtnDidSelect)]) {
        [self.delegate secondDeleteBtnDidSelect];
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
