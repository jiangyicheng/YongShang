//
//  ReportViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"

@interface ReportViewController : BaseViewController

@property (nonatomic,strong) NSString* BecomplaintedUId;
@property (nonatomic,strong) NSString* beComplaintedCId;
@property (nonatomic,strong) NSString* complaintedUId;
@property (nonatomic,strong) NSString* complaintedCId;
//信息来源(1.企业圈子 2.供求信息 3.在线沟通 4.说说举报)
@property (nonatomic,strong) NSString* infomationSource;
//举报信息编号
@property (nonatomic,strong) NSString* flagId;
//举报内容
@property (nonatomic,strong) NSString* context;
//举报图片路径
@property (nonatomic,strong) NSString* contextimage;

@end
