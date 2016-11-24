//
//  EnterPriseDisPlayRoomDetailCollectionViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseDisPlayRoomDetailCollectionViewCell.h"

@interface EnterPriseDisPlayRoomDetailCollectionViewCell ()

@end

@implementation EnterPriseDisPlayRoomDetailCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.enterPriseShowPictureView = [[UIImageView alloc]initWithFrame:self.bounds];
//        self.enterPriseShowPictureView.image = [UIImage imageNamed:@"haoyouqiye"];
        [self.contentView addSubview:self.enterPriseShowPictureView];
        
    }
    return self;
}

@end
