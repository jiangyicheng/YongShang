//
//  YSBLL+GongQiu.h
//  YongShang
//
//  Created by 姜易成 on 16/9/20.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSBLL.h"
#import "GQAddSupplyAndDemandModel.h"
#import "GQSupplyAndDemandDetailsModel.h"
#import "EditMySupplyAndDemandModel.h"

@interface YSBLL (GongQiu)

/**
 *  供求明细
 *
 *  @param lxtype    供求类型
 *  @param createcid 登陆用户企业编号
 *  @param flagId    登陆用户企业编号
 *  @param block     block
 *
 1.	type不传值时查询全部供求,type类型编号名称见接口2.2
 2.	createcid为null时，查询所有供求，不为null时,查询当前用户供求
 *  @return self
 */
+(NSURLSessionDataTask*)SupplyAndBuyDetailWithlxtype:(NSString*)lxtype andCreatecid:(NSString*)createcid andOrgid:(NSString*)orgid andResultBlock:(void (^)(GQSupplyAndBuyModel* model, NSError* error))block;

/**
 *  我的供求明细
 *
 *  @param lxtype    供求类型
 *  @param createcid 登陆用户企业编号
 *  @param block     block
 *
 1.	type不传值时查询全部供求,type类型编号名称见接口2.2
 2.	createcid为null时，查询所有供求，不为null时,查询当前用户供求
 *  @return self
 */
+(NSURLSessionDataTask*)MySupplyAndBuyDetailWithlxtype:(NSString*)lxtype andCreatecid:(NSString*)createcid andResultBlock:(void (^)(GQSupplyAndBuyModel* model, NSError* error))block;

/**
 *  我的供求信息编辑
 *
 *  @param flagId 供求信息编号
 *  @param block  block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)EditMySupplyAndBuyINfoWithFlagId:(NSString*)flagId andResultBlock:(void (^)(EditMySupplyAndDemandModel* model, NSError* error))block;

/**
 *  供求详情
 *
 *  @param flagId 供求信息编号
 *  @param block  block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)SupplyAndDemandDetailWithFlagId:(NSString*)flagId andCompanyId:(NSString*)companyid andResultBlock:(void (^)(GQSupplyAndDemandDetailsModel* model, NSError* error))block;

/**
 *  供求信息新增
 *
 *  @param lxtype         供求类型编号
 *  @param context        内容
 *  @param termtime       有效期
 *  @param telphonestatus 电话公布状态
 *  @param createcid      登陆用户企业编号
 *  @param block          block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)addSupplyAndDemandWithlxtype:(NSString*)lxtype andContext:(NSString*)context andTermtime:(NSString*)tradeId andTelphonestatus:(NSString*)telphonestatus andCreatecid:(NSString*)createcid imagesuccess:(NSString*)imagesuccess andResultBlock:(void (^)(GQAddSupplyAndDemandModel* model, NSError* error))block;

/**
 *  供求信息的重新发布
 *
 *  @param flagId         供求编号
 *  @param createcid      登陆用户编号
 *  @param lxtype         供求类型编号
 *  @param context        内容
 *  @param telphonestatus 电话公布状态
 *  @param tradeId        有效期
 *  @param block          block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)revocationOrPublishTheSupplyAndDemandWithFlagId:(NSString*)flagId andCreatecid:(NSString*)createcid andLxtype:(NSString*)lxtype andContext:(NSString*)context andTelphonestatus:(NSString*)telphonestatus andTradeId:(NSString*)tradeId imagesuccess:(NSString*)imagesuccess andResultBlock:(void (^)(GQAddSupplyAndDemandModel* model, NSError* error))block;

/**
 *  供求信息图片上传接口
 *
 *  @param flagId       供求编号
 *  @param producturl1  产品图路径http
 *  @param producturl1s 缩略图路径http
 *  @param block        Base64图片字符串
 *
 *  @return self;
 */
+(NSURLSessionDataTask*)sellAndBuyUploadimagesWithflagId:(NSString*)flagId producturl1:(NSString*)producturl1 producturl1s:(NSString*)producturl1s memo:(NSString*)memo andResultBlock:(void (^)(GQAddSupplyAndDemandModel* model, NSError* error))block;

/**
 *  供求信息的撤销
 *
 *  @param flagId    供求信息编号
 *  @param createcid 用户编号
 *  @param block     block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)revocationTheInfoWithFlagId:(NSString*)flagId andCreatecid:(NSString*)createcid andResultBlock:(void (^)(GQAddSupplyAndDemandModel* model, NSError* error))block;

/**
 *  加入黑名单
 *
 *  @param recipientuid  登陆用户编号
 *  @param brecipientuid 被加入黑名单的用户的编号
 *  @param flagType      （0:为不加入黑名单，1加入黑名单）
 *  @param block         block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)addToBlackListWithRecipientuid:(NSString*)recipientuid andBrecipientuid:(NSString*)brecipientuid andFlagType:(NSString*)flagType andResultBlock:(void (^)(GQAddSupplyAndDemandModel* model, NSError* error))block;


/**
 *  查询我是否   将   其他人加入黑名单
 *
 *  @param recipientuid  登陆用户编号
 *  @param brecipientuid 被加入黑名单的用户的编号
 *  @param block         block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)selectTheBlackListWithRecipientuid:(NSString*)recipientuid andBrecipientuid:(NSString*)brecipientuid andResultBlock:(void (^)(id responseObj, NSError* error))block;


/**
 *  聊天图片保存
 *
 *  @param contextimage Base64编码
 *  @param block        block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)saveTheChatImageWithContextimage:(NSString*)contextimage andResultBlock:(void (^)(SaveTheChatMessageModel* model, NSError* error))block;


/**
 *  离线消息读取
 *
 *  @param recipientuid 登陆用户编号
 *  @param block        block
 *
 *  @return self
 */
+(NSURLSessionDataTask*)readOfflinemessageResultBlock:(void (^)(ReadOfflineMessageModel* model, NSError* error))block;


@end
