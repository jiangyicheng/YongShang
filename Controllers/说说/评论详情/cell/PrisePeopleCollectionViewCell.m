//
//  PrisePeopleCollectionViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "PrisePeopleCollectionViewCell.h"

@implementation PrisePeopleCollectionViewCell

- (void)awakeFromNib {
    _personImage.layer.masksToBounds = YES;
    _personImage.layer.cornerRadius = getNumWithScanf(52/2);
}

-(void)setPersonImage:(UIImageView *)personImage
{
    _personImage = personImage;
    
}

@end
