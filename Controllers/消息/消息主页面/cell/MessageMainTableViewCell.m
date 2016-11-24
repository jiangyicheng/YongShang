//
//  MessageMainTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MessageMainTableViewCell.h"

@interface MessageMainTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *personNameLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLabHeight;

@end

@implementation MessageMainTableViewCell


-(void)setPersonNameLab:(UILabel *)personNameLab
{
    _personNameLab = personNameLab;
    _personNameLab.font = DEF_FontSize_12;
}

-(void)setMessageLab:(UILabel *)messageLab
{
    _messageLab =messageLab;
    _messageLab.font = DEF_FontSize_11;
}

-(void)setDateLab:(UILabel *)dateLab
{
    _dateLab = dateLab;
    _dateLab.font = DEF_FontSize_9;
}
-(void)setLineLabHeight:(NSLayoutConstraint *)lineLabHeight
{
    _lineLabHeight = lineLabHeight;
    _lineLabHeight.constant = 0.5;
}


- (void)awakeFromNib {
    //给cell添加长按手势
    UILongPressGestureRecognizer* longTouch = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTouchTheCell:)];
    longTouch.minimumPressDuration = 0.7;
    [self addGestureRecognizer:longTouch];
    
    self.imageViews = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imageViews];
    
    self.imageViews.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthEqualToHeight(0);

}
-(void)setModel:(MessageMainModel *)model
{
    _personNameLab.text = model.contactname;
    _messageLab.text = model.content;
    _dateLab.text = model.time;
//    NSLog(@"%@",model.portal);
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:model.portal] placeholderImage:[UIImage imageNamed:@"noPerson"]];
}

-(void)longTouchTheCell:(UILongPressGestureRecognizer*)longTouch
{
    if ([self.delegate respondsToSelector:@selector(longTouchTheCellWithCell:andGesture:)]) {
        [self.delegate longTouchTheCellWithCell:self andGesture:longTouch];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
