//
//  NormalEnterPriseCricleDetailViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "NormalEnterPriseCricleDetailViewController.h"
#import "EnterPriseRoomTableViewCell.h"
#import "NormalEnterPriseCricleDetailTableViewCell.h"
#import "EnterPriseDisPlayRoomDetailViewController.h"
#import "MyDisplayRoomFinishViewController.h"
#import "EnterPriseListViewController.h"

@interface NormalEnterPriseCricleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,QuitEnterPriseCricleDelegate,AlertViewDelegate>
{
    NSString* _descriptionString;    //描述文字
    CGFloat _descriptionLabHeight;   //文字高度
    UIButton* _blackBtn;
    NSMutableArray* _mainListArray;
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
}
@property(nonatomic,strong)UILabel* descriptionLab;   //描述圈子详情
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)UIView* bgview;

@end

@implementation NormalEnterPriseCricleDetailViewController

/*------------------------------网络------------------------------------*/

-(void)loadEnterPriseDetailWithNet
{
    [self showprogressHUD];
    [YSBLL getEnterPriseDetailWithUnionid:self.unionId andResultBlock:^(YSEnterPriseDetailsModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _mainListArray = [[NSMutableArray alloc]init];
            [model.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseDetailModel* model = [YSEnterPriseDetailModel yy_modelWithDictionary:obj];
                [_mainListArray addObject:model];
            }];
            _descriptionString = model.memo;
            _descriptionLabHeight = MAX([self kdetailTextHeight:_descriptionString width:getNumWithScanf(450)], getNumWithScanf(30)) ;
            [self.view addSubview:self.mainTableView];
            [self.mainTableView reloadData];
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
            [MBProgressHUD showError:@"该圈子不存在"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  企业圈子邀请接受、拒绝操作、退出圈子（1:待验证 2:接受邀请 0:拒绝邀请 3::退出圈子）
 */
-(void)acceptTheInvitionWithFlagType:(NSString*)flagtype
{
    [self showprogressHUD];
    [YSBLL enterPriseAcceptInvitedWithUnion:self.unionId andCompanyId:[UserModel shareInstanced].companyId andFlagType:flagtype andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSLog(@"%@",model.emessage);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)viewWillAppear:(BOOL)animated
{
   [self loadEnterPriseDetailWithNet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:self.navTitle];
    [self createNavTitle];
}

-(void)createNavTitle
{
    UIButton* inviteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    inviteBtn.titleLabel.font = DEF_FontSize_13;
    [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [inviteBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(inviteEnterPriseCricleClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* inviteItem = [[UIBarButtonItem alloc]initWithCustomView:inviteBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.rightBarButtonItems = @[spaceItem,inviteItem];
}

#pragma mark - function

/**
 *  邀请企业进入圈子
 */
-(void)inviteEnterPriseCricleClick
{
    EnterPriseListViewController* evc = [[EnterPriseListViewController alloc]init];
    evc.rightItemString = @"添加";
    evc.status = @"4";
    evc.unionId = self.unionId;
    evc.inviteModelArray = _mainListArray;
    [self.navigationController pushViewController:evc animated:YES];
}

/**
 *  退出圈子
 */
-(void)quitBtnDidClick
{
    [self showAlertView];
}

/**
 *  提示框确定按钮点击事件
 */
-(void)alertViewConfirmBtnClick
{
    [self hiddenAlertView];
    [self acceptTheInvitionWithFlagType:@"3"];
}

/**
 *  提示框取消按钮点击事件
 */
-(void)alertViewCancleBtnClick
{
    [self hiddenAlertView];
}

/**
 *  提示框展示
 */
-(void)showAlertView
{
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    _alertView = [[AlertView alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(530), getNumWithScanf(200))];
    _blackView = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    _alertView.center = _blackView.center;
    _alertView.layer.cornerRadius = 5;
    _alertView.contentlab.text = @"您是否确定退出该圈子";
    _alertView.layer.masksToBounds = YES;
    _alertView.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    [_blackView addSubview:_alertView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

/**
 *  提示框消失
 */
-(void)hiddenAlertView
{
    [UIView animateWithDuration:0.2 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _alertView.hidden = YES;
    } completion:^(BOOL finished) {
        _blackView.hidden = YES;
        [_blackView removeFromSuperview];
    }];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Init
-(UIView *)bgview
{
    if (!_bgview) {
        _bgview  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _descriptionLabHeight+20)];
        _bgview.backgroundColor = getColor(@"f5f5f5");
        _descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - getNumWithScanf(450))/2, 10,getNumWithScanf(450), _descriptionLabHeight)];
        _descriptionLab.text = _descriptionString;
        _descriptionLab.textAlignment = NSTextAlignmentCenter;
        _descriptionLab.textColor = getColor(@"999999");
        //        _descriptionLab.backgroundColor = [UIColor redColor];
        _descriptionLab.font = DEF_FontSize_11;
        _descriptionLab.numberOfLines = 0;
        [_bgview addSubview:_descriptionLab];
    }
    return _bgview;
}


/**
 *  主列表
 *
 *  @return self
 */
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(0), SCREEN_WIDTH, SCREEN_HEIGHT - 64 )];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.bgview;
        //注册cell
        [_mainTableView registerClass:[EnterPriseRoomTableViewCell class] forCellReuseIdentifier:@"enterPriseId"];
        [_mainTableView registerClass:[NormalEnterPriseCricleDetailTableViewCell class] forCellReuseIdentifier:@"normalEnterPriseId"];
    }
    return _mainTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mainListArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _mainListArray.count) {
        NormalEnterPriseCricleDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"normalEnterPriseId"];
        cell.backgroundColor = getColor(@"f7f7f7");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    EnterPriseRoomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"enterPriseId"];
    cell.backgroundColor = getColor(@"f7f7f7");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailModel = _mainListArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _mainListArray.count) {
        return getNumWithScanf(228);
    }
    return getNumWithScanf(140);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSEnterPriseDetailModel* model = _mainListArray[indexPath.row];
//    if ([model.enterPriseId integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
//        MyDisplayRoomFinishViewController* mvc = [[MyDisplayRoomFinishViewController alloc]init];
//        [self.navigationController pushViewController:mvc animated:YES];
//    }else{
        EnterPriseDisPlayRoomDetailViewController* evc =[[EnterPriseDisPlayRoomDetailViewController alloc]init];
        evc.enterPriseId = model.enterPriseId;
        [self.navigationController pushViewController:evc animated:YES];
        
//    }
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
