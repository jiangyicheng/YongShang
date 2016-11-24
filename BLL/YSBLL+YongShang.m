//
//  YSBLL+YongShang.m
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSBLL+YongShang.h"

@implementation YSBLL (YongShang)

/**
 *  登录
 */
+(NSURLSessionDataTask *)getLoginResultBlock:(void (^)(loginModel *, NSError *))block
{
    NSDictionary* dict = @{@"flagId":@"cjtc0000001407@trial0167",
                           @"u_code":@"cjtc0000001407@trial0167"};
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/loginapp.do"] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        loginModel* model = [loginModel yy_modelWithJSON:responseObject];
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
 *  顶部栏的详情
 *
 *  @param flagId 公司Id
 *  @param block
 */
+(NSURLSessionDataTask *)getInfoDetailWithFlagId:(NSString *)flagId andResultBlock:(void (^)(YSTopInfoDetailModel *, NSError *))block
{
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/topmenuDetails.do?flagId=%@&u_code=%@",flagId,[UserModel shareInstanced].postName] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YSTopInfoDetailModel* model = [YSTopInfoDetailModel yy_modelWithJSON:responseObject];
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
 *  企业展厅详情
 */
+(NSURLSessionDataTask *)getEnterPriseResultWithFlagId:(NSString *)flagID andCompanyid:(NSString *)companyid Block:(void (^)(EnterPriseDetailModel *, NSError *))block
{
    NSDictionary* dict = @{@"flagId":flagID,
                           @"companyid":companyid,
                           @"u_code":[UserModel shareInstanced].postName,
                           };
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/businessDetails.do"] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"response===%@",responseObject);
        EnterPriseDetailModel* model = [EnterPriseDetailModel yy_modelWithJSON:responseObject];
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
 *  举报企业
 *
 *  @param complaintuid  登录用户编号
 *  @param complaintcid  登录用户企业编号
 *  @param becomplainuid 被举报用户编号
 *  @param becomplaincid 被举报用户企业编号
 *  @param complainttype 举报类型
 *  @param newsdetails   信息来源(1.企业圈子 2.供求信息 3.在线沟通 4.说说举报)
 *  @param block         model
 *
 *  @return self
 */
+(NSURLSessionDataTask *)getResultWithComplaintuid:(NSString *)complaintuid andComplaintcid:(NSString *)complaintcid andBecomplainuid:(NSString *)becomplainuid andBecomplaincid:(NSString *)becomplaincid andComplainttype:(NSString *)complainttype andNewsdetails:(NSString *)newsdetails andFlagId:(NSString *)flagId andContext:(NSString *)context andContextimage:(NSString *)contextimage andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"complaintuid":complaintuid,
                           @"complaintcid":complaintcid,
                           @"becomplainuid":becomplainuid,
                           @"becomplaincid":becomplaincid,
                           @"complainttype":complainttype,
                           @"flagId":flagId,
                           @"context":context,
                           @"contextimage":contextimage,
                           @"newsdetails":newsdetails};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/reportBusiness.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  新增和编辑我的展厅
 *
 *  @param flagId       登陆用户商会编号
 *  @param userid       登陆用户编号
 *  @param companyname  企业名称
 *  @param trade        所属行业编号
 *  @param linkman      联系人
 *  @param phone        联系电话
 *  @param mainbusiness 主营业务
 *  @param operate  操作
 *  @param createcompanyid  编辑传入（企业编号）
 *  @param block
 *
 *  @return self
 */

+(NSURLSessionDataTask *)getResultWithFlagId:(NSString *)flagId andUserid:(NSString *)userid andCompanyname:(NSString *)companyname andTrade:(NSString *)trade andLinkman:(NSString *)linkman andPhone:(NSString *)phone andMainbusiness:(NSString *)mainbusiness andOperate:(NSString *)operate andCreatecompanyid:(NSString *)createcompanyid andlinkaddress:(NSString*)linkaddress andResultBlock:(void (^)(YSMyDisPlayRoomDetailModel *, NSError *))block
{
    NSDictionary* parmaeter = @{@"u_code":[UserModel shareInstanced].postName,
                                @"flagId":flagId,
                                @"userid":userid,
                                @"companyname":companyname,
                                @"trade":trade,
                                @"linkman":linkman,
                                @"phone":phone,
                                @"mainbusiness":mainbusiness,
                                @"operate":operate,
                                @"linkaddress":linkaddress,
                                @"createcompanyid":createcompanyid};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessAdd.do" parameters:parmaeter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YSMyDisPlayRoomDetailModel* model = [YSMyDisPlayRoomDetailModel yy_modelWithJSON:responseObject];
//        NSLog(@"dict===%@",parmaeter);
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
 *  上传图片
 *
 *  @param flagId      企业编号
 *  @param producturl1 图片
 *  @param producturl2 图片
 *  @param producturl3 图片
 *  @param producturl4 图片
 *  @param producturl5 图片
 *  @param producturl6 图片
 *  @param block       block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)upLoadThePictureWithFlagId:(NSString *)flagId andProducturl1:(NSString *)producturl1 andProducturl1s:(NSString *)producturl1s andMemo:(NSString*)memo andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* parmaeter = @{@"u_code":[UserModel shareInstanced].postName,
                                @"flagId":flagId,
                                @"producturl1":producturl1,
                                @"producturl1s":producturl1s,
                                @"memo":memo
                                };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessUploadimages.do" parameters:parmaeter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CommonModel* model = [CommonModel yy_modelWithJSON:responseObject];
//        NSLog(@"dict===%@",parmaeter);
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
 *  新建企业圈子
 *
 *  @param unionname      圈子名称
 *  @param memo           备注
 *  @param businessIds    企业的编号数组
 *  @param unioncreateuid 登录用户企业编号
 *  @param block          block
 *
 *  @return self
 */
+(NSURLSessionDataTask *)CreatEnterPriseCricleWithUnionname:(NSString *)unionname andMemo:(NSString *)memo andBusinessIds:(NSString *)businessIds andUnioncreateuid:(NSString *)unioncreateuid andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* parameter = @{@"u_code":[UserModel shareInstanced].postName,
                                @"unionname":unionname,
                                 @"memo":memo,
                                 @"businessIds":businessIds,
                                 @"unioncreateuid":unioncreateuid,
                                 };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessUnionAdd.do" parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  企业圈子详情
 */
+(NSURLSessionDataTask *)getEnterPriseDetailWithUnionid:(NSString *)unionid andResultBlock:(void (^)(YSEnterPriseDetailsModel *, NSError *))block
{
    NSDictionary* parameter = @{@"u_code":[UserModel shareInstanced].postName,
                                @"unionid":unionid,
                                @"flagId":[UserModel shareInstanced].companyId
                                };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessUnionManager.do" parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    YSEnterPriseDetailsModel* model = [YSEnterPriseDetailsModel yy_modelWithJSON:responseObject];
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
 *  管理企业圈子添加、删除
 *
 *  @param unionid     企业圈子编号
 *  @param businessIds 企业编号组
 *  @param flagType    操作
 *  @param block       block
 *
 *  @return self
 */
+(NSURLSessionDataTask *)DeleteAndAddEnterPriseWithUnionid:(NSString *)unionid andBusinessIds:(NSString *)businessIds andFlagType:(NSString *)flagType andUnioncreateid:(NSString *)unioncreateuid andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/businessUnionEdit.do?unionid=%@&businessIds=%@&flagType=%@&unioncreateuid=%@&u_code=%@",unionid,businessIds,flagType,unioncreateuid,[UserModel shareInstanced].postName] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  企业圈子被邀请
 *
 *  @param unionid   企业圈子编号
 *  @param companyid 当前用户的企业编号
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseInvitedWithUnion:(NSString *)unionid andCompanyId:(NSString *)companyid andResultBlock:(void (^)(BeInvitedJoinTheCricleModel *, NSError *))block
{
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/businessUnionInvite.do?unionid=%@&companyid=%@&u_code=%@",unionid,companyid,[UserModel shareInstanced].postName] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BeInvitedJoinTheCricleModel* model = [BeInvitedJoinTheCricleModel yy_modelWithJSON:responseObject];
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
 *  企业圈子邀请接受、拒绝操作、退出圈子
 *
 *  @param unionid   企业圈子编号
 *  @param companyid 登录用户企业编号
 *  @param flagType  操作（1:待验证 2:接受邀请 0:拒绝邀请 3::退出圈子）
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseAcceptInvitedWithUnion:(NSString *)unionid andCompanyId:(NSString *)companyid andFlagType:(NSString *)flagType andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/businessUnionInviteEdit.do?unionid=%@&companyid=%@&flagType=%@&u_code=%@",unionid,companyid,flagType,[UserModel shareInstanced].postName] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  企业认证查询
 *
 *  @param createcid 登陆用户企业编号
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseCertificationWithCreatecid:(NSString *)createcid andResultBlock:(void (^)(YSEnterPriseCertificationModel *, NSError *))block
{
    return [[AFAppDotNetAPIClient sharedClient]POST:[NSString stringWithFormat:@"appservice/companyApplyDetail.do?createcid=%@&u_code=%@",createcid,[UserModel shareInstanced].postName] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YSEnterPriseCertificationModel* model = [YSEnterPriseCertificationModel yy_modelWithJSON:responseObject];
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
 *  企业认证新增
 *
 *  @param flagName    企业名称
 *  @param newsdetails 营业执照
 *  @param operate     有效期
 *  @param userid      用户编号
 *  @param block       block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseCertificationAddWithFlagName:(NSString *)flagName andNewsdetails:(NSString *)newsdetails andOperate:(NSString *)operate andUserid:(NSString *)userid andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* dict = @{
                           @"u_code":[UserModel shareInstanced].postName,
                           @"flagName":flagName,
                           @"newsdetails":newsdetails,
                           @"operate":operate,
                           @"userid":userid};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/companyApplyAdd.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  企业重新认证
 *
 *  @param flagName    企业名称
 *  @param newsdetails 营业执照
 *  @param operate     有效期
 *  @param flagId      企业编号
 *  @param block       block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseCertificationAgainWithFlagName:(NSString*)flagName andNewsdetails:(NSString*)newsdetails andOperate:(NSString*)operate andFlagID:(NSString*)flagId andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagName":flagName,
                           @"newsdetails":newsdetails,
                           @"operate":operate,
                           @"flagId":flagId};
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/afreshApply.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  企业圈子解散
 *
 *  @param unionid 企业圈子编号
 *  @param block   block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)cancleTheCricleWithUnionid:(NSString *)unionid andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"companyid":[UserModel shareInstanced].companyId,
                           @"unionid":unionid
                           };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessUnionBussolution.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
 *  修改企业圈子备注
 *
 *  @param unionid 企业圈子编号
 *  @param memo    备注
 *  @param block   block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)motifityTheCricleMemoWithUnionid:(NSString *)unionid Memo:(NSString *)memo andResultBlock:(void (^)(CommonModel *, NSError *))block
{
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"companyid":[UserModel shareInstanced].companyId,
                           @"memo":memo,
                           @"unionid":unionid
                           };
    return [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessUnionEditMemo.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
