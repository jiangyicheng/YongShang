//
//  ReportViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ReportViewController.h"
#import "ReprotTableViewCell.h"
#import "YSIndustryTypeModel.h"
#define MaxRow 5

@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate,AlertViewDelegate>
{
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
    NSMutableArray* _reportContentArray;
}
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)NSIndexPath* lastSelectPath;
@property(nonatomic,strong)UIButton* reportbtn;     //举报

@end

@implementation ReportViewController

/*------------------------------网络------------------------------------*/

/**
*  举报类型接口
*/
-(void)loadDownListArray
{
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/typeDetails.do?lxtype=2&u_code=%@",[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _reportContentArray = [[NSMutableArray alloc]init];
            __block NSString* isSelected = [[NSString alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSIndustryTypeModel* industryModel = [YSIndustryTypeModel yy_modelWithJSON:obj];
//                NSString* isSelected = [[NSString alloc]init];
                if (idx == 0) {
                    isSelected = @"yes";
                }else{
                    isSelected = @"no";
                }
                NSDictionary* dict = @{@"title":industryModel.name,@"selected":isSelected,@"id":industryModel.industryId}.mutableCopy;
                
                [_reportContentArray addObject:dict];
            }];
            [self.view addSubview:self.mainTableView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  举报企业接口
 *
 *  @param complaintId 举报类型
 */
-(void)reportTheEnterPriseWithComplainttype:(NSString*)complaintId
{
    [YSBLL getResultWithComplaintuid:self.complaintedUId andComplaintcid:self.complaintedCId andBecomplainuid:self.BecomplaintedUId andBecomplaincid:self.beComplaintedCId andComplainttype:complaintId andNewsdetails:self.infomationSource andFlagId:self.flagId andContext:self.context andContextimage:self.contextimage andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
//            [self showTemplantMessage:@"举报成功"];
            [MBProgressHUD showSuccess:@"举报成功"];
            [UIView animateWithDuration:1.2 animations:^{
               [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"举报"];
    
    [self loadDownListArray];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.lastSelectPath = indexPath;
    
    [self.view addSubview:self.reportbtn];
}

#pragma mark - function

/**
 *  举报
 */
-(void)reportbtnDidClick
{
    [self showAlertView];
}

/**
 *  提示框确定按钮点击事件
 */
-(void)alertViewConfirmBtnClick
{
    NSString* complaintType = [NSString string];
    for (int i = 0; i < _reportContentArray.count; i++) {
        if ([_reportContentArray[i][@"selected"] isEqualToString:@"yes"]){
            complaintType = _reportContentArray[i][@"id"];
            NSLog(@"complaintType==%@",complaintType);
        }
    }
    [self hiddenAlertView];
    [self reportTheEnterPriseWithComplainttype:complaintType];
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
    _alertView.contentlab.text = @"是否确定举报该企业";
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

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(40), SCREEN_WIDTH, getNumWithScanf(400))];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.layer.borderColor = getColor(@"dddddd").CGColor;
        _mainTableView.layer.borderWidth = 0.5;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.scrollEnabled = NO;
        
        //注册cell
        [_mainTableView registerClass:[ReprotTableViewCell class] forCellReuseIdentifier:@"reportCell"];
    }
    return _mainTableView;
}

-(UIButton *)reportbtn
{
    if (!_reportbtn) {
        _reportbtn = [[UIButton alloc]initWithFrame:CGRectMake(getNumWithScanf(30), getNumWithScanf(480), SCREEN_WIDTH - getNumWithScanf(60), getNumWithScanf(80))];
        [_reportbtn setTitle:@"举报" forState:UIControlStateNormal];
        [_reportbtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        _reportbtn.backgroundColor = getColor(@"3fbefc");
        _reportbtn.layer.masksToBounds = YES;
        _reportbtn.titleLabel.font = DEF_FontSize_13;
        _reportbtn.layer.cornerRadius = 5;
        [_reportbtn addTarget:self action:@selector(reportbtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportbtn;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reportContentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReprotTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.companyName.text = _reportContentArray[indexPath.row][@"title"];
    if ([_reportContentArray[indexPath.row][@"selected"] isEqualToString:@"yes"]) {
        cell.selectBtn.selected = YES;
    }else if ([_reportContentArray[indexPath.row][@"selected"] isEqualToString:@"no"]){
        cell.selectBtn.selected = NO;
        NSLog(@"---%@",_reportContentArray[indexPath.row][@"selected"]);
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(80);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* temp = self.lastSelectPath;
    if (temp && temp!= indexPath) {
        _reportContentArray[temp.row][@"selected"] = @"no";
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    self.lastSelectPath = indexPath;
    _reportContentArray[indexPath.row][@"selected"] = @"yes";
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - data

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@{@"title":@"色情信息",@"selected":@"no"}.mutableCopy,
                       @{@"title":@"欺诈骗钱",@"selected":@"no"}.mutableCopy,
                       @{@"title":@"诅咒谩骂",@"selected":@"no"}.mutableCopy,
                       @{@"title":@"广告骚扰",@"selected":@"no"}.mutableCopy,
                       @{@"title":@"传播谣言",@"selected":@"no"}.mutableCopy].mutableCopy;
    }
    return _dataArray;
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
