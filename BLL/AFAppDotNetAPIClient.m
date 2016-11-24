//
//  AFAppDotNetAPIClient.m
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

//这里是服务器的地址  
//static NSString* const AFAppDotNetAPIBaseURLString = @"http://10.58.139.16:8080/yyht/";
//static NSString* const AFAppDotNetAPIBaseURLString = @"http://114.55.55.230:8080/cjsdys/";
static NSString* const AFAppDotNetAPIBaseURLString = @"http://118.178.58.178:8080/cjsdys/";
//static NSString* const AFAppDotNetAPIBaseURLString = @"https://yst.cjzc.net.cn/cjsdys/";
//static NSString* const AFAppDotNetAPIBaseURLString = @"https://yst.cjtc.net.cn/yyht/";

@implementation AFAppDotNetAPIClient

+(instancetype)sharedClient
{
    static AFAppDotNetAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc]initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:     // 无连线
//                    NSLog(@"AFNetworkReachability Not Reachable");
//                    [MBProgressHUD showError:@"当前无网络" toView:nil];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                    NSLog(@"AFNetworkReachability Reachable via WWAN");
//                    [MBProgressHUD showError:@"您当前正在使用流量" toView:nil];
                    [[UploadNotSuccessImage shareUpload]loadImage];
                    [[UploadNotSuccessImage shareUpload]readOfflineMessage];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
//                    [MBProgressHUD showError:@"您当前正在使用WiFi" toView:nil];
                    [[UploadNotSuccessImage shareUpload]loadImage];
                    [[UploadNotSuccessImage shareUpload]readOfflineMessage];
//                    NSLog(@"AFNetworkReachability Reachable via WiFi");
                    break;
                case AFNetworkReachabilityStatusUnknown:          // 未知网络
                default:
//                    [MBProgressHUD showError:@"您当前正在使用未知网络" toView:nil];
                    [[UploadNotSuccessImage shareUpload]loadImage];
                    [[UploadNotSuccessImage shareUpload]readOfflineMessage];
                    break;
            }
        }];
        // 开始监听
        [_sharedClient.reachabilityManager startMonitoring];
    });
    return _sharedClient;
}

@end
