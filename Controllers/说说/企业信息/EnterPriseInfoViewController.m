//
//  EnterPriseInfoViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/8.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseInfoViewController.h"
#import "EnterPriseDisPlayRoomDetailCollectionReusableView.h"
#import "EnterPriseDisPlayRoomDetailCollectionViewCell.h"
#import "TalkTalkSetUpViewController.h"

@interface EnterPriseInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate>

{
    UIButton* _passBtn;   //通过
    UIButton* _refuseBtn; //拒绝
    UIButton* _relieveBtn; //解除好友关系
    UIButton* _applyBtn;   //申请好友关系
    CGFloat labHeigth;
    CGFloat addressHeight;
    NSArray* _imageUrlArray;
    NSArray* _bigImageArray;
    EnterPriseDetailModel* _detailModel;
}

@property(nonatomic,strong)UICollectionView* mianCollectionView;
@property(nonatomic,strong)UIScrollView* mainScrollView;

@end

@implementation EnterPriseInfoViewController

/*------------------------------网络------------------------------------*/

/**
 *  企业详情接口
 */
-(void)loadEnterPriseDetailData
{
    [YSBLL getEnterPriseResultWithFlagId:self.companyID andCompanyid:[UserModel shareInstanced].companyId Block:^(EnterPriseDetailModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _detailModel = model;
            _imageUrlArray = [[NSMutableArray alloc]init];
            if (![model.producturl1s isEqualToString:@""]) {
                NSString* tempStr = [_detailModel.producturl1s substringWithRange:NSMakeRange(0, 1)];
                NSString* smallImageStr = _detailModel.producturl1s;
                NSString* bigImageStr = _detailModel.producturl1;
                //如果第一个字符是逗号的话就删除逗号
                if ([tempStr isEqualToString:@","]) {
                    smallImageStr = [smallImageStr substringWithRange:NSMakeRange(1, smallImageStr.length-1)];
                    bigImageStr = [bigImageStr substringWithRange:NSMakeRange(1, bigImageStr.length-1)];
                }
                _imageUrlArray = [smallImageStr componentsSeparatedByString:@","];
                _bigImageArray = [bigImageStr componentsSeparatedByString:@","];
            }
            
            [self.view addSubview:self.mainScrollView];
            [self.mainScrollView addSubview:self.mianCollectionView];
            [self creatBtn];
            [self judgeCollectionViewHeight];
            [self judge];
        }else if ([model.ecode isEqualToString:@"-1"])
        {
            NSLog(@"异常错误");
        }else if ([model.ecode isEqualToString:@"-2"])
        {
            NSLog(@"请求数据失败");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  申请好友企业关系
 */
-(void)requestApplyFriendShip
{
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/applyFriendBusiness.do?createid=%@&createcompanyid=%@&friendid=%@&u_code=%@",[UserModel shareInstanced].userID,[UserModel shareInstanced].companyId,self.companyID,[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _applyBtn.backgroundColor = getColor(@"abe5fe");
            _applyBtn.enabled = NO;
            NSLog(@"model%@",model.emessage);
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  通过/拒绝/解除好友企业申请
 */
-(void)passFriendShipApplyWithType:(NSString*)type
{
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/friendsBusinessApply.do?createcompanyid=%@&friendid=%@&lxtype=%@&u_code=%@",[UserModel shareInstanced].companyId,@"",type,[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  根据图片数量判断collection view高度
 */
-(void)judgeCollectionViewHeight
{
    
    if (!_imageUrlArray.count) {
        self.mianCollectionView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight);
    }else if (_imageUrlArray.count <= 3) {
        self.mianCollectionView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3);
    }else if (_imageUrlArray.count <= 6)
    {
        self.mianCollectionView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3*2+10);
    }
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,MAX(self.mianCollectionView.frame.size.height+getNumWithScanf(250), SCREEN_HEIGHT - 64));
}

/*------------------------------页面------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"企业信息"];
    [self createNavTitle];
    [self loadEnterPriseDetailData];
}

-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    editBtn.titleLabel.font = DEF_FontSize_13;
    [editBtn setTitle:@"设置" forState:UIControlStateNormal];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(setUpBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    
    if ([self.companyID integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
        self.navigationItem.rightBarButtonItems = @[];
    }else {
        self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
    }
}


#pragma mark - function

/**
 *  根据数据判断当前企业与目标企业的关系
 */
-(void)judge
{
    NSLog(@"----%@",_detailModel.type);
    
    if ([_detailModel.type isEqualToString:@"11"]){
        //11.被申请
        _relieveBtn.hidden = YES;
        _refuseBtn.hidden = NO;
        _passBtn.hidden = NO;
        _applyBtn.hidden = YES;
    }else if ([_detailModel.type isEqualToString:@"2"]){
        //2.已是好友
        _relieveBtn.hidden = NO;
        _refuseBtn.hidden = YES;
        _passBtn.hidden = YES;
        _applyBtn.hidden = YES;
    }else if ([_detailModel.type isEqualToString:@"1"]){
        //1. 已申请
        _relieveBtn.hidden = YES;
        _passBtn.hidden = YES;
        _refuseBtn.hidden = YES;
        _refuseBtn.enabled = YES;
        _applyBtn.hidden = NO;
    }else if([_detailModel.type isEqualToString:@"0"] && [[UserModel shareInstanced].companyId integerValue] != [self.companyID integerValue]){
        //0无任何关系
        _relieveBtn.hidden = YES;
        _refuseBtn.hidden = YES;
        _passBtn.hidden = YES;
        _applyBtn.hidden = NO;
        [_applyBtn setBackgroundColor:getColor(@"3fbefc")];
    }else {
        _relieveBtn.hidden = YES;
        _refuseBtn.hidden = YES;
        _passBtn.hidden = YES;
        _applyBtn.hidden = YES;
    }
}

/**
 *  设置
 */
-(void)setUpBtnDidClick
{
    TalkTalkSetUpViewController* tvc = [[TalkTalkSetUpViewController alloc]init];
    tvc.limitCompanyId = self.companyID;
    [self.navigationController pushViewController:tvc animated:YES];
}

/**
 *  通过好友申请
 */
-(void)passTheApplyFriendShip
{
    [self passFriendShipApplyWithType:@"2"];
}

/**
 *  拒绝或者解除好友企业关系
 */
-(void)refuseAndRelieveFriendShip
{
    [self passFriendShipApplyWithType:@"0"];
}

-(void)applyTheFriendsShips
{
    [self requestApplyFriendShip];
}

#pragma mark - Init

-(void)creatBtn
{
    _applyBtn = [[UIButton alloc]init];
    [_applyBtn setTitle:@"申请好友企业关系" forState:UIControlStateNormal];
    [_applyBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _applyBtn.backgroundColor = getColor(@"abe5fe");
    _applyBtn.layer.masksToBounds = YES;
    _applyBtn.layer.cornerRadius = 8;
    [_applyBtn addTarget:self action:@selector(applyTheFriendsShips) forControlEvents:UIControlEventTouchUpInside];
    _applyBtn.titleLabel.font = DEF_FontSize_13;
    [self.mainScrollView addSubview:_applyBtn];
    
    _relieveBtn = [[UIButton alloc]init];
    [_relieveBtn setTitle:@"解除好友企业关系" forState:UIControlStateNormal];
    [_relieveBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _relieveBtn.backgroundColor = getColor(@"ea2d4c");
    _relieveBtn.layer.masksToBounds = YES;
    _relieveBtn.layer.cornerRadius = 8;
    _relieveBtn.titleLabel.font = DEF_FontSize_13;
    [_relieveBtn addTarget:self action:@selector(refuseAndRelieveFriendShip) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:_relieveBtn];
    
    _passBtn = [[UIButton alloc]init];
    [_passBtn setTitle:@"通过" forState:UIControlStateNormal];
    [_passBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _passBtn.backgroundColor = getColor(@"3fbefc");
    _passBtn.layer.masksToBounds = YES;
    _passBtn.layer.cornerRadius = 8;
    [_passBtn addTarget:self action:@selector(passTheApplyFriendShip) forControlEvents:UIControlEventTouchUpInside];
    _passBtn.titleLabel.font = DEF_FontSize_13;
    [self.mainScrollView addSubview:_passBtn];
    
    _refuseBtn = [[UIButton alloc]init];
    [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _refuseBtn.backgroundColor = getColor(@"ea2d4c");
    _refuseBtn.layer.masksToBounds = YES;
    _refuseBtn.layer.cornerRadius = 8;
    [_refuseBtn addTarget:self action:@selector(refuseAndRelieveFriendShip) forControlEvents:UIControlEventTouchUpInside];
    _refuseBtn.titleLabel.font = DEF_FontSize_13;
    [self.mainScrollView addSubview:_refuseBtn];
    
    _passBtn.sd_layout
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .topSpaceToView(self.mianCollectionView,getNumWithScanf(80))
    .heightIs(getNumWithScanf(80))
    .widthIs((SCREEN_WIDTH - getNumWithScanf(90))/2);
    
    _refuseBtn.sd_layout
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .widthIs((SCREEN_WIDTH - getNumWithScanf(90))/2)
    .heightIs(getNumWithScanf(80))
    .topSpaceToView(self.mianCollectionView,getNumWithScanf(80));
    
    _relieveBtn.sd_layout
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .heightIs(getNumWithScanf(80))
    .topSpaceToView(self.mianCollectionView,getNumWithScanf(80));
    
    _applyBtn.sd_layout
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .heightIs(getNumWithScanf(80))
    .topSpaceToView(self.mianCollectionView,getNumWithScanf(80));
    
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64)];
        _mainScrollView.backgroundColor = getColor(@"f7f7f7");
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
    }
    return _mainScrollView;
}

-(UICollectionView *)mianCollectionView
{
    if (!_mianCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - getNumWithScanf(64) - 20)/3, (SCREEN_WIDTH - getNumWithScanf(64) - 20)/3);
        labHeigth = [self kdetailTextHeight:_detailModel.mainbusiness width:SCREEN_WIDTH - getNumWithScanf(194) - 5];
        addressHeight = MAX([self kdetailTextHeight:_detailModel.linkaddress width:SCREEN_WIDTH - getNumWithScanf(194) - 5] , getNumWithScanf(26));
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, getNumWithScanf(338) + MAX(labHeigth, getNumWithScanf(26)) + addressHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, getNumWithScanf(20), 0, getNumWithScanf(20));
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        _mianCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+MAX(labHeigth, getNumWithScanf(26)) + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3*2+10) collectionViewLayout:layout];
        _mianCollectionView.layer.masksToBounds = YES;
        _mianCollectionView.layer.cornerRadius = 5;
        _mianCollectionView.delegate = self;
        _mianCollectionView.dataSource = self;
        _mianCollectionView.backgroundColor = [UIColor whiteColor];
        [_mianCollectionView registerClass:[EnterPriseDisPlayRoomDetailCollectionViewCell class] forCellWithReuseIdentifier:@"DisPlayRoomCell"];
        [_mianCollectionView registerClass:[EnterPriseDisPlayRoomDetailCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DisplayRoomHeaderView"];
    }
    return _mianCollectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EnterPriseDisPlayRoomDetailCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DisPlayRoomCell" forIndexPath:indexPath];
    [cell.enterPriseShowPictureView sd_setImageWithURL:[NSURL URLWithString:_imageUrlArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    EnterPriseDisPlayRoomDetailCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DisplayRoomHeaderView" forIndexPath:indexPath];
    headerView.model = _detailModel;
    return headerView;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //浏览大图
    SDPhotoBrowser* browser = [[SDPhotoBrowser alloc]init];
    browser.currentImageIndex = indexPath.item;
    browser.sourceImagesContainerView = collectionView;
    browser.imageCount = _bigImageArray.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _bigImageArray[index];
    NSURL* url = [NSURL URLWithString:imageName];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSIndexPath* indexpath = [NSIndexPath indexPathForItem:index inSection:0];
    EnterPriseDisPlayRoomDetailCollectionViewCell* cell = (EnterPriseDisPlayRoomDetailCollectionViewCell*)[_mianCollectionView cellForItemAtIndexPath:indexpath];
    return cell.enterPriseShowPictureView.image;
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
