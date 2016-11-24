//
//  YSBLL+YongShang.h
//  YongShang
//
//  Created by 姜易成 on 16/9/12.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSBLL.h"

@interface YSBLL (YongShang)

/**
 *  登录
 */
+(NSURLSessionDataTask *)getLoginResultBlock:(void (^)(loginModel* model, NSError* error))block;

/**
 *  顶部栏的详情
 *
 *  @param flagId 公司Id
 *  @param block
 */
+(NSURLSessionDataTask *)getInfoDetailWithFlagId:(NSString*)flagId andResultBlock:(void (^)(YSTopInfoDetailModel* model, NSError* error))block;

/**
 *  企业展厅详情
 */
+(NSURLSessionDataTask *)getEnterPriseResultWithFlagId:(NSString*)flagID andCompanyid:(NSString*)companyid Block:(void (^)(EnterPriseDetailModel* model, NSError* error))block;

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
+(NSURLSessionDataTask *)getResultWithComplaintuid:(NSString*)complaintuid andComplaintcid:(NSString*)complaintcid andBecomplainuid:(NSString*)becomplainuid andBecomplaincid:(NSString*)becomplaincid andComplainttype:(NSString*)complainttype andNewsdetails:(NSString*)newsdetails andFlagId:(NSString*)flagId andContext:(NSString*)context andContextimage:(NSString*)contextimage andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

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
+(NSURLSessionDataTask *)getResultWithFlagId:(NSString*)flagId andUserid:(NSString*)userid andCompanyname:(NSString*)companyname andTrade:(NSString*)trade andLinkman:(NSString*)linkman andPhone:(NSString*)phone andMainbusiness:(NSString*)mainbusiness andOperate:(NSString*)operate andCreatecompanyid:(NSString*)createcompanyid andlinkaddress:(NSString*)linkaddress andResultBlock:(void (^)(YSMyDisPlayRoomDetailModel* model, NSError* error))block;

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
+(NSURLSessionDataTask*)upLoadThePictureWithFlagId:(NSString*)flagId andProducturl1:(NSString*)producturl1 andProducturl1s:(NSString*)producturl1s andMemo:(NSString*)memo andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

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
+(NSURLSessionDataTask*)CreatEnterPriseCricleWithUnionname:(NSString*)unionname andMemo:(NSString*)memo andBusinessIds:(NSString*)businessIds andUnioncreateuid:(NSString*)unioncreateuid andResultBlock:(void(^)(CommonModel* model,NSError* error))block;

/**
 *  企业圈子详情
 */
+(NSURLSessionDataTask *)getEnterPriseDetailWithUnionid:(NSString*)unionid andResultBlock:(void (^)(YSEnterPriseDetailsModel* model, NSError* error))block;

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
+(NSURLSessionDataTask *)DeleteAndAddEnterPriseWithUnionid:(NSString*)unionid andBusinessIds:(NSString*)businessIds andFlagType:(NSString*)flagType andUnioncreateid:(NSString*)unioncreateuid andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

/**
 *  企业圈子被邀请
 *
 *  @param unionid   企业圈子编号
 *  @param companyid 当前用户的企业编号
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseInvitedWithUnion:(NSString*)unionid andCompanyId:(NSString*)companyid andResultBlock:(void (^)(BeInvitedJoinTheCricleModel* model, NSError* error))block;

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
+(NSURLSessionDataTask*)enterPriseAcceptInvitedWithUnion:(NSString*)unionid andCompanyId:(NSString*)companyid andFlagType:(NSString*)flagType andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

/**
 *  企业认证查询
 *
 *  @param createcid 登陆用户企业编号
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)enterPriseCertificationWithCreatecid:(NSString*)createcid andResultBlock:(void (^)(YSEnterPriseCertificationModel* model, NSError* error))block;

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
+(NSURLSessionDataTask*)enterPriseCertificationAddWithFlagName:(NSString*)flagName andNewsdetails:(NSString*)newsdetails andOperate:(NSString*)operate andUserid:(NSString*)userid andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

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
+(NSURLSessionDataTask*)enterPriseCertificationAgainWithFlagName:(NSString*)flagName andNewsdetails:(NSString*)newsdetails andOperate:(NSString*)operate andFlagID:(NSString*)flagId andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

/**
 *  企业圈子解散
 *
 *  @param unionid 企业圈子编号
 *  @param block   block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)cancleTheCricleWithUnionid:(NSString*)unionid andResultBlock:(void (^)(CommonModel* model, NSError* error))block;

/**
 *  修改企业圈子备注
 *
 *  @param unionid 企业圈子编号
 *  @param memo    备注
 *  @param block   block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)motifityTheCricleMemoWithUnionid:(NSString*)unionid Memo:(NSString*)memo andResultBlock:(void (^)(CommonModel* model, NSError* error))block;



@end
