//
//  FaceKeyBoardView.h
//  自定义键盘
//
//  Created by 姜易成 on 16/8/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义对应的block类型，用于数据的交互
typedef void (^FunctionBlock) (UIImage *image, NSString *imageText);

@protocol FaceDidSelectedDelegate <NSObject>

//选中表情
-(void)faceDidSelected:(UIButton*)btn;

//发送表情
-(void)sendFace:(UIButton*)btn;

//删除表情
-(void)deletFace:(UIButton*)btn;

@end

@interface FaceKeyBoardView : UIView

@property (nonatomic,assign) id<FaceDidSelectedDelegate> delegate;
@property (strong, nonatomic) FunctionBlock block;

-(void)setFunctionBlock:(FunctionBlock) block;

@end
