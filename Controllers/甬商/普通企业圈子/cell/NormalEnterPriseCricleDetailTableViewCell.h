//
//  NormalEnterPriseCricleDetailTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuitEnterPriseCricleDelegate <NSObject>

@required
-(void)quitBtnDidClick;

@end

@interface NormalEnterPriseCricleDetailTableViewCell : UITableViewCell

@property (nonatomic,assign) id<QuitEnterPriseCricleDelegate> delegate;

@end
