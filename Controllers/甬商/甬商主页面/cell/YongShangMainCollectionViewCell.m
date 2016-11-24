//
//  YongShangMainCollectionViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YongShangMainCollectionViewCell.h"

@implementation YongShangMainCollectionViewCell

-(void)setCellNameLab:(UILabel *)cellNameLab
{
    _cellNameLab = cellNameLab;
    _cellNameLab.font = DEF_FontSize_12;
    _cellNameLab.textColor = getColor(@"343434");
}

- (void)awakeFromNib {
    // Initialization code
}

@end
