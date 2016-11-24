//
//  PlaceHoderTextView.m
//  自定义的UITextView
//
//  Created by 姜易成 on 16/8/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "PlaceHoderTextView.h"

@implementation PlaceHoderTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        //设置默认字体的颜色
        self.font = DEF_FontSize_12;
        //设置默认颜色
        self.placeHoderColor = [UIColor grayColor];
        
        //使用通知监听文字改变
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)textDidChange:(NSNotification*)noti
{
    //会重新调用drawRect:方法
    [self setNeedsDisplay];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 *  每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect {
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) {
        return;
    }
    
    //属性
    NSMutableDictionary* attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeHoderColor;
    
    //画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeHoder drawInRect:rect withAttributes:attrs];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

-(void)setPlaceHoder:(NSString *)placeHoder
{
    _placeHoder = placeHoder;
    [self setNeedsDisplay];
}

-(void)setPlaceHoderColor:(UIColor *)placeHoderColor
{
    _placeHoderColor = placeHoderColor;
    [self setNeedsDisplay];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}


@end
