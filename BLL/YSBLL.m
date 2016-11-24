//
//  YSBLL.m
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSBLL.h"

@implementation YSBLL

/**
 *  通用解析
 */
+(NSURLSessionDataTask *)getCommonWithUrl:(NSString *)url andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    return [[AFAppDotNetAPIClient sharedClient]POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CommonModel* model = [CommonModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
