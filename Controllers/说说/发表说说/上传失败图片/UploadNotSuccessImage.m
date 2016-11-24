//
//  UploadNotSuccessImage.m
//  YongShang
//
//  Created by 姜易成 on 16/10/23.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "UploadNotSuccessImage.h"
#import "OffLineMessageModel.h"
#import "ShuoshuoMainViewController.h"

@interface UploadNotSuccessImage ()
{
    NSMutableArray* _notSuccessImageArray;
    NSArray* _notSuccessImage64Array;
}
@end

@implementation UploadNotSuccessImage

+(UploadNotSuccessImage*)shareUpload
{
    static UploadNotSuccessImage* uploadimage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadimage = [[UploadNotSuccessImage alloc]init];
    });
    return uploadimage;
}


-(void)hahahaeithApp:(UIViewController *)app
{
    self.app = app;
}

-(void)loadImage
{
    [self uploadTheImageNotSuccess];
//    NSLog(@"hah a  sha l ba ");
}

/**
 *  读取离线消息
 */
-(void)readOfflineMessage
{
    [YSBLL readOfflinemessageResultBlock:^(ReadOfflineMessageModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [model.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OffLineMessageModel* messageModel = [OffLineMessageModel yy_modelWithJSON:obj];
                
                NSString* timeStr = [messageModel.sendTime substringToIndex:10];
                
                NSString *uuid = [[NSUUID UUID] UUIDString];
                [[YSDatabase shareYSDatabase]saveMessage:@"9020" msgId:uuid mfromId:messageModel.fromDeviceId time:[timeStr integerValue] mtoId:[UserModel shareInstanced].userID msgContentStr:messageModel.msg msgStatusStr:@"1" type:messageModel.type];
                
                if (![[YSDatabase shareYSDatabase] isSaveFriendId:messageModel.fromDeviceId]) {
                    [[YSDatabase shareYSDatabase]saveFriendList:messageModel.fromDeviceId fName:messageModel.company contactname:messageModel.name portal:messageModel.portal tel:messageModel.tel info:messageModel.info linkman:messageModel.linkman headimageurl:nil sellbuyid:messageModel.sellbuyid msgStatus:@"1"];
                }else{
                    [[YSDatabase shareYSDatabase]motifityTheFriendList:messageModel.sellbuyid info:messageModel.info linkman:messageModel.linkman friendId:messageModel.fromDeviceId companyname:messageModel.company andGQName:nil];
                }
            }];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败2");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误2");
        }
    }];
}

/**
 *  上传未成功的图片
 */
-(void)uploadPictureNormalWith:(NSMutableArray*)array andCount:(int)count
{
    if (count < _notSuccessImage64Array.count) {
        [YSBLL upLoadShuoShuoPictureWithFlagId:[UserModel shareInstanced].shuoshuoId andImageurl1:array[0] andImageurl2:array[1] andImageurl3:array[2] andImageurl4:array[3] andImageurl5:array[4] andImageurl6:array[5] andImageurl7:array[6] andImageurl8:array[7] andImageurl9:array[8] andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
            if ([model.ecode isEqualToString:@"0"]) {
                NSLog(@"说说图片上传成功～～～～%d",count);
                [UserModel shareInstanced].imageLastCount = [NSString stringWithFormat:@"%d",count];
                [self uploadImageArrChangedWithCount:count+1 andImageArray:_notSuccessImage64Array];
                [self uploadPictureNormalWith:_notSuccessImageArray andCount:count+1];
            }else if ([model.ecode isEqualToString:@"-2"]){
                NSLog(@"请求数据失败2");
            }else if ([model.ecode isEqualToString:@"-1"]){
                NSLog(@"异常错误2");
            }
        }];
    }
}

/**
 *  上传未成功的图片
 */
-(void)uploadTheImageNotSuccess
{
    NSLog(@"检测未上传的图片。。。。。。。。。。");
    if ([UserModel shareInstanced].imageLastCount != nil) {
        int imageLastCount = [[UserModel shareInstanced].imageLastCount intValue];
        int imageTotalCount = [[UserModel shareInstanced].imageTotalCount intValue];
        
        NSLog(@"zong %d  shengyu --%d",imageTotalCount,imageLastCount);
        
        if (imageLastCount != (imageTotalCount - 1) ) {
            NSArray* imageArr = [self readTheDataFromCachesFromPlistFile:@"imageNotUpload"];
            _notSuccessImage64Array = imageArr[0];
            NSLog(@"没成功个数---%ld",_notSuccessImage64Array.count);
            [self uploadImageArrChangedWithCount:imageLastCount+1 andImageArray:_notSuccessImage64Array];
            [self uploadPictureNormalWith:_notSuccessImageArray andCount:imageLastCount + 1];
    }
    }
}

-(void)uploadImageArrChangedWithCount:(int)count andImageArray:(NSArray*)imageArray
{
    _notSuccessImageArray =  [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 9; i++) {
        if (i < imageArray.count) {
            if (i == count) {
                [_notSuccessImageArray addObject:imageArray[i]];
            }else{
                [_notSuccessImageArray addObject:@""];
            }
            
        }else{
            [_notSuccessImageArray addObject:@""];
        }
    }
}

- (NSArray *)readTheDataFromCachesFromPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    return array;
}

//UIImage图片转成base64字符串
-(NSString*)imageChangeToBase64:(UIImage*)originImage
{
    NSData* data = UIImageJPEGRepresentation(originImage, 1.0f);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(originImage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(originImage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(originImage, 0.9);
        }
    }
    NSString* _encodeImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodeImageStr;
}


@end
