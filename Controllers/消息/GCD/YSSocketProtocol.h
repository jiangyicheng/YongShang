//
//  SocketProtocol.h
//  YongShang
//
//  Created by user on 16/10/10.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSSocketProtocol : NSObject
<GCDAsyncSocketDelegate>

@property(nonatomic, strong)NSString *tag;

@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;

+ (YSSocketProtocol *)shareSocketProtocol;

- (void)socketConnect;
- (void)closeSocket;
- (void)sendData:(NSString *)msgType msgId:(NSString *)msgId msgContent:(NSString *)msgContent mtoId:(NSString *)mtoId name:(NSString*)name portal:(NSString*)portal tel:(NSString*)tel company:(NSString*)company info:(NSString*)info linkMan:(NSString*)linkman withType:(NSInteger)type sellbuyid:(NSString*)sellbuyid;

@end
