//
//  MyShuoShuoTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAllTalkDetailModel.h"
#import "CommentAndPriseView.h"

@protocol DeleteMyTalkTalkDelegate <NSObject>

@optional

-(void)deleteTalkTalkWithCell:(UITableViewCell*)cell;
-(void)PriseTheTalkTalkWithCell:(UITableViewCell*)cell WithBtn:(UIButton*)btn;
-(void)CommentTheTalkTalkWithCell:(UITableViewCell*)cell WithBtn:(UIButton*)btn;

@end

@interface MyShuoShuoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic,strong) CommentAndPriseView* commentAndPrise;
@property (nonatomic,strong) SSAllTalkDetailModel* model;
@property (nonatomic,assign) id<DeleteMyTalkTalkDelegate> delegate;

@end
