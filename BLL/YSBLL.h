//
//  YSBLL.h
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"
#import "CommonModel.h"
#import "YSTopInfoDetailModel.h"
#import "loginModel.h"
#import "EnterPriseDetailModel.h"
#import "YSEnterPriseCricleModel.h"
#import "YSEnterPriseDetailsModel.h"
#import "BeInvitedJoinTheCricleModel.h"
#import "YSEnterPriseCertificationModel.h"
#import "GQSupplyAndBuyModel.h"
#import "YSMyDisPlayRoomDetailModel.h"
#import "AllTalkTalkModel.h"
#import "SSLimitSetModel.h"
#import "SaveTheChatMessageModel.h"
#import "ReadOfflineMessageModel.h"


@interface YSBLL : NSObject

/**
 *  通用解析
 */
+(NSURLSessionDataTask *)getCommonWithUrl:(NSString*)url andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

@end
