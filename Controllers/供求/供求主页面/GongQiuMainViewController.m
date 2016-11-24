//
//  GongQiuMainViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "GongQiuMainViewController.h"
#import "AddNewSupplyAndDemandViewController.h"
#import "MySupplyAndDemandViewController.h"
#import "SupplyAndDemandDetailViewController.h"
#import "GQSupplyAndBuyDetailModel.h"
#import "YSIndustryTypeModel.h"
#define KTag 10

@interface GongQiuMainViewController ()<TopMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,MoreFunctionDelegate>
{
    UIButton* _blackBtn;
    NSMutableArray* _mainListArray;
    NSMutableArray* _categoryIDArray;
    NSString* _topMenuString;
    GQSupplyAndBuyModel* _supplyBuyModel;
}
@property(nonatomic,strong)TopMenuView* topMenu;
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)moreFunctionAlertView* moreFunctionView; //更多功能

@end

@implementation GongQiuMainViewController

/*------------------------------网络------------------------------------*/

/**
*  供应或求购
*/
-(void)loadDownListArray
{
//    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/typeDetails.do?lxtype=3&u_code=%@",[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _categoryIDArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSIndustryTypeModel* industryModel = [YSIndustryTypeModel yy_modelWithJSON:obj];
                [_categoryIDArray addObject:industryModel.industryId];
            }];
//            [self loadMainListDataWithType:@"" andCreateId:[UserModel shareInstanced].companyId];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
//        [self hiddenProgressHUD];
    }];
}

/**
 *  供求明细接口
 *
 *  @param type     供求类型
 *  @param createId 登陆用户企业编号
 */
-(void)loadMainListDataWithType:(NSString*)type andCreateId:(NSString*)createId
{
    [self showprogressHUD];
    [YSBLL SupplyAndBuyDetailWithlxtype:type andCreatecid:createId andOrgid:[UserModel shareInstanced].tradeId andResultBlock:^(GQSupplyAndBuyModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
//            NSLog(@"====%@======%@",model.friendids,model.dataList);
            _supplyBuyModel = model;
            _mainListArray = [[NSMutableArray alloc]init];
            for (NSInteger i = model.dataList.count - 1; i >= 0; i--) {
                GQSupplyAndBuyDetailModel* GQmodel = [GQSupplyAndBuyDetailModel yy_modelWithJSON:model.dataList[i]];
                [_mainListArray addObject:GQmodel];
            }
            NSLog(@"%ld",_mainListArray.count);
//            [model.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                GQSupplyAndBuyDetailModel* GQmodel = [GQSupplyAndBuyDetailModel yy_modelWithJSON:obj];
//                [_mainListArray addObject:GQmodel];
//                NSLog(@"model.company===%@",GQmodel.supplyInfoId);
//            }];
            
            [self.mainTableView reloadData];
        }else if ([model.ecode isEqualToString:@"-2"]){
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
    [super viewWillAppear:animated];
    if (_topMenuString) {
        [self loadMainListDataWithType:_topMenuString andCreateId:[UserModel shareInstanced].companyId];
    }else{
        [self loadMainListDataWithType:@"" andCreateId:[UserModel shareInstanced].companyId];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topMenu];
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"moreFunction"] style:UIBarButtonItemStyleDone target:self action:@selector(moreFunctionClick)];
    self.navigationItem.rightBarButtonItem = moreItem;
    [self.view addSubview:self.mainTableView];
    [self loadDownListArray];
}

#pragma mark - function
/**
 *  点击顶部菜单
 *
 *  @param btn 对应点击的按钮
 */
-(void)topViewMenuDidClickWithBtn:(UIButton *)btn
{
    if (btn.tag == KTag + 1) {
        [self loadMainListDataWithType:@"" andCreateId:[UserModel shareInstanced].companyId];
        _topMenuString = @"";
    }else if (btn.tag == KTag + 2)
    {
       [self loadMainListDataWithType:_categoryIDArray[0] andCreateId:[UserModel shareInstanced].companyId];
        _topMenuString = _categoryIDArray[0];
    }else if(btn.tag == KTag +3)
    {
        [self loadMainListDataWithType:_categoryIDArray[1] andCreateId:[UserModel shareInstanced].companyId];
        _topMenuString = _categoryIDArray[1];
    }
    NSLog(@"_topMenuString--%@",_topMenuString);
}

/**
 *  更多功能
 */
-(void)moreFunctionClick
{
    [self showMoreFunctionView];
}

/**
 *  新增供求
 */
-(void)firstfunctionDidSelect
{
    AddNewSupplyAndDemandViewController* avc = [[AddNewSupplyAndDemandViewController alloc]init];
    [self hideMoreFunctionView];
    [self.navigationController pushViewController:avc animated:YES];
}

/**
 *  我的供求
 */
-(void)secondFunctionDidSelect
{
    MySupplyAndDemandViewController* mvc = [[MySupplyAndDemandViewController alloc]init];
    [self hideMoreFunctionView];
    [self.navigationController pushViewController:mvc animated:YES];
}

#pragma mark - Init

/**
 *  顶部菜单
 *
 *  @return self
 */
-(TopMenuView *)topMenu
{
    if (!_topMenu) {
        _topMenu = [[TopMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(85))];
        _topMenu.delegate = self;
    }
    return _topMenu;
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
        _moreFunctionView.firstBtnString = @"新增供求";
        _moreFunctionView.secondBtnString = @"我的供求";
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
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(91), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - getNumWithScanf(91) - 49)];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [_mainTableView registerClass:[EnterPriseRoomTableViewCell class] forCellReuseIdentifier:@"enterPriseId"];
    }
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
    cell.GQModel = _mainListArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(140);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupplyAndDemandDetailViewController* svc = [[SupplyAndDemandDetailViewController alloc]init];
    GQSupplyAndBuyDetailModel* model = _mainListArray[indexPath.row];
    svc.flagId = model.supplyInfoId;
    svc.friendsId = _supplyBuyModel.friendids;
    [self.navigationController pushViewController:svc animated:YES];
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
