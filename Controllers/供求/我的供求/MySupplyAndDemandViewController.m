//
//  MySupplyAndDemandViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/4.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MySupplyAndDemandViewController.h"
#import "MySupplyAndDemandTableViewCell.h"
#import "SupplyAndDemandDetailViewController.h"
#import "AddNewSupplyAndDemandViewController.h"
#import "RePublishSellAndBuyViewController.h"
#import "YSIndustryTypeModel.h"
#define KTag 10

@interface MySupplyAndDemandViewController ()<TopMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,MySupplyAndDemandDelegate,AlertViewDelegate>
{
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
    NSMutableArray* _mainListArray;
    NSMutableArray* _categoryIDArray;
    NSString* _supplyAndDemandId;    //供求编号
    UIButton* _publishCancleBtn;     //取消发布
}
@property(nonatomic,strong)TopMenuView* topMenu;
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)NSString* clickBtnString;

@end

@implementation MySupplyAndDemandViewController

/*------------------------------网络------------------------------------*/

/**
*  供应或求购
*/
-(void)loadDownListArray
{
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/typeDetails.do?lxtype=3&u_code=%@",[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _categoryIDArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YSIndustryTypeModel* industryModel = [YSIndustryTypeModel yy_modelWithJSON:obj];
            [_categoryIDArray addObject:industryModel.industryId];
        }];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  我的供求接口
 *
 *  @param type     供应或求购
 *  @param createId 公司ID
 */
-(void)loadMainListDataWithType:(NSString*)type
{
    [self showprogressHUD];
    [YSBLL MySupplyAndBuyDetailWithlxtype:type andCreatecid:[UserModel shareInstanced].userID andResultBlock:^(GQSupplyAndBuyModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
//            NSLog(@"====%@======%@",model.friendids,model.dataList);
            _mainListArray = [[NSMutableArray alloc]init];
            
            for (NSInteger i = model.dataList.count - 1; i >= 0; i--) {
                GQSupplyAndBuyDetailModel* GQmodel = [GQSupplyAndBuyDetailModel yy_modelWithJSON:model.dataList[i]];
                [_mainListArray addObject:GQmodel];
            }
            
//            [model.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                GQSupplyAndBuyDetailModel* GQmodel = [GQSupplyAndBuyDetailModel yy_modelWithJSON:obj];
//                [_mainListArray addObject:GQmodel];
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

/**
 *  供求信息的撤销
 */
-(void)revocationOrPublishTheSupplyAndDemandWithFlagId:(NSString*)flagId andWithBtn:(UIButton*)btn
{
    [YSBLL revocationTheInfoWithFlagId:flagId andCreatecid:[UserModel shareInstanced].userID andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            
//            [self showTemplantMessage:@"取消成功"];
            [MBProgressHUD showSuccess:@"取消成功"];
            if (self.clickBtnString) {
                [self loadMainListDataWithType:self.clickBtnString];
            }else {
                [self loadMainListDataWithType:@""];
            }
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限取消供求" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.clickBtnString) {
        [self loadMainListDataWithType:self.clickBtnString];
    }else {
        [self loadMainListDataWithType:@""];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavTitle:@"我的供求"];
    
    [self.view addSubview:self.topMenu];
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
        [self loadMainListDataWithType:@""];
        self.clickBtnString = @"";
        NSLog(@"点击了全部");
    }else if (btn.tag == KTag + 2)
    {
        [self loadMainListDataWithType:_categoryIDArray[0]];
        self.clickBtnString = _categoryIDArray[0];
        NSLog(@"点击了供应");
    }else if(btn.tag == KTag +3)
    {
        [self loadMainListDataWithType:_categoryIDArray[1]];
        self.clickBtnString = _categoryIDArray[1];
        NSLog(@"点击了求购");
    }
}

/**
 *  点击取消发布/重新发布
 *
 *  @param btn 取消发布/重新发布
 *  @param cell 每一个企业
 */
-(void)MySupplyAndDemandCellDidClick:(UIButton *)btn withCell:(UITableViewCell *)cell
{
    NSIndexPath* indexpath = [_mainTableView indexPathForCell:cell];
    GQSupplyAndBuyDetailModel* detailModel = _mainListArray[indexpath.row];
//    if ([self.clickBtnString isEqualToString:@"全部"]) {
////        NSLog(@"全部");
//    }else if ([self.clickBtnString isEqualToString:@"供应"]){
////        NSLog(@"供应");
//    }else if ([self.clickBtnString isEqualToString:@"求购"]){
////        NSLog(@"求购");
//    }
    
    if ([btn.titleLabel.text isEqualToString:@"重新发布"]) {
        NSLog(@"重新发布");
        
        RePublishSellAndBuyViewController* rvc = [[RePublishSellAndBuyViewController alloc]init];
        rvc.flagId = detailModel.supplyInfoId;
        rvc.formIndex = @"1";
        [self.navigationController pushViewController:rvc animated:YES];
        
//        AddNewSupplyAndDemandViewController* avc = [[AddNewSupplyAndDemandViewController alloc]init];
//        avc.flagId = detailModel.supplyInfoId;
//        avc.formIndex = @"1";
//        [self.navigationController pushViewController:avc animated:YES];

    }else if ([btn.titleLabel.text isEqualToString:@"取消发布"]){
        NSLog(@"取消发布");
        _supplyAndDemandId = detailModel.supplyInfoId;
        _publishCancleBtn = btn;
        [self showAlertView];
    }
}

/**
 *  提示框确定按钮点击事件
 */
-(void)alertViewConfirmBtnClick
{
    [self revocationOrPublishTheSupplyAndDemandWithFlagId:_supplyAndDemandId andWithBtn:_publishCancleBtn];
    [self hiddenAlertView];
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
    _alertView.contentlab.text = @"是否确定取消发布该供求";
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
 *  主列表
 *
 *  @return self
 */
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(91), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - getNumWithScanf(91))];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [_mainTableView registerClass:[MySupplyAndDemandTableViewCell class] forCellReuseIdentifier:@"MySupplyAndDemandId"];
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
    MySupplyAndDemandTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MySupplyAndDemandId"];
    cell.backgroundColor = getColor(@"f7f7f7");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.detailModel = _mainListArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(210);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GQSupplyAndBuyDetailModel* model = _mainListArray[indexPath.row];
    SupplyAndDemandDetailViewController* svc = [[SupplyAndDemandDetailViewController alloc]init];
    svc.flagId = model.supplyInfoId;
    svc.publishStatus = model.publishstatus;
    svc.supplyInfoId = model.supplyInfoId;
    [self.navigationController pushViewController:svc animated:YES];
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
