//
//  DeleteAndStickChatView.h
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteAndStickDelegate <NSObject>

@optional
-(void)firstStickBtnDidSelect;
-(void)secondDeleteBtnDidSelect;

@end

@interface DeleteAndStickChatView : UIView

@property (nonatomic,strong) UIButton* stickChatBtn;
@property (nonatomic,strong) UIButton* deleteChatBtn;

@property (nonatomic,assign) id<DeleteAndStickDelegate> delegate;

@end
