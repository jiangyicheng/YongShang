//
//  ChatSetViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ChatSetViewController.h"

@interface ChatSetViewController ()
{
    UISwitch* _chatStickSwitch;     //聊天置顶
    UISwitch* _blackListSwitch;     //黑名单
    BOOL _isInBlackList;
}
@property(nonatomic,strong)UIView* bgView;

@end

@implementation ChatSetViewController

/*------------------------------网络------------------------------------*/

/**
*  加入黑名单 （0:为不加入黑名单，1加入黑名单）
*/
-(void)addToBlcakListWith:(NSString*)flagType
{
    [YSBLL addToBlackListWithRecipientuid:[UserModel shareInstanced].userID andBrecipientuid:self.userId andFlagType:flagType andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            if ([flagType isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"已加入黑名单"];
            }else if ([flagType isEqualToString:@"0"]){
                [MBProgressHUD showSuccess:@"已移出黑名单"];
            }
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  是否加入黑名单
 */
-(void)selectIsInBlackList
{
    [YSBLL selectTheBlackListWithRecipientuid:[UserModel shareInstanced].userID andBrecipientuid:self.userId andResultBlock:^(id responseObj, NSError *error) {
        NSString* isSuccess = responseObj[@"ecode"];
        NSLog(@"ecode---%@",isSuccess);
        if ([isSuccess isEqualToString:@"0"]) {
            NSString* isBlackList = [responseObj[@"data"][@"isblacklist"] stringValue];
            
            if ([isBlackList isEqual:@"0"]) {
                _isInBlackList = NO;
            }else if([isBlackList isEqualToString:@"1"]){
                _isInBlackList = YES;
            }
            [self createsubViews];
        }else if ([isSuccess isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([isSuccess isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"聊天设置"];
    [self.view addSubview:self.bgView];
    [self selectIsInBlackList];
}

#pragma mark - function

-(void)reportBtnClick
{
    ReportViewController* rvc = [[ReportViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}


-(void)isOpenChatStick:(UISwitch*)swit
{
    BOOL isIn = swit.on;
//    NSString* str = [NSString stringWithFormat:@"%d",isIn];
//    NSLog(@"%@",str);
    if (isIn) {
        [self addToBlcakListWith:@"1"];
    }else{
        [self addToBlcakListWith:@"0"];
    }
}

#pragma mark - Init

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(40), SCREEN_WIDTH, getNumWithScanf(78))];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}

-(void)createsubViews
{
//    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), 0, getNumWithScanf(130), getNumWithScanf(78))];
//    firstLab.text = @"聊天置顶";
//    firstLab.textColor = getColor(@"4b4b4b");
//    firstLab.font = DEF_FontSize_13;
//    [_bgView addSubview:firstLab];
//    
//    _chatStickSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - getNumWithScanf(25), getNumWithScanf(39) - 31/2, 51, 31)];
//    _chatStickSwitch.backgroundColor = getColor(@"ffffff");
//    _chatStickSwitch.onTintColor = getColor(@"4cdb63");
//    _chatStickSwitch.tintColor = getColor(@"aeaeae");
//    _chatStickSwitch.thumbTintColor = getColor(@"ffffff");
////    [_chatStickSwitch setOn:_isInBlackList];
////    [_chatStickSwitch addTarget:self action:@selector(isOpenChatStick:) forControlEvents:UIControlEventValueChanged];
//    [_bgView addSubview:_chatStickSwitch];
//    
//    UIView* firstLineView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(78), SCREEN_WIDTH - getNumWithScanf(40), 0.5)];
//    firstLineView.backgroundColor = getColor(@"dddddd");
//    [_bgView addSubview:firstLineView];
    
    
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(0), getNumWithScanf(220), getNumWithScanf(78))];
    secondLab.text = @"将对方加入黑名单";
    secondLab.textColor = getColor(@"4b4b4b");
    secondLab.font = DEF_FontSize_13;
    [_bgView addSubview:secondLab];
    
    _blackListSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - getNumWithScanf(25), getNumWithScanf(39) - 31/2, 51, 31)];
    _blackListSwitch.backgroundColor = getColor(@"ffffff");
    _blackListSwitch.onTintColor = getColor(@"4cdb63");
    _blackListSwitch.tintColor = getColor(@"aeaeae");
    _blackListSwitch.thumbTintColor = getColor(@"a5a5a5");
    [_blackListSwitch setOn:_isInBlackList];
        [_blackListSwitch addTarget:self action:@selector(isOpenChatStick:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:_blackListSwitch];
    
    UIView* secondLineView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(78+79), SCREEN_WIDTH - getNumWithScanf(40), 0.5)];
    secondLineView.backgroundColor = getColor(@"dddddd");
    secondLineView.hidden = YES;
    [_bgView addSubview:secondLineView];
    
    UILabel* thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(79+79), getNumWithScanf(130), getNumWithScanf(78))];
    thirdLab.text = @"举报对方";
    thirdLab.textColor = getColor(@"4b4b4b");
    thirdLab.font = DEF_FontSize_13;
    thirdLab.hidden = YES;
    [_bgView addSubview:thirdLab];
    
    UIImageView* nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - getNumWithScanf(25)-getNumWithScanf(15/2) , getNumWithScanf(39+79*2) - getNumWithScanf(15), getNumWithScanf(15), getNumWithScanf(30))];
    nextImageView.image = [UIImage imageNamed:@"next"];
    nextImageView.hidden = YES;
    [_bgView addSubview:nextImageView];
    
    UIButton* nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, getNumWithScanf(78+79), SCREEN_WIDTH, getNumWithScanf(78))];
    nextBtn.backgroundColor = [UIColor clearColor];
    [nextBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.hidden = YES;
    [_bgView addSubview:nextBtn];
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
