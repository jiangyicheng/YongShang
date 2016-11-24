//
//  SocketProtocol.m
//  YongShang
//
//  Created by user on 16/10/10.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YSSocketProtocol.h"
#import<CommonCrypto/CommonDigest.h>
#import "MessageModel.h"

//#define HOST @"10.58.201.124"
//#define PORT 1234 yst.cjtc.net.cn   118.178.58.178   118.178.135.12

#define HOST @"118.178.58.178"
#define PORT 52155

@implementation YSSocketProtocol


+ (YSSocketProtocol *)shareSocketProtocol{
    
    static YSSocketProtocol *socketPtl = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketPtl = [[YSSocketProtocol alloc]init];
    });
    return socketPtl;
}

- (GCDAsyncSocket *)asyncSocket{
    if (_asyncSocket == nil) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _asyncSocket;
}

- (void)socketConnect{

    NSError *err = nil;
    
    if (![self.asyncSocket isConnected])
    {
        [self.asyncSocket connectToHost:HOST onPort:PORT error:&err];
    }
}

-(void)closeSocket
{
    if ([self.asyncSocket isConnected]) {
        [self.asyncSocket disconnect];
    }
}

#pragma mark -
#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port{
    NSLog(@"连接成功");
    
    //读取离线消息
    [[UploadNotSuccessImage shareUpload]readOfflineMessage];
    
    [_asyncSocket readDataWithTimeout:-1 tag:0];
    
//    [[YSSocketProtocol shareSocketProtocol]sendData:@"9010" msgId:nil msgContent:@"9010" mtoId:nil];
    [[YSSocketProtocol shareSocketProtocol]sendData:@"9010" msgId:nil msgContent:@"9010" mtoId:nil name:nil portal:nil tel:nil company:nil info:nil linkMan:nil withType:0 sellbuyid:nil];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err{
    NSLog(@"连接失败");
}

#pragma mark -
#pragma mark - WriteDataDelegate
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag{
    NSLog(@"发送成功");
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    [MBProgressHUD showError:@"发送失败"];
    NSLog(@"发送失败");
    return elapsed;
}

#pragma mark -
#pragma mark - ReadDataDelegate

//此方法的第一次调用是已经连接上的方法调用的时候。会读取data，然后调用代理的此方法。此时tag就事上面的TAG_FIXED_LENGTH_HEADER，所以第一次执行读取header
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    

    
//    NSString *string = @" {\"appId\":\"cjsdys\",\"deviceId\":\"test333\",\"msgContent\":{\"fromDeviceId\":\"test888\",\"msgContent\":\"this is a test\",\"msgId\":\"m00000001\",\"sendTime\":1475230572699,\"toDeviceId\":\"test333\"},\"msgType\":9020,\"timeStamp\":1476341374563,\"token\":\"45754712bb188d73ea6ed687ea3559bb\"}";
//    NSData *test = [string dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [_asyncSocket readDataWithTimeout:-1 tag:0];
//    
//    [self getData:test];
//    
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSLog(@"11111111111111111111111  \n%@",result);

    [_asyncSocket readDataWithTimeout:-1 tag:0];

    [self getData:data];
    
}

//发送数据包
- (void)sendData:(NSString *)msgType msgId:(NSString *)msgId msgContent:(NSString *)msgContent mtoId:(NSString *)mtoId name:(NSString*)name portal:(NSString*)portal tel:(NSString*)tel company:(NSString*)company info:(NSString*)info linkMan:(NSString*)linkman withType:(NSInteger)type sellbuyid:(NSString*)sellbuyid{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000; //时间戳
    NSString * time = [[NSString stringWithFormat:@"%f",interval] substringToIndex:13];
    
//    NSString *msgTime = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld000",time]];
    
    NSString *str = [NSString stringWithFormat:@"cjsdys%@%@",[UserModel shareInstanced].userID,time];
    NSString *md5Str = [self md5:str];
    
    [dict setObject:[UserModel shareInstanced].userID forKey:@"deviceId"];
    [dict setObject:@"cjsdys" forKey:@"appId"];
    [dict setObject:md5Str forKey:@"token"];
    [dict setObject:time forKey:@"timeStamp"];
    [dict setObject:msgType forKey:@"msgType"];
    
    if ([msgType intValue] == 9010) {
        [dict setObject:msgContent forKey:@"msgContent"];
    }else if ([msgType intValue] == 9020){
        
        NSMutableDictionary *subDict = [[NSMutableDictionary alloc]init];
        [subDict setObject:msgId forKey:@"msgId"];
        [subDict setObject:mtoId forKey:@"toDeviceId"];
        [subDict setObject:[UserModel shareInstanced].userID forKey:@"fromDeviceId"];
        [subDict setObject:time forKey:@"sendTime"];
        
        NSMutableDictionary* subSubDict = [[NSMutableDictionary alloc]init];
        [subSubDict setObject:name forKey:@"name"];
        [subSubDict setObject:portal forKey:@"portal"];
        [subSubDict setObject:tel forKey:@"tel"];
        [subSubDict setObject:company forKey:@"company"];
        [subSubDict setObject:info forKey:@"info"];
        [subSubDict setObject:linkman forKey:@"linkman"];
        [subSubDict setObject:msgContent forKey:@"msg"];
        [subSubDict setObject:@(type) forKey:@"type"];
        [subSubDict setObject:sellbuyid forKey:@"sellbuyid"];
        
        [subDict setObject:subSubDict forKey:@"msgContent"];

        [dict setObject:subDict forKey:@"msgContent"];
//        NSLog(@"----dict===%@",dict);
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
    NSLog(@"json----%@",jsonString);
    
    [_asyncSocket writeData:data withTimeout:60 tag:10];
}

- (void)getData:(NSData *)data{
    
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *msgType = [dataDict objectForKey:@"msgType"];

    if ([msgType intValue] == 9020) {
        NSString *str = [dataDict objectForKey:@"msgContent"];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        
        NSString *msgId = [dict objectForKey:@"msgId"];
        
        NSString *mfrom = [dict objectForKey:@"fromDeviceId"];
        NSString *timeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sendTime"]];
        NSInteger time = [[timeStr substringToIndex:10] intValue];
        
//        NSString *mto = [dict objectForKey:@"toDeviceId"]; //用户id
        NSString *strs = [dict objectForKey:@"msgContent"];
        
        NSData *jsonDatas = [strs dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *msgContentDict = [NSJSONSerialization JSONObjectWithData:jsonDatas
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
//        NSDictionary *msgContentDict = [dict objectForKey:@"msgContent"];
        NSString* name = [msgContentDict objectForKey:@"name"];
        NSString* portal = [msgContentDict objectForKey:@"portal"];
        NSString* tel = [msgContentDict objectForKey:@"tel"];
        NSString* company = [msgContentDict objectForKey:@"company"];
        NSString* info = [msgContentDict objectForKey:@"info"];
        NSString* linkman = [msgContentDict objectForKey:@"linkman"];
        NSString* msg = [msgContentDict objectForKey:@"msg"];
        NSString* type = [msgContentDict objectForKey:@"type"];
        NSString* sellbuyid = [msgContentDict objectForKey:@"sellbuyid"];
        
        NSString *msgStatus = @"1";
        NSLog(@"jieshou---%@",msg);
        [[YSDatabase shareYSDatabase] saveMessage:msgType msgId:msgId mfromId:mfrom time:time mtoId:[UserModel shareInstanced].userID msgContentStr:msg msgStatusStr:msgStatus type:type];
        
        if (![[YSDatabase shareYSDatabase] isSaveFriendId:mfrom]) {
            [[YSDatabase shareYSDatabase]saveFriendList:mfrom fName:company contactname:name portal:portal tel:tel info:info linkman:linkman headimageurl:nil sellbuyid:sellbuyid msgStatus:@"1"];
        }else{
            [[YSDatabase shareYSDatabase]motifityTheFriendList:sellbuyid info:info linkman:linkman friendId:mfrom companyname:company andGQName:nil];
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataMsgList" object:self];
        
    }else if ([msgType intValue] == 9021){
//        NSString *msgStatus = @"发送成功";
//        [[YSDatabase shareYSDatabase] updateData:msgId msgStatusStr:msgStatus];
    }

}



#pragma mark - MD5
- (NSString *) md5:(NSString *) input {
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
//    NSString *str = [[NSString alloc] initWithCString:input encoding:gbkEncoding];
    
//    NSData *data = [input dataUsingEncoding: gbkEncoding];
//    const char *cStr=[data bytes];
//    const char *cStr = [input StringByReplacingPercentEscapesUsingEncoding];
    
    const char *cStr=[input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
