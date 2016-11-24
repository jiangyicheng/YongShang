//
//  CreateNewCricleViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "CreateNewCricleViewController.h"
#import "EnterPriseListViewController.h"
#import "EnterPriseSelectedTableViewCell.h"
#import "YSEnterPriseRoomModel.h"
#define MAX_LIMIT_NUMS  1000     //来限制最大输入只能1000个字符

@interface CreateNewCricleViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITextField* _circleNameTextField;    //圈子名称
    PlaceHoderTextView* _remarkTextField;        //备注
    UIButton* _saveBtn;     //保存
    UIView* _bgView;
    NSMutableArray* _dataArr;
}

@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)UITableView* mainTableView;

@end

@implementation CreateNewCricleViewController

/*------------------------------网络------------------------------------*/

/**
*  保存接口
*
*  @param businessIds 企业编号数组
*/
-(void)saveTheEnterPriseCricleWithBusinessIds:(NSString*)businessIds
{
    [self showprogressHUD];
    [YSBLL CreatEnterPriseCricleWithUnionname:_circleNameTextField.text andMemo:_remarkTextField.text andBusinessIds:businessIds andUnioncreateuid:[UserModel shareInstanced].companyId andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"新建圈子失败"];
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"新建圈子失败"];
        }
        [self hiddenProgressHUD];
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    [self.view addSubview:self.mainScrollView];
    [self NavTitle:@"新建圈子"];
    [self scrollViewAddSubView];
    
    //接收通知（选择的企业）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedEnterPriseSEL:) name:@"DidSelectedEnterPrise" object:nil];
}

#pragma mark function

/**
 *  选择企业回调方法
 *
 *  @param noti noti
 */
-(void)selectedEnterPriseSEL:(NSNotification*)noti
{
    _dataArr = noti.userInfo[@"selectedEnterPrise"];
    _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(524)+_dataArr.count*getNumWithScanf(110));
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-getNumWithScanf(160) + _dataArr.count*getNumWithScanf(110));
    [_mainTableView reloadData];
}

/**
 *  选择企业
 */
-(void)selectEnterPriseClick
{
    EnterPriseListViewController* evc = [[EnterPriseListViewController alloc]init];
    evc.rightItemString = @"添加";
    evc.status = @"1";
    if (_dataArr) {
        evc.modelArray = _dataArr;
    }
    [self.navigationController pushViewController:evc animated:YES];
}

/**
 *  保存
 */
-(void)saveBtnClick
{
    if (_circleNameTextField.text.length == 0) {
        [self showMessage:@"请输入圈子名称"];
        return;
    }
    if (_remarkTextField.text.length == 0) {
        [self showMessage:@"请输入备注"];
        return;
    }
    
    
    if([[_circleNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 || [[_remarkTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
        [self showMessage:@"请输入正确的字符"];
        return;
    }
    if (!_dataArr.count) {
        [self showMessage:@"请选择企业"];
        return;
    }
    
    NSString* businessIds = [NSString string];
    
    for (int i = 0; i < _dataArr.count; i++) {
        YSEnterPriseRoomModel* model = _dataArr[i];
        
        if(i == 0){
            businessIds =[businessIds stringByAppendingString:[NSString stringWithFormat:@"%@",model.enterPriseId]];
        }else{
            businessIds =[businessIds stringByAppendingString:[NSString stringWithFormat:@",%@",model.enterPriseId]];
        }
    }
    [self saveTheEnterPriseCricleWithBusinessIds:businessIds];
}

#pragma mark - Init

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(10), SCREEN_WIDTH, SCREEN_HEIGHT - getNumWithScanf(10) - 64)];
        _mainScrollView.backgroundColor = getColor(@"f7f7f7");
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-getNumWithScanf(10));
        
    }
    return _mainScrollView;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.scrollEnabled = NO;
        [_mainTableView registerClass:[EnterPriseSelectedTableViewCell class] forCellReuseIdentifier:@"selectedEnterPrise"];
    }
    return _mainTableView;
}

/**
 *  添加子视图
 */
-(void)scrollViewAddSubView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(514))];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
    [_mainScrollView addSubview:_bgView];
    
    //圈子名称
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(40), getNumWithScanf(110), getNumWithScanf(64))];
    firstLab.text = @"圈子名称";
    firstLab.textColor = getColor(@"333333");
    firstLab.font = DEF_FontSize_12;
    [_bgView addSubview:firstLab];
    
    _circleNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(40), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _circleNameTextField.placeholder = @"输入圈子名称";
    [_circleNameTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_circleNameTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    _circleNameTextField.font = DEF_FontSize_12;
    _circleNameTextField.textColor = getColor(@"4d4d4d");
    _circleNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _circleNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_circleNameTextField];
    
    //备注
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(134), getNumWithScanf(110), getNumWithScanf(64))];
    secondLab.text = @"备         注";
    secondLab.textColor = getColor(@"333333");
    secondLab.font = DEF_FontSize_12;
    [_bgView addSubview:secondLab];
    
    _remarkTextField = [[PlaceHoderTextView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(140), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(248))];
    _remarkTextField.placeHoder = @"输入内容～";
    _remarkTextField.delegate = self;
    _remarkTextField.placeHoderColor = getColor(@"999999");
    _remarkTextField.layer.masksToBounds = YES;
    _remarkTextField.layer.cornerRadius = 5;
    _remarkTextField.layer.borderWidth = 0.5;
    _remarkTextField.layer.borderColor = getColor(@"e6e6e6").CGColor;
    [_bgView addSubview:_remarkTextField];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(428), SCREEN_WIDTH - getNumWithScanf(40), 0.5)];
    lineView.backgroundColor = getColor(@"dddddd");
    [_mainScrollView addSubview:lineView];
    
    //选择企业
    [_bgView addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .topSpaceToView(lineView,0)
    .leftEqualToView(_bgView)
    .rightEqualToView(_bgView)
    .bottomEqualToView(_bgView);
    
    //保存
    _saveBtn = [[UIButton alloc]init];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _saveBtn.backgroundColor = getColor(@"3fbefc");
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.cornerRadius = 8;
    _saveBtn.titleLabel.font = DEF_FontSize_13;
    [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_saveBtn];
    
    _saveBtn.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(94))
    .leftSpaceToView(_mainScrollView,getNumWithScanf(30))
    .rightSpaceToView(_mainScrollView,getNumWithScanf(30))
    .heightIs(getNumWithScanf(80));
    
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterPriseSelectedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"selectedEnterPrise"];
    YSEnterPriseRoomModel* model = _dataArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//headview in section
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(85))];
    UILabel* thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), 0, getNumWithScanf(110), getNumWithScanf(85))];
    thirdLab.text = @"选择企业";
    thirdLab.textColor = getColor(@"333333");
    thirdLab.font = DEF_FontSize_12;
    [bgview addSubview:thirdLab];
    
    UIImageView* nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-getNumWithScanf(35   ), getNumWithScanf(27.5), getNumWithScanf(15), getNumWithScanf(30))];
    nextImageView.image = [UIImage imageNamed:@"next"];
    [bgview addSubview:nextImageView];
    
    UIButton* selectEnterPriseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(85))];
    selectEnterPriseBtn.backgroundColor = [UIColor clearColor];
    [selectEnterPriseBtn addTarget:self action:@selector(selectEnterPriseClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:selectEnterPriseBtn];
    return bgview;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return getNumWithScanf(85);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(115);
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
