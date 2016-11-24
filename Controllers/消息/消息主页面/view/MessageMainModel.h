//
//  MessageMainModel.h
//  YongShang
//
//  Created by user on 16/10/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageMainModel : NSObject

@property (nonatomic,assign) NSInteger timestr;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *friendId;

@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString* contactname;

@property (nonatomic,strong) NSString* portal;

@property (nonatomic,strong) NSString* contactTel;

@property (nonatomic,strong) NSString* info;

@property (nonatomic,strong) NSString* GQName;

@property (nonatomic,copy) NSString* sellbuyid;


@end
