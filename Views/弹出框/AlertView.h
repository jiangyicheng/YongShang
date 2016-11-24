//
//  AlertView.h
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject>

@optional
-(void)alertViewConfirmBtnClick;
-(void)alertViewCancleBtnClick;

@end
@interface AlertView : UIView

@property (nonatomic,strong) UILabel* contentlab;
@property (nonatomic,assign) id<AlertViewDelegate> delegate;

@end
