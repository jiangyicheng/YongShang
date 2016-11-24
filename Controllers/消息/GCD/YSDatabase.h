//
//  YSFmdb.h
//  YongShang
//
//  Created by user on 16/10/11.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDatabase : NSObject

@property (strong, nonatomic) FMDatabase *db;

+ (YSDatabase *)shareYSDatabase;
- (void)saveMessage:(NSString *)msgType msgId:(NSString *)msgId mfromId:(NSString *)mfrom time:(NSInteger)time mtoId:(NSString *)mto msgContentStr:(NSString *)msgContent msgStatusStr:(NSString *)msgStatus type:(NSString*)type;
- (void)updateData:(NSString *)msgId msgStatusStr:(NSString*)msgStatus;
- (NSMutableArray *)queryMessgeData:(NSString *)mtoId;

- (void)saveFriendList:(NSString *)friendId fName:(NSString *)fname contactname:(NSString*)contactname portal:(NSString*)portal tel:(NSString*)tel info:(NSString*)info linkman:(NSString*)linkman headimageurl:(NSString*)headimageurl sellbuyid:(NSString*)sellbuyid msgStatus:(NSString*)msgStatus;
- (NSMutableArray *)queryfriendData;

//修改好友信息
-(void)motifityTheFriendList:(NSString*)tel info:(NSString*)info linkman:(NSString*)linkman friendId:(NSString*)friendId companyname:(NSString*)fname andGQName:(NSString*)GQName;

- (BOOL)isSaveFriendId:(NSString *)qcId;
//删除聊天信息
- (void)deleteDataWithFriendId:(NSString*)friendId;
//置顶
- (void)becomeFirstDataWithFriendId:(NSString*)friendId;

@end
