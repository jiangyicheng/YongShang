//
//  EnterPriseCricleDetailViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseCricleDetailViewController.h"
#import "EnterPriseRoomTableViewCell.h"
#import "EnterPriseListViewController.h"
#import "EnterPriseDisPlayRoomDetailViewController.h"
#import "MyDisplayRoomFinishViewController.h"
#import "YSEnterPriseDetailModel.h"
#import "MotifityMemoView.h"

@interface EnterPriseCricleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MoreFunctionDelegate,AlertViewDelegate,MotifityMemoDelegate>
{
    NSString* _descriptionString;    //描述文字
    CGFloat _descriptionLabHeight;   //文字高度
    NSMutableArray* _mainListArray;
    UIButton* _blackBtn;
    NSMutableArray* _selectedArray;
    MotifityMemoView* _motiMemoView;
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
}
@property(nonatomic,strong)UILabel* descriptionLab;   //描述圈子详情
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)moreFunctionAlertView* moreFunctionView; //更多功能
@property(nonatomic,strong)UIView* bgview;
@property(nonatomic,strong)UIView* footerView;
@end

@implementation EnterPriseCricleDetailViewController

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
            NSLog(@"描述文字－－－－%@",_descriptionString);
            [self.view addSubview:self.mainTableView];
            [self.mainTableView reloadData];
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        
        NSLog(@"unionid===%@",self.unionId);
        [self hiddenProgressHUD];
    }];
}

/**
 *  解散圈子
 */
-(void)cancleTheCricle
{
    [YSBLL cancleTheCricleWithUnionid:self.unionId andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"该圈子已被解散"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  修改备注
 */
-(void)MotifityTheCricleMemo
{
    [YSBLL motifityTheCricleMemoWithUnionid:self.unionId Memo:_motiMemoView.memoTextView.text andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [_mainTableView removeFromSuperview];
            [self loadEnterPriseDetailWithNet];
            [MBProgressHUD showSuccess:@"备注修改成功"];
            [self hideMotifityView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadEnterPriseDetailWithNet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle* root_bundle = [NSBundle bundleWithPath:[UserModel shareInstanced].root_bundle];
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"moreFunction" inBundle:root_bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStyleDone target:self action:@selector(moreFunctionClick)];
    self.navigationItem.rightBarButtonItem = moreItem;
    [self NavTitle:self.navTitle];
    
    //接收通知（选择的企业）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedEnterPriseSEL:) name:@"DidSelectedEnterPrise" object:nil];
}

#pragma mark - function

/**
 *  修改圈子备注
 *
 *  @param longGestureRecongnizer 
 */
-(void)motifityTheMemo:(UILongPressGestureRecognizer *)longGestureRecongnizer
{
    if ([longGestureRecongnizer state] == UIGestureRecognizerStateBegan) {
        [self showMotiFityView];
    }
}

/**
 *  选择企业回调方法
 *
 *  @param noti noti
 */
-(void)selectedEnterPriseSEL:(NSNotification*)noti
{
    _selectedArray = noti.userInfo[@"selectedEnterPrise"];
}

/**
 *  解散圈子
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
    [self cancleTheCricle];
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
    _alertView.contentlab.text = @"是否确定解散该圈子";
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

/**
 *  更多功能
 */
-(void)moreFunctionClick
{
    [self showMoreFunctionView];
}

/**
 *  更多功能显示
 */
-(void)showMoreFunctionView
{
    _blackBtn = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    [_blackBtn addTarget:self action:@selector(hideMoreFunctionView) forControlEvents:UIControlEventTouchUpInside];
    _blackBtn.backgroundColor = [UIColor clearColor];
    self.moreFunctionView.addNewEpBtn.hidden = NO;
    self.moreFunctionView.deleteEpBtn.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:_blackBtn];
    [_blackBtn addSubview:self.moreFunctionView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moreFunctionView.frame = CGRectMake(SCREEN_WIDTH - getNumWithScanf(340), 64, getNumWithScanf(320), getNumWithScanf(160));
    }];
}

/**
 *  更多功能隐藏
 */
-(void)hideMoreFunctionView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.moreFunctionView.addNewEpBtn.hidden = YES;
        self.moreFunctionView.deleteEpBtn.hidden = YES;
        self.moreFunctionView.frame = CGRectMake(SCREEN_WIDTH - getNumWithScanf(20), 64, 2, 2);
    } completion:^(BOOL finished) {
        _blackBtn.hidden = YES;
        [_blackBtn removeFromSuperview];
    }];
}

/**
 *  修改备注
 */
-(void)MotifityMemoDidSelect
{
    if (_motiMemoView.memoTextView.text.length == 0) {
        [self showMessage:@"请输入备注内容"];
        return;
    }
    [self MotifityTheCricleMemo];
}

/**
 *  修改备注框展示
 */
-(void)showMotiFityView
{
    _blackBtn = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    [_blackBtn addTarget:self action:@selector(hideMotifityView) forControlEvents:UIControlEventTouchUpInside];
    _blackBtn.backgroundColor = [UIColor clearColor];
    _motiMemoView = [[MotifityMemoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - getNumWithScanf(200), getNumWithScanf(430))];
    _motiMemoView.centerX = _blackBtn.centerX;
    _motiMemoView.centerY = _blackBtn.centerY - 32;
    _motiMemoView.memoTextView.text = _descriptionString;
    _motiMemoView.backgroundColor = [UIColor whiteColor];
    _motiMemoView.layer.cornerRadius = 8;
    _motiMemoView.layer.masksToBounds = YES;
    _motiMemoView.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blackBtn];
    [_blackBtn addSubview:_motiMemoView];
    
    [UIView animateWithDuration:0.2 animations:^{
        _blackBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
    
}

/**
 *  修改备注框隐藏
 */
-(void)hideMotifityView
{
    [UIView animateWithDuration:0.2 animations:^{
        _motiMemoView.hidden = YES;
        _blackBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        _blackBtn.hidden = YES;
        [_blackBtn removeFromSuperview];
    }];
}

/**
 *  添加企业
 */
-(void)firstfunctionDidSelect
{
    EnterPriseListViewController* evc = [[EnterPriseListViewController alloc]init];
    evc.rightItemString = @"添加";
    evc.status = @"2";
    evc.unionId = self.unionId;
    evc.alreadyPresentModelArray = _mainListArray;
    [self hideMoreFunctionView];
    [self.navigationController pushViewController:evc animated:YES];
}

/**
 *  删除企业
 */
-(void)secondFunctionDidSelect
{
    EnterPriseListViewController* evc = [[EnterPriseListViewController alloc]init];
    evc.rightItemString = @"删除";
    evc.status = @"3";
    evc.unionId = self.unionId;
    evc.deleteModelArray = _mainListArray;
    [self hideMoreFunctionView];
    [self.navigationController pushViewController:evc animated:YES];
}

#pragma mark - Init

-(UIView *)bgview
{
//    if (!_bgview) {
        _bgview  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _descriptionLabHeight+20)];
        _bgview.backgroundColor = getColor(@"f5f5f5");
        _descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - getNumWithScanf(450))/2, 10,getNumWithScanf(450), _descriptionLabHeight)];
        _descriptionLab.text = _descriptionString;
        _descriptionLab.textAlignment = NSTextAlignmentCenter;
        _descriptionLab.textColor = getColor(@"999999");
        _descriptionLab.font = DEF_FontSize_12;
        _descriptionLab.numberOfLines = 0;
        [_bgview addSubview:_descriptionLab];
        _descriptionLab.userInteractionEnabled = YES;
        UILongPressGestureRecognizer* longTouch = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(motifityTheMemo:)];
        longTouch.minimumPressDuration = 0.5;
        [_descriptionLab addGestureRecognizer:longTouch];
//    }
    return _bgview;
}

-(UIView *)footerView
{
//    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(240))];
        _footerView.backgroundColor = getColor(@"f5f5f5");
        UIButton* quitBtn = [[UIButton alloc]initWithFrame:CGRectMake(getNumWithScanf(30), getNumWithScanf(80), SCREEN_WIDTH - getNumWithScanf(60), getNumWithScanf(80))];
        [quitBtn setTitle:@"解散圈子" forState:UIControlStateNormal];
        [quitBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        quitBtn.backgroundColor = getColor(@"3fbefc");
        quitBtn.layer.masksToBounds = YES;
        quitBtn.layer.cornerRadius = 5;
        [quitBtn addTarget:self action:@selector(quitBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        quitBtn.titleLabel.font = DEF_FontSize_13;
        [_footerView addSubview:quitBtn];
//    }
    return _footerView;
}

/**
 *  更多功能
 *
 *  @return self
 */
-(moreFunctionAlertView *)moreFunctionView
{
    if (!_moreFunctionView) {
        _moreFunctionView = [[moreFunctionAlertView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - getNumWithScanf(20), 64, 2, 2)];
        _moreFunctionView.firstBtnString = @"添加企业";
        _moreFunctionView.secondBtnString = @"删除企业";
        _moreFunctionView.delegate = self;
    }
    return _moreFunctionView;
}

/**
 *  主列表
 *
 *  @return self
 */
-(UITableView *)mainTableView
{
//    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(0), SCREEN_WIDTH, SCREEN_HEIGHT - 64 )];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.bgview;
        _mainTableView.tableFooterView = self.footerView;
        
        //注册cell
        [_mainTableView registerClass:[EnterPriseRoomTableViewCell class] forCellReuseIdentifier:@"enterPriseId"];
//    }
    return _mainTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mainListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterPriseRoomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"enterPriseId"];
    cell.backgroundColor = getColor(@"f7f7f7");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailModel = _mainListArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
