//
//  EnterPriseDisPlayRoomDetailViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"
#import "YSEnterPriseRoomModel.h"

@interface EnterPriseDisPlayRoomDetailViewController : BaseViewController

@property (nonatomic,strong) YSEnterPriseRoomModel* model;

//公司Id
@property (nonatomic,strong) NSString* enterPriseId;

@end
