//
//  SSLimitSetModel.h
//  YongShang
//
//  Created by 姜易成 on 16/10/9.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSLimitSetModel : NSObject

@property (nonatomic,copy) NSString* ecode;

@property (nonatomic,copy) NSString* emessage;


//不让他看我的说说(0 是 1 否)
@property (nonatomic,copy) NSString* fseemtalk;

//不看他的说说(0:是  1:否)
@property (nonatomic,copy) NSString* mseeftalk;

@end
