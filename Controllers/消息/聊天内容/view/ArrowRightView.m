//
//  ArrowRightView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ArrowRightView.h"

@implementation ArrowRightView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, getColor(@"ceedfc").CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 10, 6);
    CGContextAddLineToPoint(ctx, 0, 12);
    CGContextAddLineToPoint(ctx, 0, 0);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}


@end
