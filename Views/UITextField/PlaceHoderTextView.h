//
//  PlaceHoderTextView.h
//  自定义的UITextView
//
//  Created by 姜易成 on 16/8/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHoderTextView : UITextView

/**
 *  占位文字
 */
@property (nonatomic,copy) NSString* placeHoder;

/**
*  占位文字的颜色
*/
@property (nonatomic,strong) UIColor* placeHoderColor;

@end
