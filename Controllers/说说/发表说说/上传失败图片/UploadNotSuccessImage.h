//
//  UploadNotSuccessImage.h
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadNotSuccessImage : NSObject

@property (nonatomic,strong) UIViewController* app;
+(UploadNotSuccessImage*)shareUpload;
-(void)loadImage;
-(void)readOfflineMessage;
-(void)hahahaeithApp:(UIViewController*)app;
@end
