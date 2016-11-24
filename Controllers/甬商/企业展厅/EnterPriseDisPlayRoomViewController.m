//
//  EnterPriseDisPlayRoomViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseDisPlayRoomViewController.h"
#import "EnterPriseRoomTableViewCell.h"
#import "EnterPriseDisPlayRoomDetailViewController.h"
#import "YSIndustryTypeModel.h"
#import "YSEnterPriseRoomModel.h"
#import "SearchTheEnterpriseViewController.h"
#import "MyDisplayRoomFinishViewController.h"

@interface EnterPriseDisPlayRoomViewController ()<UITableViewDataSource,UITableViewDelegate,JYCDropDownMenuDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray* _industryNameArray;
    NSMutableArray* _industryIdArray;
    NSMutableArray* _mainListArray;
    NSInteger _page;
    NSInteger _pageSize;
}
@property(nonatomic,strong)JYCDropDownMenuView* downPushView;    //下拉列表
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)UITapGestureRecognizer* hideDownlistTap;

@end

@implementation EnterPriseDisPlayRoomViewController

/*------------------------------网络------------------------------------*/

/**
*  请求下拉列表数据
*/
-(void)loadDownListArray
{
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/typeDetails.do?lxtype=1&u_code=%@",[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _industryNameArray = [[NSMutableArray alloc]initWithObjects:@"全部", nil];
            _industryIdArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSIndustryTypeModel* industryModel = [YSIndustryTypeModel yy_modelWithJSON:obj];
                [_industryNameArray addObject:industryModel.name];
                [_industryIdArray addObject:industryModel];
            }];
            [self.view addSubview:self.mainTableView];
            [self.view addSubview:self.downPushView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  请求主列表的数据
 */
-(void)loadMainListData
{
    _page = 1;
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/businessShow.do?flagId=%@&createcompanyid=%@&pageSize=%td&currentPage=%ld&tradeId=%@&u_code=%@",[UserModel shareInstanced].tradeId,[UserModel shareInstanced].companyId,_pageSize,_page,[self getTradTD],[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _mainListArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseRoomModel* enterPriseRoomModel = [YSEnterPriseRoomModel yy_modelWithJSON:obj];
                [_mainListArray addObject:enterPriseRoomModel];
            }];
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            [_mainListArray removeAllObjects];
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self.mainTableView reloadData];
        [self hiddenProgressHUD];
    }];
}

-(void)loadMoreData
{
    _page++;
    _pageSize = 10;
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/businessShow.do?flagId=%@&createcompanyid=%@&pageSize=%td&currentPage=%ld&tradeId=%@&u_code=%@",[UserModel shareInstanced].tradeId,[UserModel shareInstanced].companyId,_pageSize,_page,[self getTradTD],[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSMutableArray* tempArr = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseRoomModel* enterPriseRoomModel = [YSEnterPriseRoomModel yy_modelWithJSON:obj];
                [tempArr addObject:enterPriseRoomModel];
            }];
            [_mainListArray addObjectsFromArray:tempArr];
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
    [self loadDownListArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"企业展厅"];

    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchEnterPriseUseName)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    _pageSize = 10;
    [self loadMainListData];
}

#pragma mark - function

/**
 *  获取行业分类唯一编号
 *
 *  @return 行业分类编号
 */
-(NSString*)getTradTD
{
    NSString* tradeId = [NSString string];
    for (int i = 0; i < _industryIdArray.count ; i++) {
        YSIndustryTypeModel* model = _industryIdArray[i];
        if ([model.name isEqualToString:_downPushView.titleLab.text]) {
            tradeId = model.industryId;
        }
    }
    if ([_downPushView.titleLab.text isEqualToString:@"全部"]) {
        tradeId = @"";
    }
    return tradeId;
}

/**
 *  搜索企业
 */
-(void)searchEnterPriseUseName
{
    SearchTheEnterpriseViewController* svc = [[SearchTheEnterpriseViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Init

-(UITapGestureRecognizer *)hideDownlistTap
{
    if (!_hideDownlistTap) {
        _hideDownlistTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDownPushList)];
        _hideDownlistTap.delegate = self;
    }
    return _hideDownlistTap;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}

/**
 *  下拉列表
 *
 *  @return self
 */
-(JYCDropDownMenuView *)downPushView
{
    if (!_downPushView) {
        _downPushView = [[JYCDropDownMenuView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(40), getNumWithScanf(70))];
        _downPushView.layer.masksToBounds = YES;
        _downPushView.layer.cornerRadius = 5;
        _downPushView.layer.borderWidth = 0.7;
        _downPushView.layer.borderColor = getColor(@"3fbefc").CGColor;
        _downPushView.NumOfRow = 4;
        _downPushView.delegate = self;
        [_downPushView createOneMenuTitleArray:_industryNameArray];
//        _downPushView.isOpened = YES;
    }
    return _downPushView;
}


/**
 *  主列表
 *
 *  @return self
 */
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(88), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - getNumWithScanf(88))];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //下拉刷新
        _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageSize = _mainListArray.count;
            [self loadMainListData];
            [self.mainTableView.header endRefreshing];
        }];
        
        //上啦加载
        _mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
            [self.mainTableView.footer endRefreshing];
        }];
        
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
    cell.model = _mainListArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(140);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSEnterPriseRoomModel* model = _mainListArray[indexPath.row];
//    if ([model.enterPriseId integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
//        MyDisplayRoomFinishViewController* mvc = [[MyDisplayRoomFinishViewController alloc]init];
//        [self.navigationController pushViewController:mvc animated:YES];
//    }else{
        EnterPriseDisPlayRoomDetailViewController* evc = [[EnterPriseDisPlayRoomDetailViewController alloc]init];
        evc.enterPriseId = model.enterPriseId;
        [self.navigationController pushViewController:evc animated:YES];
//    }
}

/**
 *  点击下拉列表代理
 *
 *  @param opened 是否打开
 */
-(void)dropDownMenuDidClick:(BOOL)opened andSelf:(UIView *)selfView
{
    if (opened) {
        [self.view addGestureRecognizer:self.hideDownlistTap];
    }else{
        [self.view removeGestureRecognizer:_hideDownlistTap];
    }
}

-(void)tableViewDidSelect
{
    [self.view removeGestureRecognizer:_hideDownlistTap];
    [self loadMainListData];
}

-(void)hideDownPushList
{
    NSLog(@"dian ji");
    [self.downPushView hideDropDownList];
    [self dropDownMenuDidClick:self.downPushView.isOpened andSelf:self.downPushView];
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
