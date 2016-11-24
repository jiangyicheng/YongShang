//
//  Config.m
//  TianjinBoHai
//
//  Created by 李莹 on 15/1/16.
//  Copyright (c) 2015年 Binky Lee. All rights reserved.
//

#import "Config.h"

/**
 *  风格橙色
 */
NSString *orangeColor = @"ff7d02";


@implementation Config
UIColor* getColor(NSString * hexColor)
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

UIFont * globalFont(CGFloat size){
    return [UIFont systemFontOfSize:size + (SCREEN_WIDTH / 320 - 1) * 2];
}

CGFloat getNumWithScanf(CGFloat measureNum)
{
    return measureNum/2/WIDTH_5S_SCALE;
}

@end
