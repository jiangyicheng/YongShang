//
//  CellFrameModel.h
//  XinChengOA
//
//  Created by 姜易成 on 16/7/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MessageModel;

#define textPadding 15

@interface CellFrameModel : NSObject

@property (nonatomic,strong) MessageModel* message;

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeght;
@property (nonatomic, assign, readonly) CGRect arrowFrame;

@end
