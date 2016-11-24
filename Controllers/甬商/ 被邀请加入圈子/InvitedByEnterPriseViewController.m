//
//  InvitedByEnterPriseViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "InvitedByEnterPriseViewController.h"
#import "NormalEnterPriseCricleDetailViewController.h"
#import "BeInvitedTheCricleModel.h"
#import "BeInvitedTheCricleTableViewCell.h"
#import "ReviceORRefuseTableViewCell.h"

@interface InvitedByEnterPriseViewController ()<UITableViewDataSource,UITableViewDelegate,ReviceORRefuseDelegate>
{
    NSString* _descriptionString;    //描述文字
    CGFloat _descriptionLabHeight;   //文字高度
    UILabel* _defaultLab;
    MyLabel* _enterPriseNameLab;     //企业名称
    UIButton* _reciveBtn;            //接受邀请
    UIButton* _refuseBtn;            //拒绝邀请
    CGFloat _companyNameHeight;
    NSMutableArray* _mainListArray;
}
@property(nonatomic,strong)UILabel* descriptionLab;   //描述圈子详情
@property(nonatomic,strong)UITableView * mainTableView;
@property(nonatomic,strong)UIView* bgview;


@end

@implementation InvitedByEnterPriseViewController

/*------------------------------网络------------------------------------*/

-(void)loadEnterPriseDetailWithNet
{
    [self showprogressHUD];
    [YSBLL enterPriseInvitedWithUnion:self.unionId andCompanyId:[UserModel shareInstanced].companyId andResultBlock:^(BeInvitedJoinTheCricleModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _mainListArray = [[NSMutableArray alloc]init];
            
            [model.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BeInvitedTheCricleModel* model = [BeInvitedTheCricleModel yy_modelWithJSON:obj];
                [_mainListArray addObject:model];
            }];
            BeInvitedTheCricleModel* model = _mainListArray[0];
            _descriptionString = model.memo;
            _descriptionLabHeight = MAX([self kdetailTextHeight:_descriptionString width:getNumWithScanf(450)], getNumWithScanf(30)) ;
            [self.view addSubview:self.mainTableView];
        }
        else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
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
            if([flagtype isEqualToString:@"2"]){
                
            }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:self.navTitile];
    [self loadEnterPriseDetailWithNet];
}

#pragma mark - function

/**
 *  接受邀请
 */
-(void)reviceBtnDidClick
{
    [self acceptTheInvitionWithFlagType:@"2"];
}

/**
 *  拒绝邀请
 */
-(void)refuseBtnDidClick
{
    [self acceptTheInvitionWithFlagType:@"0"];
}


#pragma mark - Init

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.bgview;
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        NSBundle* root_bundle = [NSBundle bundleWithPath:[UserModel shareInstanced].root_bundle];
        [_mainTableView registerNib:[UINib nibWithNibName:@"BeInvitedTheCricleTableViewCell" bundle:nil] forCellReuseIdentifier:@"BeInvitedTheCricleTableViewCell"];
        //[_mainTableView registerClass:[ReviceORRefuseTableViewCell class] forCellReuseIdentifier:@"ReviceORRefuseTableViewCell"];
    }
    return _mainTableView;
}

-(UIView *)bgview
{
    if (!_bgview) {
        _bgview  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _descriptionLabHeight+20)];
        _bgview.backgroundColor = getColor(@"f5f5f5");
        _descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - getNumWithScanf(450))/2, 10,getNumWithScanf(450), _descriptionLabHeight)];
        _descriptionLab.text = _descriptionString;
        _descriptionLab.textAlignment = NSTextAlignmentCenter;
        _descriptionLab.textColor = getColor(@"999999");
        _descriptionLab.font = DEF_FontSize_12;
        _descriptionLab.numberOfLines = 0;
        [_bgview addSubview:_descriptionLab];
    }
    return _bgview;
}

#pragma mark - TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mainListArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _mainListArray.count) {
        ReviceORRefuseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReviceORRefuseTableViewCell"];
        if (!cell) {
            cell = [[ReviceORRefuseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReviceORRefuseTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.backgroundColor = getColor(@"f7f7f7");
        return cell;
    }
    BeInvitedTheCricleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BeInvitedTheCricleTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = getColor(@"f7f7f7");
    cell.model = _mainListArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.normalLab.hidden = NO;
    }
    return cell;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == _mainListArray.count) {
       return getNumWithScanf(230);
    }
    BeInvitedTheCricleModel *model = _mainListArray[indexPath.section];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BeInvitedTheCricleTableViewCell class] contentViewWidth:SCREEN_WIDTH];
}


//#pragma mark - layout
//
//-(void)layout
//{
//    _descriptionLab.sd_layout
//    .topSpaceToView(self.view,getNumWithScanf(15))
//    .centerXEqualToView(self.view)
//    .widthIs(getNumWithScanf(450))
//    .heightIs(_descriptionLabHeight);
//}


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
