//
//  YongShangMainViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YongShangMainViewController.h"
#import <SDCycleScrollView.h>
#import "YongShangMainCollectionViewCell.h"
#import "EnterPriseDisPlayRoomViewController.h"
#import "MyDisplayRoomViewController.h"
#import "FriendEnterPriseViewController.h"
#import "EnterPriseCricleViewController.h"
#import "EnterPriseCertificationViewController.h"
#import "YSTopInfoModel.h"
#import "YongShangNotificationViewController.h"
#import "EnterPriseDetailModel.h"
#import "MyDisplayRoomFinishViewController.h"
#import "CertificationFailedViewController.h"
#import "CertificationINGViewController.h"
#import "CertificationSuccessViewController.h"
#import "MyDisplayRoomFirstViewController.h"
#import "ZLCGuidePageView.h"

typedef NS_ENUM(NSInteger,KPlayType) {
    KPlayTypeEnterPriseDisPlayRoom,     //企业展厅
    KPlayTypeMyDisPlayRoom,             //我的展厅
    KPlayTypeFriendEnterPrise,          //好友企业
    KPlayTypeEnterPriseCircle,          //企业圈子
    KPlayTypeEnterPriseCertification,   //企业认证
};

@interface YongShangMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    EnterPriseDetailModel* _detailModel;                   //我的展厅详情model
    YSEnterPriseCertificationModel* _certificationModel;   //企业认证model
    NSMutableArray* _topInfoArray;
    NSMutableArray* _imageIdArray;
}

// 用于网络请求的Session对象
@property(nonatomic,strong)SDCycleScrollView* headScrollView;
@property(nonatomic,strong)UICollectionView* mainCollectionView;
@property(nonatomic,strong)NSArray* imageArr;
@property(nonatomic,strong)NSArray* titleArr;
@property(nonatomic)KPlayType type;

@end

@implementation YongShangMainViewController

/*------------------------------网络------------------------------------*/
/**
*  登录接口
*/
//-(void)loadData
//{
//    [YSBLL getLoginResultBlock:^(loginModel *model, NSError *error) {
//        if ([model.ecode isEqualToString:@"0"]) {
//            [UserModel shareInstanced].companyId = model.createcompanyid;
//            [UserModel shareInstanced].tradeId = model.tradeId;
//            [UserModel shareInstanced].userID = model.userId;
//            [UserModel shareInstanced].name = model.userName;
//            [UserModel shareInstanced].postName = @"cjtc0000001651@trial0197";
//            [UserModel shareInstanced].userType = model.talkAndSellbuyStatus;
//            NSLog(@"companyId==%@tradeId==%@userId==%@userName==%@",model.createcompanyid,model.tradeId,model.userId,model.userName);
//            
//            [self loadEnterPriseDetailData];
//            [self EnterPriseCertificationInterface];
//            [self loadTopInfoData];
//        }else if ([model.ecode isEqualToString:@"-2"]){
//            NSLog(@"请求数据失败");
//        }else if ([model.ecode isEqualToString:@"-1"]){
//            NSLog(@"异常错误");
//        }
//    }];
//}

/**
 *  顶部滑动视图接口
 */
-(void)loadTopInfoData
{
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/topmenu.do?flagId=%@&u_code=%@",[UserModel shareInstanced].tradeId,[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _topInfoArray = [[NSMutableArray alloc]init];
            _imageIdArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSTopInfoModel* infoModel = [YSTopInfoModel yy_modelWithJSON:obj];
                [_topInfoArray addObject:infoModel.imageurl];
                [_imageIdArray addObject:infoModel.imageId];
            }];
           [self.view addSubview:self.headScrollView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  企业详情接口
 */
-(void)loadEnterPriseDetailData
{
    [YSBLL getEnterPriseResultWithFlagId:[UserModel shareInstanced].companyId andCompanyid:@"" Block:^(EnterPriseDetailModel *model, NSError *error) {
        
//        if ([model.ecode isEqualToString:@"0"]) {
            _detailModel = model;
//        }else if ([model.ecode isEqualToString:@"-2"]){
//            NSLog(@"请求数据失败");
//        }else if ([model.ecode isEqualToString:@"-1"]){
//            NSLog(@"异常错误");
//        }
    }];
}

/**
 *  企业认证接口
 */
-(void)EnterPriseCertificationInterface
{
    [YSBLL enterPriseCertificationWithCreatecid:[UserModel shareInstanced].companyId andResultBlock:^(YSEnterPriseCertificationModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _certificationModel = model;
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败---认证");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误---认证");
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)viewWillAppear:(BOOL)animated
{
//    [self loadData];
    [self loadEnterPriseDetailData];
    [self EnterPriseCertificationInterface];
    [self loadTopInfoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"甬商通"];
    self.view.backgroundColor = getColor(@"f7f7f7");
    [self createNavTitle];
    
    //判断是否为第一次启动，若为第一次启动这执行引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSArray *images =  @[[UIImage imageNamed:@"引导01"],[UIImage imageNamed:@"引导02"],[UIImage imageNamed:@"引导03"],[UIImage imageNamed:@"引导04"]];
        //创建引导页视图
        ZLCGuidePageView *pageView = [[ZLCGuidePageView alloc]initWithFrame:self.view.frame WithImages:images];
        [self.tabBarController.view addSubview:pageView];
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstStart"];
    
    [self.view addSubview:self.mainCollectionView];
}

/**
 *  创建顶部
 */
-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(190), getNumWithScanf(50))];
    editBtn.titleLabel.font = DEF_FontSize_12;
    [editBtn setTitle:@"返回门户" forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [editBtn addTarget:self action:@selector(backToRootView) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.leftBarButtonItems = @[spaceItem,editItem];
}

//返回门户
-(void)backToRootView
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.AppViewController) {
//            [self.AppViewController dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"返回门户");
        }
        
    }];
}

/**
 *  创建头部滚动视图
 */
-(SDCycleScrollView *)headScrollView
{
    if (!_headScrollView) {
        
    [self.view addSubview:[[UIView alloc] init]];
        
    //滚动视图
    self.headScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(400)) imageURLStringsGroup:_topInfoArray];
    self.headScrollView.placeholderImage = [UIImage imageNamed:@"loadFailed"];
    self.headScrollView.showPageControl = YES;
    self.headScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.headScrollView.currentPageDotColor = getColor(@"3fbefc");
    self.headScrollView.pageDotColor = getColor(@"ffffff");
    self.headScrollView.autoScrollTimeInterval = 5;
    self.headScrollView.delegate = self;
    }
    return _headScrollView;
}

#pragma mark - SDCycleScrollView代理

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    YongShangNotificationViewController* yvc = [[YongShangNotificationViewController alloc]init];
    yvc.imageId = _imageIdArray[index];
    [self.navigationController pushViewController:yvc animated:YES];
}

/**
 *  创建中部mainCollectionView
 */
-(UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat insert = (SCREEN_WIDTH - getNumWithScanf(120) - getNumWithScanf(106)*3)/2;
        layout.itemSize = CGSizeMake(getNumWithScanf(106), getNumWithScanf(155));
        layout.minimumInteritemSpacing = insert;
        layout.minimumLineSpacing = insert/2;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(getNumWithScanf(60), getNumWithScanf(485), SCREEN_WIDTH - getNumWithScanf(120) , SCREEN_HEIGHT - 113 - getNumWithScanf(485)) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = getColor(@"f7f7f7");
        
        //注册collectionViewCell
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"YongShangMainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myMainCell"];
        
    }
    return _mainCollectionView;
}

#pragma mark - collectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.titleArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YongShangMainCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myMainCell" forIndexPath:indexPath];
    cell.cellImageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.cellNameLab.text = self.titleArr[indexPath.row];
    return cell;
}

#pragma mark - collectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _type = indexPath.item;
    switch (_type) {
        case KPlayTypeEnterPriseDisPlayRoom:
        {
            EnterPriseDisPlayRoomViewController* evc = [[EnterPriseDisPlayRoomViewController alloc]init];
            [self.navigationController pushViewController:evc animated:YES];
        }
            break;
        case KPlayTypeMyDisPlayRoom:
        {
            if ([_detailModel.ecode isEqualToString:@"0"])
            {
                MyDisplayRoomFinishViewController* fvc = [[MyDisplayRoomFinishViewController alloc]init];
                [self.navigationController pushViewController:fvc animated:YES];
            }else if ([_detailModel.ecode isEqualToString:@"-2"])
            {
                MyDisplayRoomFirstViewController* mec = [[MyDisplayRoomFirstViewController alloc]init];
                [self.navigationController pushViewController:mec animated:YES];
            }
            
        }
            break;
        case KPlayTypeFriendEnterPrise:
        {
            FriendEnterPriseViewController* fvc = [[FriendEnterPriseViewController alloc]init];
            [self.navigationController pushViewController:fvc animated:YES];
        }
            break;
        case KPlayTypeEnterPriseCircle:
        {
            EnterPriseCricleViewController* evc = [[EnterPriseCricleViewController alloc]init];
            [self.navigationController pushViewController:evc animated:YES];
        }
            break;
        case KPlayTypeEnterPriseCertification:
        {
            //（1.待审核 2.审核通过 0.审核不通过）
            if ([_certificationModel.ecode isEqualToString:@"－1"]) {
                [self dismissViewControllerAnimated:NO completion:^{
                    if (self.AppViewController) {
                        [self.AppViewController dismissViewControllerAnimated:YES completion:nil];
                        NSLog(@"返回门户");
                    }
                    
                }];
            }else if ([_certificationModel.status isEqualToString:@"1"]){
                CertificationINGViewController* cvc = [[CertificationINGViewController alloc]init];
                cvc.enterPriseName = _certificationModel.name;
                NSLog(@"sss--%@",_certificationModel.businesscards);
                //                NSLog(@"bbb--%@",_certificationModel.businesscard);
                cvc.licenseImages = _certificationModel.businesscards;
                cvc.licenseImage = _certificationModel.businesscard;
                cvc.vaild = _certificationModel.termtime;
                [self.navigationController pushViewController:cvc animated:YES];
            }else if ([_certificationModel.status isEqualToString:@"2"]){
                CertificationSuccessViewController* cvc = [[CertificationSuccessViewController alloc]init];
                cvc.enterPriseName = _certificationModel.name;
                cvc.licenseImages = _certificationModel.businesscards;
                cvc.licenseImage = _certificationModel.businesscard;
                cvc.vaild = _certificationModel.termtime;
                [self.navigationController pushViewController:cvc animated:YES];
            }else if ([_certificationModel.status isEqualToString:@"0"] && !_certificationModel.businesscard){
                EnterPriseCertificationViewController* evc = [[EnterPriseCertificationViewController alloc]init];
                evc.enterPriseName = _certificationModel.name;
                [self.navigationController pushViewController:evc animated:YES];
            }else if ([_certificationModel.status isEqualToString:@"0"] && _certificationModel.businesscard){
                CertificationFailedViewController* cvc = [[CertificationFailedViewController alloc]init];
                cvc.enterPriseName = _certificationModel.name;
                cvc.licenseImage = _certificationModel.businesscard;
                cvc.licenseImages = _certificationModel.businesscards;
                cvc.vaild = _certificationModel.termtime;
                cvc.failedReason = _certificationModel.applynoly;
                [self.navigationController pushViewController:cvc animated:YES];
            }
            
        }
            break;
    }
}


#pragma mark - data

-(NSArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = @[@"qiyezhanting",@"wodezhanting",@"haoyouqiye",@"qiyequanzi",@"qiyerenzheng"];
    }
    return _imageArr;
}

-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"企业展厅",@"我的展厅",@"好友企业",@"企业圈子",@"企业认证"];
    }
    return _titleArr;
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
