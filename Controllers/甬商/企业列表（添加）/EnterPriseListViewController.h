//
//  EnterPriseListViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"

@interface EnterPriseListViewController : BaseViewController

// 状态 （1.新建添加 2.自己创建的圈子添加 3.自己创建的圈子删除 4.他人创建的圈子邀请）
@property (nonatomic,strong) NSString* status;
@property (nonatomic,strong) NSString* rightItemString;
//圈子编号
@property (nonatomic,strong) NSString* unionId;
//状态为1的时候已选择企业modelArray
@property (nonatomic,strong) NSArray* modelArray;
//状态为2的时候已经存在的企业数组
@property (nonatomic,strong) NSArray* alreadyPresentModelArray;
//状态为3的时候待删除的数组
@property (nonatomic,strong) NSArray* deleteModelArray;
//状态为4的时候已存在的企业model数组
@property (nonatomic,strong) NSArray* inviteModelArray;

@end
