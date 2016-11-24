//
//  CommentDetailTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTalkTalkCommonDetailModel.h"

@protocol longTouchTheCommentDelegate <NSObject>

@optional
-(void)longTouchTheCommentWithCell:(UITableViewCell*)cell andGesture:(UILongPressGestureRecognizer*)longTouch;

@end

@interface CommentDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;


@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (nonatomic,assign) id<longTouchTheCommentDelegate> delegate;

@property (nonatomic,strong) SSTalkTalkCommonDetailModel* commentModel;

@end
