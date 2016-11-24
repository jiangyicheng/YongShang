//
//  ReviceORRefuseTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReviceORRefuseDelegate <NSObject>

@required
-(void)reviceBtnDidClick;
-(void)refuseBtnDidClick;
@end

@interface ReviceORRefuseTableViewCell : UITableViewCell

@property (nonatomic,assign) id<ReviceORRefuseDelegate> delegate;

@end
