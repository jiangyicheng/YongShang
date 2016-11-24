//
//  CellFrameModel.m
//  XinChengOA
//
//  Created by 姜易成 on 16/7/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "CellFrameModel.h"
#import "MessageModel.h"
#import "NSString+Extension.h"
#import "Config.h"

#define timeH 40
#define padding 10
#define iconW 35
#define iconH 35
#define textW 190

@implementation CellFrameModel

-(void)setMessage:(MessageModel *)message
{
    _message = message;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的frame
    if (message.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //2.头像的frame
    CGFloat iconFrameX = message.type ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //3.内容frame
    // MAXFLOAT 代表高度是随着内容的改表而变化的
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGSize textSize = [message.text sizeWithFont:DEF_FontSize_12 maxSize:textMaxSize];
    CGSize textRealSize = CGSizeMake(textSize.width+textPadding*2, textSize.height+textPadding);
    CGFloat textFrameY = iconFrameY;
    CGFloat textFrameX = message.type ? (2 * padding  + iconW) : (frame.size.width - (padding * 2 + iconFrameW + textRealSize.width));
    if ([message.messageType isEqualToString:@"0"]) {
        _textFrame = (CGRect){textFrameX,textFrameY,textRealSize};
    }else if ([message.messageType isEqualToString:@"1"]){
        CGSize textSize = CGSizeMake(getNumWithScanf(150), getNumWithScanf(150));
        CGFloat textX = message.type ? (2 * padding  + iconW) : (frame.size.width - (padding * 2 + iconFrameW + textSize.width));
        _textFrame = (CGRect){textX,textFrameY,textSize};
    }
    
    NSLog(@"聊天状态（1代表别人发给我 0代表我发给别人）----%d",message.type);
    
    //箭头的frame
    CGFloat arrowFrameX = message.type ? CGRectGetMinX(_textFrame) - 10 : CGRectGetMaxX(_textFrame);
    CGFloat arrowFrameY = CGRectGetMinY(_textFrame) + 9;
    _arrowFrame = CGRectMake(arrowFrameX, arrowFrameY, 10, 12);
    
    //4.cell的高度
    _cellHeght = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)+padding);
    
}

@end
