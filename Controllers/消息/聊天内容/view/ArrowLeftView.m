//
//  ArrowLeftView.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ArrowLeftView.h"

@implementation ArrowLeftView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, getColor(@"ffffff").CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextMoveToPoint(context, 0, 6);
    CGContextAddLineToPoint(context, 10, 0);
    CGContextAddLineToPoint(context, 10, 12);
    CGContextAddLineToPoint(context, 0, 6);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
