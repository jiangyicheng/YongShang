//
//  ShuoShuoTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/6.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAllTalkDetailModel.h"
#import "CommentAndPriseView.h"

@protocol DeleteTalkTalkDelegate <NSObject>

@optional
-(void)deleteTalkTalkWithCell:(UITableViewCell*)cell;
-(void)PriseTheTalkTalkWithCell:(UITableViewCell*)cell WithBtn:(UIButton*)btn;
-(void)CommentTheTalkTalkWithCell:(UITableViewCell*)cell WithBtn:(UIButton*)btn;
-(void)enterPriseDetailWithCell:(UITableViewCell*)cell;

@end

@interface ShuoShuoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameAndCompanyLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,strong) SSAllTalkDetailModel* model;
@property (nonatomic,strong) CommentAndPriseView* commentAndPrise;
@property (nonatomic,assign) id<DeleteTalkTalkDelegate> delegate;

@end
