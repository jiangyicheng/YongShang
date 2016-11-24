//
//  ChatMessageViewController.h
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "BaseViewController.h"
@class RecordingView;

@interface ChatMessageViewController : BaseViewController
{
    RecordingView* _recordingView;
}
//供求id
@property (nonatomic,strong) NSString* sellbuyid;

@property(nonatomic, strong)NSString *qcId;
//公司名称
@property(nonatomic, strong)NSString *companyName;
// 供求
@property (nonatomic,strong) NSString* supplyAndDemandString;
//联系人
@property (nonatomic,strong) NSString* linkMan;
//联系电话
@property (nonatomic,strong) NSString* telPhone;
//头像
@property (nonatomic,strong) NSString* headImageUrl;
//供求
@property (nonatomic,strong) NSString* GQName;

@property (strong, nonatomic) NSDictionary *keyBoardDic;






@property (assign) BOOL isSpeak;

@property (strong, nonatomic) NSMutableArray *voiceArray;

@property (strong, nonatomic) NSString *fileName;

@property (assign) BOOL isPlaying;


@end
