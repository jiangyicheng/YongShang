//
//  TopMenuView.h
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopMenuViewDelegate <NSObject>

@optional
-(void)topViewMenuDidClickWithBtn:(UIButton*)btn;

@end

@interface TopMenuView : UIView

@property (nonatomic,assign) id<TopMenuViewDelegate> delegate;

@end
