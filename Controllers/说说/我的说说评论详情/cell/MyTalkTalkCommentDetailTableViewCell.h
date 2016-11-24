//
//  MyTalkTalkCommentDetailTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/9.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTalkTalkDetailModel.h"

@protocol DeleteCommentDelegate <NSObject>

@optional
-(void)commentDidDelete;

@end

@interface MyTalkTalkCommentDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic,strong) SSTalkTalkDetailModel* model;
@property (nonatomic,assign) id<DeleteCommentDelegate> delegate;

@end
