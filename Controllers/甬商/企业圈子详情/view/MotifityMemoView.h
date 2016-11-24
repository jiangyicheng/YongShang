//
//  MotifityMemoView.h
//  YongShang
//
//  Created by 姜易成 on 16/11/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotifityMemoDelegate <NSObject>

@optional
-(void)MotifityMemoDidSelect;

@end

@interface MotifityMemoView : UIView

@property (nonatomic,strong) PlaceHoderTextView* memoTextView;
@property (nonatomic,strong) UIButton* confirmBtn;
@property (nonatomic,strong) UILabel* titleLab;
@property (nonatomic,assign) id<MotifityMemoDelegate> delegate;

@end
