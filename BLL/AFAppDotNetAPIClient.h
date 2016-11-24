//
//  AFAppDotNetAPIClient.h
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+(instancetype)sharedClient;

@end
