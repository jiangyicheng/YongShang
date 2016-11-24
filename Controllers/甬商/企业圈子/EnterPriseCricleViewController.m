//
//  EnterPriseCricleViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseCricleViewController.h"
#import "EnterPriseCricleTableViewCell.h"
#import "CreateNewCricleViewController.h"
#import "EnterPriseCricleDetailViewController.h"
#import "InvitedByEnterPriseViewController.h"
#import "NormalEnterPriseCricleDetailViewController.h"
#import "YSEnterPriseCricleModel.h"

@interface EnterPriseCricleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _enterPriseCricleArray;
}
@property(nonatomic,strong)UITableView* mainTableView;

@end

@implementation EnterPriseCricleViewController

/*------------------------------网络------------------------------------*/

-(void)loadEnterPriseCricleList
{
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/businessUnion.do?companyid=%@&u_code=%@",[UserModel shareInstanced].companyId,[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _enterPriseCricleArray = [[NSMutableArray alloc]init];
            NSMutableArray* tempArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseCricleModel* enterPriseCricleModel = [YSEnterPriseCricleModel yy_modelWithJSON:obj];
                NSLog(@"type == %@ uinionId == %@",enterPriseCricleModel.type,enterPriseCricleModel.unionId);
                if ([enterPriseCricleModel.type isEqualToString:@"1"]) {
                    [_enterPriseCricleArray addObject:enterPriseCricleModel];
                }else{
                    [tempArray addObject:enterPriseCricleModel];
                }
            }];
            [_enterPriseCricleArray addObjectsFromArray:tempArray];
            [self.view addSubview:self.mainTableView];
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
    [self loadEnterPriseCricleList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"企业圈子"];
    [self createNavTitle];
}

-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    editBtn.titleLabel.font = DEF_FontSize_13;
    [editBtn setTitle:@"新建" forState:UIControlStateNormal];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(creatCricleClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
}

/**
 *  新建圈子
 */
-(void)creatCricleClick
{
    CreateNewCricleViewController* cvc = [[CreateNewCricleViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - 加载tableView

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(40), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - getNumWithScanf(40))];
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.delegate = self;
//        _mainTableView.bounces = NO;
        _mainTableView.layer.borderColor = getColor(@"dddddd").CGColor;
        _mainTableView.layer.borderWidth = 0.5;
        
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[EnterPriseCricleTableViewCell class] forCellReuseIdentifier:@"EnterPriseCricleTableViewCell"];
    }
    return _mainTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _enterPriseCricleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterPriseCricleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EnterPriseCricleTableViewCell"];
    YSEnterPriseCricleModel* model = _enterPriseCricleArray[indexPath.row];
    if (model.unionName) {
        cell.nameLab.text = model.unionName;
    }
    if ([model.type isEqualToString:@"1"]) {
        cell.nameLab.textColor = getColor(@"fe9493");
    }else
    {
        cell.nameLab.textColor = getColor(@"333333");
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSEnterPriseCricleModel* model = _enterPriseCricleArray[indexPath.row];
    if ([model.type isEqualToString:@"11"]) {
        EnterPriseCricleDetailViewController* evc = [[EnterPriseCricleDetailViewController alloc]init];
        evc.navTitle = model.unionName;
        evc.unionId = model.unionId;
        [self.navigationController pushViewController:evc animated:YES];
    }else if ([model.type isEqualToString:@"1"])
    {
        InvitedByEnterPriseViewController* ivc = [[InvitedByEnterPriseViewController alloc]init];
        ivc.navTitile = model.unionName;
        ivc.unionId = model.unionId;
        NSLog(@"invite unionId==%@",model.unionId);
        [self.navigationController pushViewController:ivc animated:YES];
    }else if ([model.type isEqualToString:@"2"])
    {
        NormalEnterPriseCricleDetailViewController* nvc = [[NormalEnterPriseCricleDetailViewController alloc]init];
        nvc.navTitle = model.unionName;
        nvc.unionId = model.unionId;
        [self.navigationController pushViewController:nvc animated:YES];
    }
    
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
