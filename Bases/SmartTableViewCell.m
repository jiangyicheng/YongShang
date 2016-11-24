//
//  SmartTableViewCell.m
//  PaintingAddiction
//
//  Created by 李莹 on 14-4-8.
//  Copyright (c) 2014年 Binly Lee. All rights reserved.
//

#import "SmartTableViewCell.h"

@implementation SmartTableViewCell

+(NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

+ (id)cellForTableView:(UITableView *)tableView{
    
    NSString *cellID = [self cellIdentifier];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithCellIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (id) initWithCellIdentifier:(NSString *)cellID{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
}

+ (CGFloat) heightForCellWithContent:(id)content{
    return 60;
}

- (NSMutableAttributedString *) changeStringColorWithPlaceString:(NSString *)placeString changeColorString:(NSString*)changeColorString color:(NSString *)color
{
    NSRange range = [placeString rangeOfString:changeColorString];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:placeString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:getColor(color) range:range];
    
    return attributedString;
}

- (CGFloat)kdetailTextHeight:(NSString *)text width:(CGFloat)width{
    
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :DEF_FontSize_13} context:nil];
    return rectToFit.size.height;
}

@end
