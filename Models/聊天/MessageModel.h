//
//  MessageModel.h
//  XinChengOA
//
//  Created by 姜易成 on 16/7/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KMessageModelTypeOther,
    KMessagemodelTypeMe
}MessageModelType;

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString* text;
@property (nonatomic,copy) NSString* time;
@property (nonatomic,assign) NSInteger timestr;
@property (nonatomic,assign) MessageModelType type;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic,copy) NSString* messageType;

+(id)messageModelWithDict:(NSDictionary*)dict;

@end
