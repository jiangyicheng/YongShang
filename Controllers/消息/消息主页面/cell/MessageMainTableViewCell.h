//
//  MessageMainTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMainModel.h"

@protocol longTouchTheCellDelegate <NSObject>

@optional
-(void)longTouchTheCellWithCell:(UITableViewCell*)cell andGesture:(UILongPressGestureRecognizer*)longTouch;

@end

@interface MessageMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;

@property (nonatomic,assign) id<longTouchTheCellDelegate> delegate;
@property (nonatomic,strong) MessageMainModel* model;
@property (nonatomic,strong) UIImageView* imageViews;
@end
