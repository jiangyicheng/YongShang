//
//  RePublishSellAndBuyViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/10/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"

@interface RePublishSellAndBuyViewController : BaseViewController

//内容
@property (nonatomic,strong) NSString* contentString;

//供求信息编号
@property (nonatomic,strong) NSString* flagId;

//判断从哪个页面进来，1:我的供求页面 2:供求详情页面
@property (nonatomic,strong) NSString* formIndex;

@end
