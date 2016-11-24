 //
//  YSFmdb.m
//  YongShang
//
//  Created by user on 16/10/11.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSDatabase.h"
#import "MessageModel.h"
#import "MessageMainModel.h"

#define FRIENDLISTNAME @"FriendList"
#define MESSAGELISTNAME @"MessageList"

@implementation YSDatabase

+ (YSDatabase *)shareYSDatabase{
    
    static YSDatabase *ysDatabase = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ysDatabase = [[YSDatabase alloc]init];
    });
    return ysDatabase;
}

- (FMDatabase *)db{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:[self getPathOfFmdb]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[self getPathOfFmdb]]) {
            NSLog(@"还未创建数据库，现在正在创建数据库");
            if ([_db open]) {
                
                 NSString *creatFriendListStr = [NSString stringWithFormat:@"CREATE TABLE %@ (uid text, friendId text, fName text ,contactName text ,portal text ,tel text ,info text , linkman text , headimageurl text ,sellbuyid text ,msgStatus text)", FRIENDLISTNAME];
                
                NSString *creatMsgListStr = [NSString stringWithFormat:@"CREATE TABLE %@ (msgType text, msgId text, uid text, mfrom text, mfromTime integer, mto text, mtoTime integer, msgContent text, msgStatus text ,type text)", MESSAGELISTNAME];
                
                [_db executeUpdate:creatMsgListStr];
                BOOL res = [_db executeUpdate:creatFriendListStr];
                
                if (!res) {
                    NSLog(@"error when insert db table");
                } else {
                    NSLog(@"success to insert db table");
                }
                
            }else{
                NSLog(@"database open error");
            }
        }
        else{
            NSLog(@"您已经创建－－－%@",[self getPathOfFmdb]);
        }
    }
    return _db;
}

//是否保存当前聊天好友信息
- (BOOL)isSaveFriendId:(NSString *)qcId{
    
    NSMutableArray *friendArr = [[YSDatabase shareYSDatabase]queryfriendData];
    NSMutableArray *idArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    if ([friendArr count] > 0) {
        for (int i = 0; i< [friendArr count]; i ++) {
            MessageMainModel* message = [friendArr objectAtIndex:i];
            NSString *idStr = message.friendId;
            [idArr addObject:idStr];
        }
        if ([idArr containsObject:qcId]) {
            return YES;
        }else if ([qcId integerValue] == [[UserModel shareInstanced].userID integerValue]){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    
}

//插入好友信息
- (void)saveFriendList:(NSString *)friendId fName:(NSString *)fname contactname:(NSString*)contactname portal:(NSString*)portal tel:(NSString*)tel info:(NSString*)info linkman:(NSString*)linkman headimageurl:(NSString*)headimageurl sellbuyid:(NSString*)sellbuyid msgStatus:(NSString*)msgStatus{

    [self.db open];
    
    NSString *insertSql= [NSString stringWithFormat:
                          @"INSERT INTO '%@' (uid, friendId, fName ,contactName ,portal ,tel ,info , linkman ,headimageurl ,sellbuyid ,msgStatus) VALUES ('%@', '%@', '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' ,'%@' ,'%@')",
                          FRIENDLISTNAME, [UserModel shareInstanced].userID, friendId, fname,contactname,portal,tel,info,linkman,headimageurl,sellbuyid,msgStatus];
    
    BOOL res = [self.db executeUpdate:insertSql];
    
    if (!res) {
        NSLog(@"error when insert db table");
    } else {
        NSLog(@"success to insert db table");
    }
    [self.db close];

}

//置顶
- (void)becomeFirstDataWithFriendId:(NSString*)friendId
{
    [self.db open];
    
    NSString *updateSql = [NSString stringWithFormat:@"update %@ order by case when firendId ='%@' then 0 else 1 end ",FRIENDLISTNAME,friendId];
    
    BOOL result = [self.db executeUpdate:updateSql];
    if(result){
        NSLog(@"置顶数据成功");
    }else{
        NSLog(@"置顶数据失败");
    }
    [self.db close];
}

//修改好友供求信息
-(void)motifityTheFriendList:(NSString*)tel info:(NSString*)info linkman:(NSString*)linkman friendId:(NSString*)friendId companyname:(NSString*)fname andGQName:(NSString*)GQName
{
    [self.db open];
    
    //注 此处的tel传过来的就是sellbuyid
    NSString *updateTELSql = [NSString stringWithFormat:@"update %@ SET  sellbuyid = '%@'  where friendId = '%@' and uid = '%@'",FRIENDLISTNAME,tel,friendId,[UserModel shareInstanced].userID];
//    NSString *updateLinkManSql = [NSString stringWithFormat:@"update %@ SET  linkman = '%@'  where friendId = '%@'",FRIENDLISTNAME,linkman,friendId];
//    NSString *updateInfoSql = [NSString stringWithFormat:@"update %@ SET  info = '%@'  where friendId = '%@'",FRIENDLISTNAME,info,friendId];
//    NSString *updatefnameSql = [NSString stringWithFormat:@"update %@ SET  fName = '%@'  where friendId = '%@'",FRIENDLISTNAME,fname,friendId];
//    NSString *updateGQnameSql = [NSString stringWithFormat:@"update %@ SET  contactName = '%@'  where friendId = '%@'",FRIENDLISTNAME,GQName,friendId];
    BOOL result = [self.db executeUpdate:updateTELSql];
//    [self.db executeUpdate:updateLinkManSql];
//    [self.db executeUpdate:updateInfoSql];
//    [self.db executeUpdate:updatefnameSql];
//    [self.db executeUpdate:updateGQnameSql];
    if(result){
        NSLog(@"更新数据成功");
    }else{
        NSLog(@"更新数据失败");
    }
    [self.db close];
}

//查询好友记录数据
- (NSMutableArray *)queryfriendData
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.db open];
    
    NSString *querySql =[NSString stringWithFormat:@"select * from '%@' where uid = '%@' or friendId = '%@'",FRIENDLISTNAME,[UserModel shareInstanced].userID,[UserModel shareInstanced].userID];
    FMResultSet *resultSet = [self.db executeQuery:querySql];
    
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSString *friendId = [resultSet stringForColumn:@"friendId"];
        NSString *nameStr = [resultSet stringForColumn:@"fname"];
        NSString* contactName = [resultSet stringForColumn:@"linkman"];
        NSString* portal = [resultSet stringForColumn:@"portal"];
        NSString* headimageurl = [resultSet stringForColumn:@"headimageurl"];
        NSString* tel = [resultSet stringForColumn:@"tel"];
        NSString* info = [resultSet stringForColumn:@"info"];
        NSString* GQName = [resultSet stringForColumn:@"contactName"];
        NSString* sellbuyid = [resultSet stringForColumn:@"sellbuyid"];
        NSString* msgStatus = [resultSet stringForColumn:@"msgStatus"];
        
        MessageMainModel* message = [[MessageMainModel alloc]init];
        //        message.text = contentStr;
        message.friendId = friendId;
        message.name = nameStr;

        if ([msgStatus isEqualToString:@"0"]) {
            message.contactname = contactName;
            message.portal = headimageurl;
        }else if([msgStatus isEqualToString:@"1"]){
            message.contactname = GQName;
            message.portal = portal;
        }
        NSLog(@"----%@",contactName);
        NSLog(@"-----%@",GQName);
        NSLog(@"联系人----%@",message.contactname);
//        message.portal = portal;
        message.contactTel = tel;
        message.info = info;
        message.sellbuyid = sellbuyid;
//        message.GQName = GQName;
        [array addObject:message];
    
    }
   
    [self.db close];
    return array;
    
}

//插入聊天记录数据
- (void)saveMessage:(NSString *)msgType msgId:(NSString *)msgId mfromId:(NSString *)mfrom time:(NSInteger)time mtoId:(NSString *)mto msgContentStr:(NSString *)msgContent msgStatusStr:(NSString *)msgStatus type:(NSString*)type{
    
    NSString *uid = [UserModel shareInstanced].userID;
    
    if ([self.db open]) {

        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' (msgType, msgId, uid, mfrom, mfromTime, mto, mtoTime, msgContent, msgStatus, type) VALUES ('%@', '%@', '%@', '%@', '%ld', '%@','%ld', '%@', '%@', '%@')",
                            MESSAGELISTNAME, msgType, msgId, uid, mfrom, time, mto, time, msgContent, msgStatus,type];
        
        BOOL res = [self.db executeUpdate:insertSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [self.db close];
        
    }
}

//修改聊天记录数据
- (void)updateData:(NSString *)msgId msgStatusStr:(NSString*)msgStatus
{
    [self.db open];
    
    NSString *updateSql=[NSString stringWithFormat:@"update %@ SET msgId = '%@'  msgStatus ='%@'",MESSAGELISTNAME, msgId, msgStatus];
    BOOL result=[self.db executeUpdate:updateSql];
    if(result){
        NSLog(@"更新数据成功");
    }else{
        NSLog(@"更新数据失败");
    }
    [self.db close];
}


////删除数据
- (void)deleteDataWithFriendId:(NSString*)friendId
{
    [self.db open];
    NSString *deleteSql=[NSString stringWithFormat:@"delete from %@ where friendId = '%@' and uid = '%@'",FRIENDLISTNAME,friendId,[UserModel shareInstanced].userID];
    NSString *deleteSqls=[NSString stringWithFormat:@"delete from %@ where friendId = '%@' and uid = '%@'",FRIENDLISTNAME,[UserModel shareInstanced].userID,friendId];
    NSString* deleteChat = [NSString stringWithFormat:@"delete from %@ where mto = '%@' and uid = '%@'",MESSAGELISTNAME,friendId,[UserModel shareInstanced].userID];
    NSString* deleteChats = [NSString stringWithFormat:@"delete from %@ where uid = '%@' and mfrom = '%@'",MESSAGELISTNAME,[UserModel shareInstanced].userID,friendId];
    BOOL result=[self.db executeUpdate:deleteSql];
    [self.db executeUpdate:deleteSqls];
    [self.db executeUpdate:deleteChat];
    [self.db executeUpdate:deleteChats];
    
    if(result){
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }
    [self.db close];
}

//查询聊天记录数据
- (NSMutableArray *)queryMessgeData:(NSString *)mtoId
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.db open];
    
    NSString *querySql =[NSString stringWithFormat:@"select * from %@ where (mto = '%@' or mfrom = '%@') and uid = '%@'",MESSAGELISTNAME, mtoId, mtoId,[UserModel shareInstanced].userID];
    FMResultSet *resultSet = [self.db executeQuery:querySql];
    
    // 2.遍历结果
    while ([resultSet next]) {

//        NSString* moform = [resultSet stringForColumn:@"mfrom"];
        NSString *contentStr = [resultSet stringForColumn:@"msgContent"];
        NSInteger time = [[resultSet stringForColumn:@"mfromTime"] intValue];
        NSString *msgStatusStr = [resultSet stringForColumn:@"msgStatus"];
        NSString* messageType = [resultSet stringForColumn:@"type"];
        NSString *msgTime = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld000",time]];
        
        MessageModel* message = [[MessageModel alloc]init];
        message.text = contentStr;
        message.time = msgTime;
        message.timestr = time;
//        if ([moform isEqual:[UserModel shareInstanced].userID]) {
//            message.type = 0;
//        }else{
//            message.type = 1;
//        }
        message.type = [msgStatusStr intValue];
        message.messageType = messageType;
    
        [array addObject:message];
        
    }
    [self.db close];
    
    return array;

}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [NSString string];
//    dateString = [self compareDate:date];
//    if ([dateString isEqualToString:@"昨天"]) {
//        dateString = [self compareDate:date];
//    }else if([dateString isEqualToString:@"今天"]){
//        dateString = [self compareCurrentTime:date];
//    }else{
//        dateString = [formatter stringFromDate:date];
//    }
    dateString = [formatter stringFromDate:date];
    return dateString;
}

-(NSString *) compareCurrentTime:(NSDate*) compareDate
//计算指定时间与当前的时间差
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

/**
 *  判断日期为今天还是昨天
 *
 *  @param date 日期
 *
 *  @return
 */
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}


-(NSString*)getPathOfFmdb{
    //获取路径数组
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [paths objectAtIndex:0];
    //进行路径的拼接
//    NSLog(@"%@",[documentsstringByAppendingPathComponent:DBNAME]);
    return [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"MessgaeDatass.db"]];
    
}

@end
