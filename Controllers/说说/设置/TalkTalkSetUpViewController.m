//
//  TalkTalkSetUpViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/8.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "TalkTalkSetUpViewController.h"

@interface TalkTalkSetUpViewController ()
{
    UISwitch* _chatStickSwitch;     //不让他看我的说说
    UISwitch* _blackListSwitch;     //不看他的说说
    BOOL _chatSelect;                //不让他看我的说说是否选中
    BOOL _blackSelect;               //不看他的说说是否选中
}
@property(nonatomic,strong)UIView* bgView;

@end

@implementation TalkTalkSetUpViewController

/*------------------------------网络------------------------------------*/

/**
*  权限设置   
*  1.fseemtalk，mseeftalk代表（0.是 1.否）每次两个参数只传递其中一个
*/
-(void)setLimitInterfaceWithFseemtalk:(NSString*)fseemtalk withMseeftalk:(NSString*)mseeftalk
{
    [YSBLL shuoshuoLimitsSetWithCompanyid:[UserModel shareInstanced].companyId andLimitcompanyid:self.limitCompanyId andFseemtalk:fseemtalk andMseeftalk:mseeftalk andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSLog(@"请求成功");
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

-(void)setLimitInterFace
{
    NSLog(@"----limit---%@",self.limitCompanyId);
    [YSBLL shuoshuoLimitsSetYinDaoWithCompanyid:[UserModel shareInstanced].companyId andLimitcompanyid:self.limitCompanyId andResultBlock:^(SSLimitSetModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            if ([model.fseemtalk isEqualToString:@"1"]) {
                _chatSelect = NO;
            }else if ([model.fseemtalk isEqualToString:@"0"]){
                _chatSelect = YES;
            }
            
            if ([model.mseeftalk isEqualToString:@"1"]) {
                _blackSelect = NO;
            }else if ([model.mseeftalk isEqualToString:@"0"]){
                _blackSelect = YES;
            }
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self.view addSubview:self.bgView];
        [self createsubViews];
    }];
}

/*------------------------------页面------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"权限设置"];
    [self setLimitInterFace];
}

#pragma mark - function

//不让他看我的说说
-(void)isOpenChatStick:(UISwitch*)swi
{
    BOOL chatSelect = [swi isOn];
    NSString* fseemtalk = [NSString string];
    if (chatSelect) {
        fseemtalk = @"0";
    }else{
        fseemtalk = @"1";
    }
    [self setLimitInterfaceWithFseemtalk:fseemtalk withMseeftalk:@""];
}

//不看他的说说
-(void)isOpenBlackListStick:(UISwitch*)swi
{
    BOOL blackSelect = [swi isOn];
    NSString* mseeftalk = [NSString string];
    if (blackSelect) {
        mseeftalk = @"0";
    }else{
        mseeftalk = @"1";
    }
    [self setLimitInterfaceWithFseemtalk:@"" withMseeftalk:mseeftalk];
}


#pragma mark - Init

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(40), SCREEN_WIDTH, getNumWithScanf(78+79))];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}

-(void)createsubViews
{
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), 0, getNumWithScanf(220), getNumWithScanf(78))];
    firstLab.text = @"不让他看我的说说";
    firstLab.textColor = getColor(@"4b4b4b");
    firstLab.font = DEF_FontSize_13;
    [_bgView addSubview:firstLab];
    
    _chatStickSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - getNumWithScanf(25), getNumWithScanf(39) - 31/2, 51, 31)];
    _chatStickSwitch.backgroundColor = getColor(@"ffffff");
    _chatStickSwitch.onTintColor = getColor(@"4cdb63");
    _chatStickSwitch.tintColor = getColor(@"aeaeae");
    _chatStickSwitch.thumbTintColor = getColor(@"ffffff");
    [_chatStickSwitch setOn:_chatSelect];
    [_chatStickSwitch addTarget:self action:@selector(isOpenChatStick:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:_chatStickSwitch];
    
    UIView* firstLineView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(78), SCREEN_WIDTH - getNumWithScanf(40), 0.5)];
    firstLineView.backgroundColor = getColor(@"dddddd");
    [_bgView addSubview:firstLineView];
    
    
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(79), getNumWithScanf(220), getNumWithScanf(78))];
    secondLab.text = @"不看他的说说";
    secondLab.textColor = getColor(@"4b4b4b");
    secondLab.font = DEF_FontSize_13;
    [_bgView addSubview:secondLab];
    
    _blackListSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - getNumWithScanf(25), getNumWithScanf(39+79) - 31/2, 51, 31)];
    _blackListSwitch.backgroundColor = getColor(@"ffffff");
    _blackListSwitch.onTintColor = getColor(@"4cdb63");
    _blackListSwitch.tintColor = getColor(@"aeaeae");
    _blackListSwitch.thumbTintColor = getColor(@"ffffff");
    [_blackListSwitch setOn:_blackSelect];
    [_blackListSwitch addTarget:self action:@selector(isOpenBlackListStick:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:_blackListSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
