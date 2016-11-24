//
//  EnterPriseListViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/1.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseListViewController.h"
#import "EnterPriseListTableViewCell.h"
#import "YSEnterPriseDetailModel.h"

@interface EnterPriseListViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray* _mainListArray;
    NSMutableArray* _selectArr;
}

@property(nonatomic,strong)UITableView* mainTableView;

@end

@implementation EnterPriseListViewController

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
            
            for (int i = 0; i < model.data.count; i++) {
                YSEnterPriseRoomModel* enterPriseRoomModel = [YSEnterPriseRoomModel yy_modelWithJSON:model.data[i]];
                
                //新建圈子选择企业  status = 1
                if ([self.status isEqualToString:@"1"]) {
                    //判断公司是否之前选中
                    if (self.modelArray) {
                        for (int j = 0 ; j < self.modelArray.count; j++) {
                            YSEnterPriseRoomModel* tempModel = self.modelArray[j];
                            if ([enterPriseRoomModel.enterPriseId isEqualToString:tempModel.enterPriseId]) {
                                enterPriseRoomModel.selected = !enterPriseRoomModel.isSelected;
                            }
                        }
                    }
                    [_mainListArray addObject:enterPriseRoomModel];
                }
                //自己创建的圈子添加企业  status = 2
                else if ([self.status isEqualToString:@"2"]){
                    [_mainListArray addObject:enterPriseRoomModel];
                    if (self.alreadyPresentModelArray) {
                        for (int j = 0 ; j < self.alreadyPresentModelArray.count; j++) {
                            YSEnterPriseDetailModel* model = self.alreadyPresentModelArray[j];
                            if ([enterPriseRoomModel.enterPriseId isEqualToString:model.enterPriseId]) {
                                [_mainListArray removeObject:enterPriseRoomModel];
                            }
                        }
                    }
                }
                //别人创建的圈子邀请企业  status = 4
                else if ([self.status isEqualToString:@"4"]){
                    [_mainListArray addObject:enterPriseRoomModel];
                    if (self.inviteModelArray) {
                        for (int j = 0 ; j < self.inviteModelArray.count; j++) {
                            YSEnterPriseDetailModel* model = self.inviteModelArray[j];
                            if ([enterPriseRoomModel.enterPriseId isEqualToString:model.enterPriseId]) {
                                [_mainListArray removeObject:enterPriseRoomModel];
                            }
                        }
                    }
                }
            }
            //自己创建的圈子删除企业  status = 3
            if ([self.status isEqualToString:@"3"])
            {
                _mainListArray = [NSMutableArray arrayWithArray:self.deleteModelArray];
                if (self.deleteModelArray) {
                    for (int j = 0 ; j < self.deleteModelArray.count; j++) {
                        YSEnterPriseDetailModel* model = self.deleteModelArray[j];
                        NSLog(@"---%@",model.qzstatus);
                        //|| [model.qzstatus isEqualToString:@"1"]
                        if ([[UserModel shareInstanced].companyId integerValue] == [model.enterPriseId integerValue]) {
                            [_mainListArray removeObject:model];
                        }
                    }
                }
            }
        
            [self.view addSubview:self.mainTableView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  管理企业圈子添加、删除
 *
 *  @param type 添加或删除（1:添加 2:删除）
 */
-(void)addOrDeleteEnterPriseWithType:(NSString*)type
{
    NSString* businessIds = [NSString string];
    for (int i = 0; i < _selectArr.count; i++) {
        YSEnterPriseRoomModel* model = _selectArr[i];
        if(i == 0){
            businessIds =[businessIds stringByAppendingString:[NSString stringWithFormat:@"%@",model.enterPriseId]];
        }else{
            businessIds =[businessIds stringByAppendingString:[NSString stringWithFormat:@",%@",model.enterPriseId]];
        }
    }
    NSLog(@"-----unionid====%@",self.unionId);
    NSLog(@"-----businessId====%@",businessIds);
    NSLog(@"-----type====%@",type);
    
    [self showprogressHUD];
    [YSBLL DeleteAndAddEnterPriseWithUnionid:self.unionId andBusinessIds:businessIds andFlagType:type andUnioncreateid:[UserModel shareInstanced].companyId andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSLog(@"添加成功");
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
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
    
    _selectArr = [[NSMutableArray alloc]init];
    
    [self NavTitle:@"企业列表"];
    [self createNavTitle];
    [self loadMainListData];
}

-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    editBtn.titleLabel.font = DEF_FontSize_13;
    [editBtn setTitle:self.rightItemString forState:UIControlStateNormal];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(addEnterPriseClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
}

#pragma mark - function

/**
 *  添加企业或删除
 */
-(void)addEnterPriseClick
{
    _selectArr = [[NSMutableArray alloc]init];
    if ([self.status isEqualToString:@"1"]) {
        for (YSEnterPriseRoomModel* model in _mainListArray) {
            if (model.isSelected) {
                [_selectArr addObject:model];
                NSLog(@"选中companyid=====%@",model.enterPriseId);
            }
        }
        if (_selectArr.count < 1) {
            [self showMessage:@"请选择企业"];
            return;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DidSelectedEnterPrise" object:nil userInfo:@{@"selectedEnterPrise":_selectArr,@"type":self.rightItemString}];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.status isEqualToString:@"2"] || [self.status isEqualToString:@"4"]){
        for (YSEnterPriseDetailModel* model in _mainListArray) {
            if (model.isSelected) {
                [_selectArr addObject:model];
                NSLog(@"选中companyid=====%@",model.enterPriseId);
            }
        }
        if (_selectArr.count < 1) {
            [self showMessage:@"请选择企业"];
            return;
        }
        [self addOrDeleteEnterPriseWithType:@"1"];
    }else if ([self.status isEqualToString:@"3"])
    {
        for (YSEnterPriseDetailModel* model in _mainListArray) {
            if (model.isSelected) {
                [_selectArr addObject:model];
                NSLog(@"选中companyid=====%@",model.enterPriseId);
            }
        }
        if (_selectArr.count < 1) {
            [self showMessage:@"请选择企业"];
            return;
        }
        [self addOrDeleteEnterPriseWithType:@"2"];
    }
    
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
        [_mainTableView registerClass:[EnterPriseListTableViewCell class] forCellReuseIdentifier:@"EnterPriseList"];
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
    EnterPriseListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EnterPriseList"];
    cell.backgroundColor = getColor(@"f7f7f7");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.status isEqualToString:@"1"]) {
        YSEnterPriseRoomModel* model = _mainListArray[indexPath.row];
        cell.model = model;
        cell.isSelected = model.isSelected;
    }else if ([self.status isEqualToString:@"2"] || [self.status isEqualToString:@"3"] || [self.status isEqualToString:@"4"]){
        YSEnterPriseDetailModel* model = _mainListArray[indexPath.row];
        cell.detailModel = model;
        cell.isSelected = model.isSelected;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(140);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.status isEqualToString:@"1"]) {
        YSEnterPriseRoomModel* model = _mainListArray[indexPath.row];
        model.selected = !model.isSelected;
        EnterPriseListTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = model.isSelected;
    }else if ([self.status isEqualToString:@"2"] || [self.status isEqualToString:@"3"] || [self.status isEqualToString:@"4"]){
        YSEnterPriseDetailModel* model = _mainListArray[indexPath.row];
        model.selected = !model.isSelected;
        EnterPriseListTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = model.isSelected;
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
