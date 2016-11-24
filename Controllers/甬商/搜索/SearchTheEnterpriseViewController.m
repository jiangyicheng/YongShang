//
//  SearchTheEnterpriseViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "SearchTheEnterpriseViewController.h"
#import "EnterPriseDisPlayRoomDetailViewController.h"
#import "MyDisplayRoomFinishViewController.h"

@interface SearchTheEnterpriseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    UISearchBar* searchCompanyBar;
    NSMutableArray* _mainListArray;
    NSInteger _page;
    NSInteger _pageSize;
}
@property(nonatomic,strong)UIView* topView;
@property(nonatomic,strong)UITableView* mainTableView;

@end

@implementation SearchTheEnterpriseViewController

/**
 *  请求主列表的数据
 */
-(void)loadMainListDataWithName:(NSString*)name
{
    [self showprogressHUD];
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":[UserModel shareInstanced].tradeId,
                           @"createcompanyid":[UserModel shareInstanced].companyId,
                           @"flagName":name,
                           @"currentPage":@(_page),
                           @"pageSize":@(_pageSize)
                           };
    [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessShow.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CommonModel* model = [CommonModel yy_modelWithJSON:responseObject];
        if ([model.ecode isEqualToString:@"0"]) {
            _mainListArray = [[NSMutableArray alloc]init];
//            NSLog(@"model--%@",model.data);
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseRoomModel* enterPriseRoomModel = [YSEnterPriseRoomModel yy_modelWithJSON:obj];
                [_mainListArray addObject:enterPriseRoomModel];
            }];
            [self.mainTableView reloadData];
        }else if ([model.ecode isEqualToString:@"-2"]){
            _mainListArray = [[NSMutableArray alloc]init];
            [self.mainTableView reloadData];
            [self showTemplantMessage:@"未查询到相关数据"];
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hiddenProgressHUD];
    }];
}

/**
 *  请求主列表的数据
 */
-(void)loadMoreMainListDataWithName:(NSString*)name
{
    [self showprogressHUD];
    _page++;
    NSDictionary* dict = @{@"u_code":[UserModel shareInstanced].postName,
                           @"flagId":[UserModel shareInstanced].tradeId,
                           @"createcompanyid":[UserModel shareInstanced].companyId,
                           @"flagName":name,
                           @"currentPage":@(_page),
                           @"pageSize":@(10)
                           };
    [[AFAppDotNetAPIClient sharedClient]POST:@"appservice/businessShow.do" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CommonModel* model = [CommonModel yy_modelWithJSON:responseObject];
        if ([model.ecode isEqualToString:@"0"]) {
            NSMutableArray* tempArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSEnterPriseRoomModel* enterPriseRoomModel = [YSEnterPriseRoomModel yy_modelWithJSON:obj];
                [tempArray addObject:enterPriseRoomModel];
            }];
            [_mainListArray addObjectsFromArray:tempArray];
            [self.mainTableView reloadData];
        }else if ([model.ecode isEqualToString:@"-2"]){
//            _mainListArray = [[NSMutableArray alloc]init];
//            [self.mainTableView reloadData];
//            [self showTemplantMessage:@"未查询到相关数据"];
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hiddenProgressHUD];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self NavTitle:@"搜索"];
    _page = 1;
    _pageSize = 10;
    [self loadMainListDataWithName:@""];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainTableView];
}

#pragma mark - function

/**
 *  搜索
 */
-(void)searchBtnDidClick
{
    _page = 1;
    _pageSize = 10;
    [self loadMainListDataWithName:searchCompanyBar.text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _page = 1;
    _pageSize = 10;
    [self loadMainListDataWithName:searchBar.text];
}

#pragma mark - Init

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(88))];
        _topView.backgroundColor = getColor(@"f5f5f5");
        searchCompanyBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - getNumWithScanf(120), getNumWithScanf(88))];
        searchCompanyBar.placeholder = @"搜索";
//        searchCompanyBar.layer.borderColor = getColor(@"dddddd").CGColor;
//        searchCompanyBar.layer.borderWidth = 0.5;
        searchCompanyBar.layer.masksToBounds = YES;
        searchCompanyBar.layer.cornerRadius = 5;
        searchCompanyBar.delegate = self;
        searchCompanyBar.backgroundColor = getColor(@"f5f5f5");
        
        searchCompanyBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:searchCompanyBar.bounds.size];
        [_topView addSubview:searchCompanyBar];
        
        UIButton* searchbtn = [[UIButton alloc]init];
        [searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchbtn setBackgroundColor:getColor(@"3fbefc")];
        searchbtn.titleLabel.font = DEF_FontSize_13;
        searchbtn.layer.cornerRadius = 5;
        searchbtn.layer.masksToBounds = YES;
        [searchbtn addTarget:self action:@selector(searchBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:searchbtn];
        
        searchbtn.sd_layout
        .leftSpaceToView(searchCompanyBar,5)
        .rightSpaceToView(_topView,5)
        .centerYEqualToView(searchCompanyBar)
        .heightIs(getNumWithScanf(44));
        
        
    }
    return _topView;
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
        
//        //下拉刷新
        _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageSize = _mainListArray.count;
            _page = 1;
            [self loadMainListDataWithName:@""];
            [self.mainTableView.header endRefreshing];
        }];
        
        //上啦加载
        _mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreMainListDataWithName:searchCompanyBar.text];
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

#pragma mark - UITScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchCompanyBar resignFirstResponder];
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
