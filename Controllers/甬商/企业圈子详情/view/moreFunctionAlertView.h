//
//  moreFunctionAlertView.h
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreFunctionDelegate <NSObject>

@optional
-(void)firstfunctionDidSelect;
-(void)secondFunctionDidSelect;

@end

@interface moreFunctionAlertView : UIView

@property (nonatomic,strong) UIButton* addNewEpBtn;
@property (nonatomic,strong) UIButton* deleteEpBtn;
@property (nonatomic,strong) NSString* firstBtnString;
@property (nonatomic,strong) NSString* secondBtnString;

@property (nonatomic,assign) id<MoreFunctionDelegate>  delegate;

@end
