//
//  MyLabel.h
//  label 内容居上
//
//  Created by 姜易成 on 16/8/15.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyLabel : UILabel

{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
