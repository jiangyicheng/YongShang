//
//  MyDisplayRoomFinishViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/31.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MyDisplayRoomFinishViewController.h"
#import "MyDisplayRoomFirstViewController.h"
#import "MyDisplayRoomViewController.h"
#import "EnterPriseDisPlayRoomDetailCollectionReusableView.h"
#import "EnterPriseDisPlayRoomDetailCollectionViewCell.h"

@interface MyDisplayRoomFinishViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate,UINavigationControllerDelegate>
{
    CGFloat labHeigth;
    CGFloat addressHeight;
    NSArray* _imageUrlArray;
    NSArray* _BigImageUrlArray;
    UIViewController* _viewController;
    EnterPriseDetailModel* _detailModel;
    UICollectionViewFlowLayout* _layout;
}
@property(nonatomic,strong)UICollectionView* mianCollectionView;
@property(nonatomic,strong)UIScrollView* mainScrollView;
@end

@implementation MyDisplayRoomFinishViewController

/*------------------------------网络------------------------------------*/

-(void)loadEnterPriseDetailData
{
    [self showprogressHUD];
    [YSBLL getEnterPriseResultWithFlagId:[UserModel shareInstanced].companyId andCompanyid:@"" Block:^(EnterPriseDetailModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _detailModel = model;
            NSLog(@"%@",_detailModel.mainbusiness);
            _imageUrlArray = [[NSArray alloc]init];
            _BigImageUrlArray = [[NSArray alloc]init];
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
                _BigImageUrlArray = [bigImageStr componentsSeparatedByString:@","];
            }
            NSString* mainBussinessStr = model.mainbusiness;
            mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            labHeigth = [self kdetailTextHeight:mainBussinessStr width:SCREEN_WIDTH - getNumWithScanf(194) - 5];
            addressHeight = MAX( [self kdetailTextHeight:_detailModel.linkaddress width:SCREEN_WIDTH - getNumWithScanf(194) - 5] , getNumWithScanf(28) );
            NSLog(@"----urls===%@",_imageUrlArray);
            _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, getNumWithScanf(328) + MAX(labHeigth, getNumWithScanf(28)) + addressHeight);
            [self.view addSubview:self.mainScrollView];
            [self.mainScrollView addSubview:self.mianCollectionView];
            [self judgeCollectionViewHeight];
            [self.mianCollectionView reloadData];
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
 *  根据图片数量判断collection view高度
 */
-(void)judgeCollectionViewHeight
{
    if (!_imageUrlArray.count) {
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,MAX(getNumWithScanf(458)+ MAX(labHeigth, getNumWithScanf(28) + addressHeight), SCREEN_HEIGHT - 64));
        self.mianCollectionView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight);
    }else if (_imageUrlArray.count <= 3) {
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,MAX(getNumWithScanf(458)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3, SCREEN_HEIGHT - 64));
        self.mianCollectionView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight+(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3);
    }else if (_imageUrlArray.count <= 6)
    {
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,MAX(getNumWithScanf(458)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3*2+10, SCREEN_HEIGHT - 64));
        self.mianCollectionView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358)+ MAX(labHeigth, getNumWithScanf(28)) + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3*2+10);
    }
}

/*------------------------------页面------------------------------------*/

-(void)viewWillAppear:(BOOL)animated
{
    [self loadEnterPriseDetailData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"我的展厅详情"];
//    self.navigationController.delegate = self;
    [self createNavTitle];
//    [self.view addSubview:self.mianCollectionView];
//    [self judgeCollectionViewHeight];
//    [self.mianCollectionView reloadData];
}



-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(50))];
    editBtn.titleLabel.font = DEF_FontSize_12;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editMyDisPlayRoom) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - function

/**
 *  返回按钮点击事件
 */
-(void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  编辑我的展厅
 */
-(void)editMyDisPlayRoom
{
    MyDisplayRoomViewController* mvc = [[MyDisplayRoomViewController alloc]init];
    mvc.model = _detailModel;
    [self.navigationController pushViewController:mvc animated:YES];
}

#pragma mark - Init

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
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake((SCREEN_WIDTH - getNumWithScanf(64) - 20)/3, (SCREEN_WIDTH - getNumWithScanf(64) - 20)/3);
        _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, getNumWithScanf(338) + MAX(labHeigth, getNumWithScanf(28)) + addressHeight);
        _layout.sectionInset = UIEdgeInsetsMake(0, getNumWithScanf(20), 0, getNumWithScanf(20));
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
        
        _mianCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(358) + labHeigth + addressHeight +(SCREEN_WIDTH - getNumWithScanf(64) - 20)/3 + 10) collectionViewLayout:_layout];
        _mianCollectionView.layer.masksToBounds = YES;
        _mianCollectionView.layer.cornerRadius = 5;
        _mianCollectionView.layer.borderColor = getColor(@"dddddd").CGColor;
        _mianCollectionView.layer.borderWidth = 0.5;
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
    browser.imageCount = _BigImageUrlArray.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _BigImageUrlArray[index];
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
