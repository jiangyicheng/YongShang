//
//  FriendEnterPriseViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "FriendEnterPriseViewController.h"
#import "EnterPriseRoomTableViewCell.h"
#import "FriendEnterPriseDetailViewController.h"

@interface FriendEnterPriseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _mainListArray;
}
@property(nonatomic,strong)UITableView* mainTableView;

@end

@implementation FriendEnterPriseViewController

/*------------------------------网络------------------------------------*/

/**
 *  请求主列表的数据
 */
-(void)loadMainListData
{
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/friendsBusiness.do?createcompanyid=%@&u_code=%@",[UserModel shareInstanced].companyId,[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _mainListArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseRoomModel* enterPriseRoomModel = [YSEnterPriseRoomModel yy_modelWithJSON:obj];
                [_mainListArray addObject:enterPriseRoomModel];
            }];
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
    [self loadMainListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"好友企业"];
}

#pragma mark - Init

/**
 *  主列表
 *
 *  @return self
 */
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(6), SCREEN_WIDTH, SCREEN_HEIGHT - 64 )];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.friendModel = _mainListArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(140);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendEnterPriseDetailViewController* fvc = [[FriendEnterPriseDetailViewController alloc]init];
    fvc.model = _mainListArray[indexPath.row];
    [self.navigationController pushViewController:fvc animated:YES];
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
