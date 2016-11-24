//
//  CommentDetailViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"
#import "shuoshuoModel.h"

@interface CommentDetailViewController : BaseViewController

//说说编号
@property (nonatomic,strong) NSString* shuoshuoId;
//说说用户编号
@property (nonatomic,strong) NSString* shuoshuoUserId;

@end
