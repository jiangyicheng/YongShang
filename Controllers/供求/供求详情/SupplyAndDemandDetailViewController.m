//
//  SupplyAndDemandDetailViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "SupplyAndDemandDetailViewController.h"
#import "ReportViewController.h"
#import "ChatMessageViewController.h"
#import "GQSupplyAndDemandDetailsModel.h"
#import "RePublishSellAndBuyViewController.h"
#import "RePublishSellAndBuyViewController.h"
#import "EnterPriseDisPlayRoomDetailCollectionViewCell.h"

@interface SupplyAndDemandDetailViewController ()<AlertViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate,UINavigationControllerDelegate>
{
    UIButton* _contactBtn;      //在线沟通
    UIButton* _publishAgainBtn;  //重新发布
    UIButton* _publishCancleBtn; //取消发布
    MyLabel* _companyNameLab;
    MyLabel * _SupplyAndDemandLab;
    UILabel* _contactPeopleLab;
    UILabel* _contactTelLab;
    UILabel* _firstLab;         //企业名称（不变）
    UILabel* _secondLab;        //供应（不变）
    UILabel* _thirdLab;         //联系人（不变）
    UILabel* _fourthLab;         //联系电话（不变）
    UILabel* _fivthlab;          //产品图片（不变）
    CGFloat _testHeight;
    CGFloat _companynameHeight;
    GQSupplyAndDemandDetailsModel* _detailModel;
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
    NSArray* _imageUrlArray;
    NSArray* _BigImageUrlArray;
    CGFloat _collectionViewHeight;
    UIViewController* _viewController;
}
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)UICollectionView* collectionView;     //装载图片容器

@end

@implementation SupplyAndDemandDetailViewController

/*------------------------------网络------------------------------------*/

-(void)loadSupplyAndDemandDetailInfo
{
    [self showprogressHUD];
    [YSBLL SupplyAndDemandDetailWithFlagId:self.flagId andCompanyId:[UserModel shareInstanced].companyId andResultBlock:^(GQSupplyAndDemandDetailsModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _detailModel = model;
            NSLog(@"头像－－－%@",_detailModel.companyname);
            
            _imageUrlArray = [[NSArray alloc]init];
            _BigImageUrlArray = [[NSArray alloc]init];
            if (![model.sellbuyimage1 isEqualToString:@""]) {
                NSString* tempStr = [model.sellbuyimage1 substringWithRange:NSMakeRange(0, 1)];
                NSString* smallImageStr = model.sellbuyimage1s;
                NSString* bigImageStr = model.sellbuyimage1;
                //如果第一个字符是逗号的话就删除逗号
                if ([tempStr isEqualToString:@","]) {
                    smallImageStr = [smallImageStr substringWithRange:NSMakeRange(1, smallImageStr.length-1)];
                    bigImageStr = [bigImageStr substringWithRange:NSMakeRange(1, bigImageStr.length-1)];
                }
                _imageUrlArray = [smallImageStr componentsSeparatedByString:@","];
                _BigImageUrlArray = [bigImageStr componentsSeparatedByString:@","];
            }
    
            _companynameHeight = MAX([self kdetailTextHeight:_detailModel.companyname width:(SCREEN_WIDTH - getNumWithScanf(199))], getNumWithScanf(26)) ;
            NSString* mainBussinessStr = _detailModel.content;
            mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _testHeight = MAX([self kdetailTextHeight:mainBussinessStr width:(SCREEN_WIDTH - getNumWithScanf(199))], getNumWithScanf(26)) ;
            _collectionViewHeight = [self heightForCollectionView];
            [self.view addSubview:self.mainScrollView];
            [self.mainScrollView addSubview:self.bgView];
            [self createNavTitle];
            [self updateFrame];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  供求信息的撤销
 */
-(void)revocationOrPublishTheSupplyAndDemandWithFlagId:(NSString*)flagId andWithBtn:(UIButton*)btn
{
    [YSBLL revocationTheInfoWithFlagId:flagId andCreatecid:[UserModel shareInstanced].userID andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            
//            [self showTemplantMessage:@"取消成功"];
            [MBProgressHUD showSuccess:@"取消成功"];
//            [btn setTitle:@"重新发布" forState:UIControlStateNormal];
//            [self.navigationController popViewControllerAnimated:YES];
            [self loadSupplyAndDemandDetailInfo];
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限取消供求" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSupplyAndDemandDetailInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"供求详情"];
//    self.navigationController.delegate = self;
//    [self loadSupplyAndDemandDetailInfo];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (_viewController) {
        
    }
    if ([viewController isKindOfClass:[RePublishSellAndBuyViewController class]]) {
        _viewController = viewController;
    }
}

-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    editBtn.titleLabel.font = DEF_FontSize_13;
    [editBtn setTitle:@"举报" forState:UIControlStateNormal];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    if ([_detailModel.companyid integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
        self.navigationItem.rightBarButtonItems = @[];
    }else{
        self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
    }
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - function

/**
 *  返回按钮点击事件
 */
-(void)backToLastPage
{
//    self.navigationController.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)updateFrame
{
    self.bgView.frame = CGRectMake(getNumWithScanf(12), getNumWithScanf(6), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(205)+_testHeight + _companynameHeight + _collectionViewHeight);
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 64, getNumWithScanf(205)+_testHeight + _companynameHeight + _collectionViewHeight + getNumWithScanf(240)));
    _companyNameLab.text = _detailModel.companyname;
    _secondLab.text = [NSString stringWithFormat:@"%@:",_detailModel.typeName];
    NSString* mainBussinessStr = _detailModel.content;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _SupplyAndDemandLab.text = mainBussinessStr;
    _contactPeopleLab.text = _detailModel.linkman;
    if ([_detailModel.telphone isEqualToString:@"-1"]) {
        _contactTelLab.text = @"保密";
    }else{
        _contactTelLab.text = _detailModel.telphone;
    }
    [self layout];
    [self judgeBtnIsHidden];
    [self.collectionView reloadData];
}

//判断按钮是否隐藏
-(void)judgeBtnIsHidden
{
    if ([_detailModel.companyid integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
        _contactBtn.hidden = YES;
        if(self.publishStatus){
            if ([_detailModel.publishstatus isEqualToString:@"1"]) {
                _publishAgainBtn.hidden = YES;
                _publishCancleBtn.hidden = NO;
            }else if ([_detailModel.publishstatus isEqualToString:@"0"])
            {
                _publishAgainBtn.hidden = NO;
                _publishCancleBtn.hidden = YES;
            }
        }
    }else{
        _contactBtn.hidden = NO;
    }
}

-(CGFloat)heightForCollectionView
{
    if (!_imageUrlArray.count) {
        return 0;
    }else if (_imageUrlArray.count <= 3){
        return (SCREEN_WIDTH - getNumWithScanf(64) - 20)/3+10;
    }else if (_imageUrlArray.count <= 6){
        return (SCREEN_WIDTH - getNumWithScanf(64) - 20)/3*2 + 20;
    }
    return 0;
}

/**
 *  举报
 */
-(void)reportClick
{
    ReportViewController* rvc = [[ReportViewController alloc]init];
    rvc.BecomplaintedUId = _detailModel.qcid;
    rvc.beComplaintedCId = @"";
    rvc.complaintedUId = [UserModel shareInstanced].userID;
    rvc.complaintedCId = @"";
    rvc.infomationSource = @"2";
    rvc.flagId = self.flagId;
    rvc.context = _detailModel.content;
    rvc.contextimage = @"";
    [self.navigationController pushViewController:rvc animated:YES];
}

/**
 *  在线交流
 */
-(void)contactWithPeople
{
    ChatMessageViewController* cvc =[[ChatMessageViewController alloc]init];
    cvc.qcId = _detailModel.qcid;
    cvc.companyName = _companyNameLab.text;
    cvc.supplyAndDemandString = _SupplyAndDemandLab.text;
    cvc.linkMan = _contactPeopleLab.text;
    cvc.telPhone = _contactTelLab.text;
    cvc.headImageUrl  = _detailModel.headimgurl;
    cvc.GQName = _detailModel.typeName;
    cvc.sellbuyid = self.flagId;
    [self.navigationController pushViewController:cvc animated:YES];
}

/**
 *  重新发布
 */
-(void)publishTheInfoAgain
{
    RePublishSellAndBuyViewController* rvc = [[RePublishSellAndBuyViewController alloc]init];
    rvc.flagId = self.supplyInfoId;
    rvc.formIndex = @"2";
    [self.navigationController pushViewController:rvc animated:YES];
//    AddNewSupplyAndDemandViewController* avc = [[AddNewSupplyAndDemandViewController alloc]init];
//    avc.flagId = self.supplyInfoId;
//    avc.formIndex = @"2";
//    [self.navigationController pushViewController:avc animated:YES];
}

/**
 *  取消发布
 */
-(void)canclePublishTheInfo:(UIButton*)btn
{
    [self showAlertView];
}

/**
 *  提示框确定按钮点击事件
 */
-(void)alertViewConfirmBtnClick
{
    [self revocationOrPublishTheSupplyAndDemandWithFlagId:self.supplyInfoId andWithBtn:_publishCancleBtn];
    [self hiddenAlertView];
}

/**
 *  提示框取消按钮点击事件
 */
-(void)alertViewCancleBtnClick
{
    [self hiddenAlertView];
}

/**
 *  提示框展示
 */
-(void)showAlertView
{
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    _alertView = [[AlertView alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(530), getNumWithScanf(200))];
    _blackView = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    _alertView.center = _blackView.center;
    _alertView.layer.cornerRadius = 5;
    _alertView.contentlab.text = @"是否确定取消发布该供求";
    _alertView.layer.masksToBounds = YES;
    _alertView.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    [_blackView addSubview:_alertView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

/**
 *  提示框消失
 */
-(void)hiddenAlertView
{
    [UIView animateWithDuration:0.2 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _alertView.hidden = YES;
    } completion:^(BOOL finished) {
        _blackView.hidden = YES;
        [_blackView removeFromSuperview];
    }];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Init

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _mainScrollView.backgroundColor = getColor(@"f7f7f7");
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 64, getNumWithScanf(205)+_testHeight + _companynameHeight + _collectionViewHeight) + getNumWithScanf(240));
        
    }
    return _mainScrollView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - getNumWithScanf(64) - 20)/3, (SCREEN_WIDTH - getNumWithScanf(64) - 20)/3);
        layout.sectionInset = UIEdgeInsetsMake(0, getNumWithScanf(20), 0, getNumWithScanf(20));
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), _collectionViewHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[EnterPriseDisPlayRoomDetailCollectionViewCell class] forCellWithReuseIdentifier:@"DisPlayRoomCell"];
    }
    return _collectionView;
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(6), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(205)+_testHeight + _companynameHeight + _collectionViewHeight)];
        _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
    }
    return _bgView;
}

-(void)createSubviews
{
    //公司名称
    _companyNameLab = [[MyLabel alloc]init];
    _companyNameLab.textColor = getColor(@"595959");
    _companyNameLab.font = DEF_FontSize_13;
    _companyNameLab.textAlignment = NSTextAlignmentLeft;
    _companyNameLab.lineBreakMode = NSLineBreakByWordWrapping;
    [_companyNameLab setVerticalAlignment:VerticalAlignmentTop];
    _companyNameLab.numberOfLines = 0;
    _companyNameLab.text = _detailModel.companyname;
    [_bgView addSubview:_companyNameLab];
    
    _firstLab = [[UILabel alloc]init];
    _firstLab.textColor = getColor(@"595959");
    _firstLab.font = DEF_FontSize_13;
    _firstLab.text = @"企业名称:";
    [_bgView addSubview:_firstLab];
    
    _secondLab = [[UILabel alloc]init];
    _secondLab.textColor = getColor(@"595959");
    _secondLab.font = DEF_FontSize_13;
    _secondLab.text = [NSString stringWithFormat:@"%@:",_detailModel.typeName];
    [_bgView addSubview:_secondLab];
    
    _SupplyAndDemandLab = [[MyLabel alloc]init];
    _SupplyAndDemandLab.textColor = getColor(@"595959");
    _SupplyAndDemandLab.font = DEF_FontSize_13;
    _SupplyAndDemandLab.textAlignment = NSTextAlignmentLeft;
    _SupplyAndDemandLab.lineBreakMode = NSLineBreakByWordWrapping;
    [_SupplyAndDemandLab setVerticalAlignment:VerticalAlignmentTop];
    _SupplyAndDemandLab.numberOfLines = 0;
    NSString* mainBussinessStr = _detailModel.content;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    mainBussinessStr = [mainBussinessStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    _SupplyAndDemandLab.text = mainBussinessStr;
    [_bgView addSubview:_SupplyAndDemandLab];
    
    _thirdLab = [[UILabel alloc]init];
    _thirdLab.textColor = getColor(@"595959");
    _thirdLab.font = DEF_FontSize_13;
    _thirdLab.text = @"联系人:";
    [_bgView addSubview:_thirdLab];
    
    _fourthLab = [[UILabel alloc]init];
    _fourthLab.textColor = getColor(@"595959");
    _fourthLab.font = DEF_FontSize_13;
    _fourthLab.text = @"联系电话:";
    [_bgView addSubview:_fourthLab];
    
    _contactPeopleLab = [[UILabel alloc]init];
    _contactPeopleLab.textColor = getColor(@"595959");
    _contactPeopleLab.font = DEF_FontSize_13;
    _contactPeopleLab.text = _detailModel.linkman;
    [_bgView addSubview:_contactPeopleLab];
    
    _contactTelLab = [[UILabel alloc]init];
    _contactTelLab.textColor = getColor(@"595959");
    _contactTelLab.font = DEF_FontSize_13;
    
    //判断该企业是否为好友企业  是的话无论联系方式是否保密 都显示联系方式
//    BOOL isFriend = NO;
//    if (self.friendsId) {
//        for (int i = 0; i < self.friendsId.count; i++) {
//            if ([_detailModel.companyid integerValue] == [self.friendsId[i] integerValue]) {
//                isFriend = YES;
//            }
//        }
//    }
//    
//    if (isFriend) {
//        NSLog(@"---%@",_detailModel.telphone);
//        _contactTelLab.text = _detailModel.telphone;
//    }else{
//        if ([_detailModel.telphoneType isEqualToString:@"0"]) {
//            if ([_detailModel.companyid integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
//                _contactTelLab.text = _detailModel.telphone;
//            }else{
//               _contactTelLab.text = @"保密"; 
//            }
//            
//        }else if ([_detailModel.telphoneType isEqualToString:@"1"])
//        {
//            _contactTelLab.text = _detailModel.telphone;
//        }
//    }
    if ([_detailModel.telphone isEqualToString:@"-1"]) {
        _contactTelLab.text = @"保密";
    }else{
        _contactTelLab.text = _detailModel.telphone;
    }
    [_bgView addSubview:_contactTelLab];
    
    _fivthlab = [[UILabel alloc]init];
    _fivthlab.textColor = getColor(@"595959");
    _fivthlab.font = DEF_FontSize_13;
    _fivthlab.text = @"产品图片:";
    [_bgView addSubview:_fivthlab];
    
    [_bgView addSubview:self.collectionView];
    
    //在线沟通
    _contactBtn  = [[UIButton alloc]init];
    [_contactBtn setTitle:@"在线沟通" forState:UIControlStateNormal];
    [_contactBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _contactBtn.backgroundColor = getColor(@"3fbefc");
    _contactBtn.layer.masksToBounds = YES;
    _contactBtn.layer.cornerRadius = 5;
    [_contactBtn addTarget:self action:@selector(contactWithPeople) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:_contactBtn];
    
    //重新发布
    _publishAgainBtn  = [[UIButton alloc]init];
    [_publishAgainBtn setTitle:@"重新发布" forState:UIControlStateNormal];
    [_publishAgainBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _publishAgainBtn.backgroundColor = getColor(@"3fbefc");
    _publishAgainBtn.layer.masksToBounds = YES;
    _publishAgainBtn.layer.cornerRadius = 5;
    _publishAgainBtn.hidden = YES;
    [_publishAgainBtn addTarget:self action:@selector(publishTheInfoAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:_publishAgainBtn];
    
    //取消发布
    _publishCancleBtn  = [[UIButton alloc]init];
    [_publishCancleBtn setTitle:@"取消发布" forState:UIControlStateNormal];
    [_publishCancleBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _publishCancleBtn.backgroundColor = getColor(@"3fbefc");
    _publishCancleBtn.layer.masksToBounds = YES;
    _publishCancleBtn.layer.cornerRadius = 5;
    _publishCancleBtn.hidden = YES;
    [_publishCancleBtn addTarget:self action:@selector(canclePublishTheInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:_publishCancleBtn];
    
    
    [self judgeBtnIsHidden];
    
    [self layout];
    
}

-(void)layout
{
    _firstLab.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(28))
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130));

    _companyNameLab.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(18))
    .heightIs(getNumWithScanf(5)+_companynameHeight)
    .leftSpaceToView(_firstLab,getNumWithScanf(5))
    .rightSpaceToView(_bgView,getNumWithScanf(20));
    
    _secondLab.sd_layout
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(28))
    .widthIs(getNumWithScanf(130))
    .topSpaceToView(_companyNameLab,getNumWithScanf(18));
    
    _SupplyAndDemandLab.sd_layout
    .topSpaceToView(_companyNameLab,getNumWithScanf(16))
    .leftSpaceToView(_secondLab,getNumWithScanf(5))
    .heightIs(_testHeight+getNumWithScanf(5))
    .rightSpaceToView(_bgView,getNumWithScanf(20));
    
    _thirdLab.sd_layout
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(28))
    .widthIs(getNumWithScanf(130))
    .topSpaceToView(_SupplyAndDemandLab,getNumWithScanf(18));
    
    _contactPeopleLab.sd_layout
    .topEqualToView(_thirdLab)
    .leftSpaceToView(_thirdLab,getNumWithScanf(5))
    .heightIs(getNumWithScanf(28))
    .rightSpaceToView(_bgView,getNumWithScanf(30));
    
    _fourthLab.sd_layout
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(28))
    .widthIs(getNumWithScanf(130))
    .topSpaceToView(_thirdLab,getNumWithScanf(18));
    
    _contactTelLab.sd_layout
    .topEqualToView(_fourthLab)
    .leftSpaceToView(_fourthLab,getNumWithScanf(5))
    .heightIs(getNumWithScanf(28))
    .rightSpaceToView(_bgView,getNumWithScanf(30));
    
    _fivthlab.sd_layout
    .topSpaceToView(_fourthLab,getNumWithScanf(20))
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(28))
    .widthIs(getNumWithScanf(130));
    
    _collectionView.sd_layout
    .leftSpaceToView(_bgView,0)
    .rightSpaceToView(_bgView,0)
    .bottomSpaceToView(_bgView,0)
    .topSpaceToView(_fivthlab,10);
    
    _contactBtn.sd_layout
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .topSpaceToView(_bgView,getNumWithScanf(80))
    .heightIs(getNumWithScanf(80));
    
    _publishAgainBtn.sd_layout
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .topSpaceToView(_bgView,getNumWithScanf(80))
    .heightIs(getNumWithScanf(80));
    
    _publishCancleBtn.sd_layout
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .topSpaceToView(_bgView,getNumWithScanf(80))
    .heightIs(getNumWithScanf(80));
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
    EnterPriseDisPlayRoomDetailCollectionViewCell* cell = (EnterPriseDisPlayRoomDetailCollectionViewCell*)[_collectionView cellForItemAtIndexPath:indexpath];
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
