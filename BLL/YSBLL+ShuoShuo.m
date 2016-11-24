//
//  YSBLL+ShuoShuo.m
//  YongShang
//
//  Created by 姜易成 on 16/9/21.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSBLL+ShuoShuo.h"

@implementation YSBLL (ShuoShuo)

/**
 *  好友企业说说明细
 *
 *  @param flagId          登陆用户编号
 *  @param createcompanyid 用户企业编号
 *  @param block           block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)GetAllShuoShuoDetailWithFlagId:(NSString *)flagId andCreatecompanyid:(NSString *)createcompanyid andOrgid:(NSString *)orgid andPageSize:(NSInteger)pageSize andCurrentPage:(NSInteger)currentPage andResultBlock:(void (^)(AllTalkTalkModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":flagId,
                           @"createcompanyid":createcompanyid,
                           @"currentPage":@(currentPage),
                           @"pageSize":@(pageSize),
                           @"orgid":orgid};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/talkDetails.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        AllTalkTalkModel* model = [AllTalkTalkModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  我的说说
 *
 *  @param flagId 登陆用户编号
 *  @param block  block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)GetMyShuoShuoDetailWithFlagId:(NSString *)flagId andPageSize:(NSInteger)pageSize andCurrentPage:(NSInteger)currentPage andResultBlock:(void (^)(AllTalkTalkModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"currentPage":@(currentPage),
                           @"pageSize":@(pageSize),
                           @"flagId":flagId};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/mytalkDetails.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        AllTalkTalkModel* model = [AllTalkTalkModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  我的说说删除
 *
 *  @param flagId 说说Id
 *  @param block  block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)DeleteMyShuoShuoDetailWithFlagId:(NSString *)flagId andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":flagId};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/mytalkDel.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

/**
 *  更换相册封面
 *
 *  @param flagId 登陆用户编号
 *  @param talkurl 相册封面路径
 *  @param block  block
 *  @return self
 */
+(NSURLSessionDataTask*)ChangeTheAlbumWithFlagId:(NSString *)flagId andTalkurl:(NSString *)talkurl andResultBlock:(void (^)(GQAddSupplyAndDemandModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":flagId,
                           @"talkurl":talkurl};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/changeCover.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQAddSupplyAndDemandModel* model = [GQAddSupplyAndDemandModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  新增说说
 *
 *  @param createcid 登陆用户编号
 *  @param context   文本内容
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)AddNewTalkTalkWithCreatecid:(NSString *)createcid andContext:(NSString *)context andTotalTalk:(NSString *)totaltalk andResultBlock:(void (^)(YSMyDisPlayRoomDetailModel *, NSError *))block{
    //
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"createcid":createcid,
                           @"totaltalk":totaltalk,
                           @"context":context};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/mytalkAdd.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YSMyDisPlayRoomDetailModel* model = [YSMyDisPlayRoomDetailModel yy_modelWithJSON:responseObject];
        
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  我的说说图片新增接口
 *
 *  @param flagId    说说编号
 *  @param imageurl1 说说图片
 *  @param imageurl2 说说图片说说图片
 *  @param imageurl3 说说图片
 *  @param imageurl4 说说图片
 *  @param imageurl5 说说图片
 *  @param imageurl6 说说图片
 *  @param imageurl7 说说图片
 *  @param imageurl8 说说图片
 *  @param imageurl9 说说图片
 *  @param block     bolck
 *
 *  @return self
 */
+(NSURLSessionDataTask*)upLoadShuoShuoPictureWithFlagId:(NSString *)flagId andImageurl1:(NSString *)imageurl1 andImageurl2:(NSString *)imageurl2 andImageurl3:(NSString *)imageurl3 andImageurl4:(NSString *)imageurl4 andImageurl5:(NSString *)imageurl5 andImageurl6:(NSString *)imageurl6 andImageurl7:(NSString *)imageurl7 andImageurl8:(NSString *)imageurl8 andImageurl9:(NSString *)imageurl9 andResultBlock:(void (^)(GQAddSupplyAndDemandModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":flagId,
                           @"imageurl1":imageurl1,
                           @"imageurl2":imageurl2,
                           @"imageurl3":imageurl3,
                           @"imageurl4":imageurl4,
                           @"imageurl5":imageurl5,
                           @"imageurl6":imageurl6,
                           @"imageurl7":imageurl7,
                           @"imageurl8":imageurl8,
                           @"imageurl9":imageurl9,};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/mytalkUploadimages.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQAddSupplyAndDemandModel* model = [GQAddSupplyAndDemandModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  说说评论详情
 *
 *  @param flagId 说说编号
 *  @param block  block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)shuoShuoCommentDetailWithFlagId:(NSString *)flagId andResultBlock:(void (^)(SSTalkTalkDetailModel *, NSError *))block
{
    NSDictionary* dict = @{@"flagId":flagId,
                           @"u_code":[UserModel shareInstanced].postName};
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/commentDetails.do"] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SSTalkTalkDetailModel* model = [SSTalkTalkDetailModel yy_modelWithJSON:responseObject];
//        NSLog(@"shuoshuo--%@",responseObject);
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  说说评论，点赞
 *
 *  @param flagId   说说编号
 *  @param createid 操作用户的编号
 *  @param friendid 说说的用户编号
 *  @param lxtype   类型 1.点赞 2.留言
 *  @param memo     留言
 *  @param block    block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)shuoshuoCommentAndPriseFlagId:(NSString *)flagId andCreateid:(NSString *)createid andFriendid:(NSString *)friendid andLxtype:(NSString *)lxtype andMemo:(NSString *)memo andResultBlock:(void (^)(GQAddSupplyAndDemandModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":flagId,
                           @"createid":createid,
                           @"friendid":friendid,
                           @"lxtype":lxtype,
                           @"memo":memo};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/talkCommentOrClick.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQAddSupplyAndDemandModel* model = [GQAddSupplyAndDemandModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  说说权限设置
 *
 *  @param companyid      登陆用户企业编号
 *  @param limitcompanyid 被限制企业的编号
 *  @param fseemtalk      不让他看我的说说
 *  @param mseeftalk      不看他的说说
 *  @param block          block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)shuoshuoLimitsSetWithCompanyid:(NSString *)companyid andLimitcompanyid:(NSString *)limitcompanyid andFseemtalk:(NSString *)fseemtalk andMseeftalk:(NSString *)mseeftalk andResultBlock:(void (^)(GQAddSupplyAndDemandModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"companyid":companyid,
                           @"limitcompanyid":limitcompanyid,
                           @"fseemtalk":fseemtalk,
                           @"mseeftalk":mseeftalk};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/talkPowerSet.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQAddSupplyAndDemandModel* model = [GQAddSupplyAndDemandModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  说说权限设置引导页
 *
 *  @param companyid      登陆用户企业编号
 *  @param limitcompanyid 被限制企业的编号
 *  @param block          block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)shuoshuoLimitsSetYinDaoWithCompanyid:(NSString *)companyid andLimitcompanyid:(NSString *)limitcompanyid andResultBlock:(void (^)(SSLimitSetModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"companyid":companyid,
                           @"limitcompanyid":limitcompanyid,
                           };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/talkSet.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SSLimitSetModel* model = [SSLimitSetModel yy_modelWithJSON:responseObject];
        if (block) {
            block(model,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 *  说说评论删除
 *
 *  @param flagId 评论编号
 *  @param userid 用户编号
 *  @param block  block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)shuoshuoCommentDeleteWithFlagId:(NSString *)flagId andUserid:(NSString *)userid andResultBlock:(void (^)(GQAddSupplyAndDemandModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":flagId,
                           @"userid":userid,
                           };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/talkCommentDel.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQAddSupplyAndDemandModel* model = [GQAddSupplyAndDemandModel yy_modelWithJSON:responseObject];
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
