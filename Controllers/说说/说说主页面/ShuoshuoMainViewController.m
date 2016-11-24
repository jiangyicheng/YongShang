//
//  ShuoshuoMainViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ShuoshuoMainViewController.h"
#import "ShuoShuoTableViewCell.h"
#import "shuoshuoModel.h"
#import "PublishAnnounceShuoShuoViewController.h"
#import "MyShuoShuoViewController.h"
#import "SelectAlbumCoverViewController.h"
#import "CommentDetailViewController.h"
#import "EnterPriseInfoViewController.h"
#import "SSAllTalkDetailModel.h"
#import "MyTalkTalkCommentDetailViewController.h"
#import "MyDisplayRoomFinishViewController.h"

@interface ShuoshuoMainViewController ()<UITableViewDataSource,UITableViewDelegate,DeleteTalkTalkDelegate,AlertViewDelegate,UINavigationControllerDelegate>

{
    UIImageView* _bgImageView;
    UIImageView* _personImageView;       //头像
    UILabel* _companyLab;             //公司名称
    UILabel* _personNameLab;          //姓名
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
    NSIndexPath* _deleteIndexPath;    //删除的cell位置
    UIButton* _changeAlbumBtn;         //更换相册封面
    AllTalkTalkModel* _talktalkModel;
    SSAllTalkDetailModel* _allTalkTalkDetailModel;
    NSMutableArray* _shuoshuoModelArray;
    NSIndexPath* _selectIndex;
    NSInteger _page;
    NSInteger _pageSize;
    UIViewController* _viewController;
}

@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong) UIView* headView;

@end

@implementation ShuoshuoMainViewController

/*------------------------------网络------------------------------------*/

-(void)getAllTalkTalkDetail
{
    _page = 1;
    [self showprogressHUD];
    [YSBLL GetAllShuoShuoDetailWithFlagId:[UserModel shareInstanced].userID andCreatecompanyid:[UserModel shareInstanced].companyId andOrgid:[UserModel shareInstanced].tradeId andPageSize:_pageSize andCurrentPage:_page andResultBlock:^(AllTalkTalkModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _talktalkModel = model;
            NSLog(@"相册封面---%@",_talktalkModel.talkurl);
            [UserModel shareInstanced].nickName = _talktalkModel.companyname;
            [UserModel shareInstanced].name = _talktalkModel.linkman;
            _companyLab.text = _talktalkModel.companyname;
            _personNameLab.text = _talktalkModel.linkman;
            _shuoshuoModelArray = [[NSMutableArray alloc]init];
            [_talktalkModel.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SSAllTalkDetailModel* detailModel = [SSAllTalkDetailModel yy_modelWithJSON:obj];
                [_shuoshuoModelArray addObject:detailModel];
//                NSLog(@"quid---%@",detailModel);
            }];
            if (_bgImageView) {
                [_bgImageView sd_setImageWithURL:[NSURL URLWithString:_talktalkModel.talkurl] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            [self.view addSubview:self.mainTableView];
            self.automaticallyAdjustsScrollViewInsets = NO;
            NSLog(@"4");
            [self.mainTableView reloadData];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误1");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  加载更多说说
 */
-(void)loadMoreShuoShuoData
{
    _page++;
    _pageSize = 10;
    [self showprogressHUD];
    [YSBLL GetAllShuoShuoDetailWithFlagId:[UserModel shareInstanced].userID andCreatecompanyid:[UserModel shareInstanced].companyId andOrgid:[UserModel shareInstanced].tradeId andPageSize:_pageSize andCurrentPage:_page andResultBlock:^(AllTalkTalkModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSMutableArray* moreDataArray = [[NSMutableArray alloc]init];
            [model.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SSAllTalkDetailModel* detailModel = [SSAllTalkDetailModel yy_modelWithJSON:obj];
                [moreDataArray addObject:detailModel];
            }];
            
            [_shuoshuoModelArray addObjectsFromArray:moreDataArray];
            [self.mainTableView reloadData];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误1");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  删除我的说说
 *
 *  @param flagId 说说Id
 */
-(void)deleteMyShuoShuoWithFlagId:(NSString*)flagId
{
    [YSBLL DeleteMyShuoShuoDetailWithFlagId:flagId andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
           [_shuoshuoModelArray removeObjectAtIndex:_deleteIndexPath.section];
            [self.mainTableView reloadData];
//            [self getAllTalkTalkDetail];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误1");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限删除说说" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
    }];
}

/**
 *  点赞
 *
 *  @param type     点赞
 *  @param flagId   说说编号
 *  @param friendId 说说的用户编号
 */
-(void)commentAndPriseWithType:(NSString*)type withFlagId:(NSString*)flagId withFriendId:(NSString*)friendId withBtn:(UIButton*)btn
{
    [YSBLL shuoshuoCommentAndPriseFlagId:flagId andCreateid:[UserModel shareInstanced].userID andFriendid:friendId andLxtype:type andMemo:@"" andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
//            [self getAllTalkTalkDetail];
            if ([type isEqualToString:@"3"]) {
                btn.selected = NO;
                _allTalkTalkDetailModel.is_clicklike = @"0";
                NSInteger clickNum = [_allTalkTalkDetailModel.clickliketotal integerValue];
                clickNum--;
//                NSLog(@"--%ld",clickNum);
                _allTalkTalkDetailModel.clickliketotal = [NSString stringWithFormat:@"%ld",clickNum];
                [btn setTitle:[NSString stringWithFormat:@"%ld",clickNum] forState:UIControlStateNormal];
            }else{
                btn.selected = YES;
                _allTalkTalkDetailModel.is_clicklike = @"1";
                NSInteger clickNum = [_allTalkTalkDetailModel.clickliketotal integerValue];
                clickNum++;
                _allTalkTalkDetailModel.clickliketotal = [NSString stringWithFormat:@"%ld",clickNum];
//                NSLog(@"--%ld",clickNum);
                [btn setTitle:[NSString stringWithFormat:@"%ld",clickNum] forState:UIControlStateNormal];
            }
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误1");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限点赞" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
    }];
}

/*------------------------------页面------------------------------------*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (_bgImageView) {
//        if ([UserModel shareInstanced].avatar_path != nil) {
//            
//        }
//    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (_viewController &&[_viewController isKindOfClass:[SelectAlbumCoverViewController class]]) {
        [self getAllTalkTalkDetail];
    }
    if ([viewController isKindOfClass:[SelectAlbumCoverViewController class]]) {
        _viewController = viewController;
    }else{
        _viewController = nil;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* takephotoItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"takePhoto"] style:UIBarButtonItemStyleDone target:self action:@selector(takephotoClick)];
    self.navigationItem.rightBarButtonItem = takephotoItem;
    self.navigationController.delegate = self;
    //添加监听  监听评论数量改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentNumDidChanged:) name:@"commentNumChanged" object:nil];
    //监听删除说说
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTheShuoShuos:) name:@"deleteTheShuoShuo" object:nil];
    _pageSize = 10;
    [self getAllTalkTalkDetail];
    
    //接收通知  新增说说
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewShuoShuo:) name:@"addNewShuoShuo" object:nil];
}

#pragma mark - function

//新增说说(假数据)
-(void)addNewShuoShuo:(NSNotification*)noti
{
    SSAllTalkDetailModel* model = [[SSAllTalkDetailModel alloc]init];
    model.quid = [UserModel shareInstanced].userID;
    model.linkman = [UserModel shareInstanced].name;
    model.context = noti.userInfo[@"shuoshuoContent"];
    model.companyname = [UserModel shareInstanced].nickName;
    model.headimgurl = _talktalkModel.headimageurl;
    model.shuoshuoId = noti.userInfo[@"shuoshuoId"];
    model.createtime = noti.userInfo[@"shuoshuoCreatTime"];
    model.clickliketotal = @"0";
    model.messagetotal = @"0";
    model.is_clicklike = @"0";
    model.is_talkmessage = @"0";
    model.companyid = [UserModel shareInstanced].companyId;
    
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    NSArray* shuoshuoImageArr = noti.userInfo[@"shuoshuoImage"];
    for (int i = 0 ; i < 9; i++) {
        if (i < shuoshuoImageArr.count) {
            [arr addObject:shuoshuoImageArr[i]];
        }else{
            [arr addObject:@""];
        }
    }
    
    NSLog(@"arr---%@",arr);
    
    model.imageurl1 = arr[0];
    model.imageurl1s = arr[0];
    model.imageurl2 = arr[1];
    model.imageurl2s = arr[1];
    model.imageurl3 = arr[2];
    model.imageurl3s = arr[2];
    model.imageurl4 = arr[3];
    model.imageurl4s = arr[3];
    model.imageurl5 = arr[4];
    model.imageurl5s = arr[4];
    model.imageurl6 = arr[5];
    model.imageurl6s = arr[5];
    model.imageurl7 = arr[6];
    model.imageurl7s = arr[6];
    model.imageurl8 = arr[7];
    model.imageurl8s = arr[7];
    model.imageurl9 = arr[8];
    model.imageurl9s = arr[8];
    [_shuoshuoModelArray insertObject:model atIndex:0];
    [self.mainTableView reloadData];
}

/**
 * 通知方法 删除说说
 */
-(void)deleteTheShuoShuos:(NSNotification*)noti
{
    NSIndexPath* indexpath = noti.userInfo[@"selectIndexPath"];
    if (_shuoshuoModelArray.count) {
       [_shuoshuoModelArray removeObjectAtIndex:indexpath.section];
    }
    [self.mainTableView reloadData];
}

/**
 * 通知方法 改变评论的数量
 */
-(void)commentNumDidChanged:(NSNotification*)noti
{
    NSString* isComment = noti.userInfo[@"isComment"];
    NSInteger commentNumber = [noti.userInfo[@"commentNum"] integerValue];
//    NSInteger clickZanNum = [noti.userInfo[@"clickZanNum"] integerValue];
//    NSLog(@"---评论%@",isComment);
    ShuoShuoTableViewCell* cell = [self.mainTableView cellForRowAtIndexPath:_selectIndex];
    if ([isComment integerValue] > 0) {
        cell.commentAndPrise.commentBtn.selected = YES;
    }else {
        cell.commentAndPrise.commentBtn.selected = NO;
    }
    [cell.commentAndPrise.commentBtn setTitle:[NSString stringWithFormat:@"%ld",commentNumber] forState:UIControlStateNormal];
//    [cell.commentAndPrise.priseBtn setTitle:[NSString stringWithFormat:@"%ld",clickZanNum] forState:UIControlStateNormal];
}

/**
 *  更换相册封面
 */
-(void)changeBgViewWithTap
{
    _blackView = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    [_blackView addTarget:self action:@selector(cancleChangeBgView) forControlEvents:UIControlEventTouchUpInside];
    _changeAlbumBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(530), getNumWithScanf(74))];
    _changeAlbumBtn.backgroundColor = [UIColor whiteColor];
    _changeAlbumBtn.layer.masksToBounds = YES;
    _changeAlbumBtn.layer.cornerRadius = 5;
    [_changeAlbumBtn setTitle:@"更换相册封面" forState:UIControlStateNormal];
    [_changeAlbumBtn setTitleColor:getColor(@"595959") forState:UIControlStateNormal];
    _changeAlbumBtn.titleLabel.font = DEF_FontSize_13;
    [_changeAlbumBtn addTarget:self action:@selector(changeAlbumBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _changeAlbumBtn.center = _blackView.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    [_blackView addSubview:_changeAlbumBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

/**
 *  取消更换相册封面
 */
-(void)cancleChangeBgView
{
    [UIView animateWithDuration:0.2 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _changeAlbumBtn.hidden = YES;
    } completion:^(BOOL finished) {
        _blackView.hidden = YES;
        [_blackView removeFromSuperview];
    }];
}

/**
 *  选择照片
 */
-(void)changeAlbumBtnDidClick
{
    [self cancleChangeBgView];
    SelectAlbumCoverViewController* svc =[[SelectAlbumCoverViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

/**
 *  发表说说
 */
-(void)takephotoClick
{
    PublishAnnounceShuoShuoViewController* pvc = [[PublishAnnounceShuoShuoViewController alloc]init];
    pvc.headImageUrl = _talktalkModel.headimageurl;
    [self.navigationController pushViewController:pvc animated:YES];
}

/**
 *  我的说说
 */
-(void)MyShuoShuoPageClick
{
    MyShuoShuoViewController* mvc = [[MyShuoShuoViewController alloc]init];
    [self.navigationController pushViewController:mvc animated:YES];
}

/**
 *  进入企业详情
 *
 *  @param cell
 */
-(void)enterPriseDetailWithCell:(UITableViewCell *)cell
{
    
    NSIndexPath* selectIndex = [_mainTableView indexPathForCell:cell];
    SSAllTalkDetailModel* model = _shuoshuoModelArray[selectIndex.section];
//    if ([model.companyid integerValue] == [[UserModel shareInstanced].companyId integerValue] && [model.quid integerValue] == [[UserModel shareInstanced].userID integerValue]) {
//        MyDisplayRoomFinishViewController* mvc = [[MyDisplayRoomFinishViewController alloc]init];
//        [self.navigationController pushViewController:mvc animated:YES];
//    }else{
        EnterPriseInfoViewController* evc = [[EnterPriseInfoViewController alloc]init];
        evc.companyID = model.companyid;
        [self.navigationController pushViewController:evc animated:YES];
//    }
}

/**
 *  点赞
 */
-(void)PriseTheTalkTalkWithCell:(UITableViewCell *)cell WithBtn:(UIButton *)btn
{
    NSIndexPath* indexPath = [self.mainTableView indexPathForCell:cell];
    _allTalkTalkDetailModel = _shuoshuoModelArray[indexPath.section];
    //已经点赞
    if ([_allTalkTalkDetailModel.is_clicklike isEqualToString:@"1"]) {
        //取消点赞
        [self commentAndPriseWithType:@"3" withFlagId:_allTalkTalkDetailModel.shuoshuoId withFriendId:_allTalkTalkDetailModel.quid withBtn:btn];

    }else if([_allTalkTalkDetailModel.is_clicklike isEqualToString:@"0"])
        //没有点赞
    {
        //点赞
        [self commentAndPriseWithType:@"1" withFlagId:_allTalkTalkDetailModel.shuoshuoId withFriendId:_allTalkTalkDetailModel.quid withBtn:btn];
    }
}

/**
 *  评论
 */
-(void)CommentTheTalkTalkWithCell:(UITableViewCell *)cell WithBtn:(UIButton *)btn
{
    
}

/**
 *  删除说说
 *
 *  @param cell 该说说所在的位置
 */
-(void)deleteTalkTalkWithCell:(UITableViewCell *)cell
{
    _deleteIndexPath = [_mainTableView indexPathForCell:cell];
    [self showAlertView];
}

/**
 *  提示框确定按钮点击事件
 */
-(void)alertViewConfirmBtnClick
{
    [self hiddenAlertView];
    SSAllTalkDetailModel* model = _shuoshuoModelArray[_deleteIndexPath.section];
    [self deleteMyShuoShuoWithFlagId:model.shuoshuoId];
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
    _alertView.contentlab.text = @"是否确定删除说说";
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
//base64字符串转成UIImage图片
-(UIImage*)BaseChangeToImage:(NSString*)baseString
{
    NSData* _imageData = [[NSData alloc]initWithBase64EncodedString:baseString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage* _decodeImage = [UIImage imageWithData:_imageData];
    return _decodeImage;
}

#pragma mark - Init

/**
 *  tableView 头视图
 *
 *  @return headView
 */
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(325))];
        _headView.backgroundColor = getColor(@"f7f7f7");
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(313))];
//        if (_talktalkModel.talkurl) {
//            NSLog(@"____%@",_talktalkModel.talkurl);
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:_talktalkModel.talkurl] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
//        }else{
            //如果没有相册封面显示的图片
//            _bgImageView.image = [UIImage imageNamed:@"WechatIMG14"];
//        }
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBgViewWithTap)];
        _bgImageView.userInteractionEnabled = YES;
        [_bgImageView addGestureRecognizer:tap];
        [_headView addSubview:_bgImageView];
        
        _personImageView = [[UIImageView alloc]init];
//        [_personImageView setBackgroundImage:[UIImage imageNamed:@"haoyouqiye"] forState:UIControlStateNormal];
        NSURL* personImageUrl = [[NSURL alloc]init];
        if (_talktalkModel.headimageurl) {
            personImageUrl = [NSURL URLWithString:_talktalkModel.headimageurl];
        }else{
            personImageUrl = nil;
        }
        [_personImageView sd_setImageWithURL:personImageUrl placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];
        _personImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MyShuoShuoPageClick)];
        [_personImageView addGestureRecognizer:singleTap];
        
        [_headView addSubview:_personImageView];
        _personImageView.sd_layout
        .centerXEqualToView(_headView)
        .topSpaceToView(_headView,getNumWithScanf(75))
        .widthIs(getNumWithScanf(130))
        .heightEqualToWidth();
        _personImageView.layer.borderWidth = getNumWithScanf(5);
        _personImageView.layer.borderColor = [UIColor colorWithWhite:9 alpha:0.6].CGColor;
        _personImageView.layer.masksToBounds = YES;
        _personImageView.layer.cornerRadius = _personImageView.frame.size.height/2;
        
        _companyLab = [[UILabel alloc]init];
        _companyLab.shadowColor = [UIColor lightGrayColor];
        _companyLab.shadowOffset = CGSizeMake(0, -1.0);
        _companyLab.text = _talktalkModel.companyname;
        _companyLab.font = DEF_FontSize_12;
        _companyLab.textAlignment = NSTextAlignmentCenter;
        _companyLab.textColor = getColor(@"ffffff");
        [_headView addSubview:_companyLab];
        _companyLab.sd_layout
        .topSpaceToView(_personImageView,getNumWithScanf(15))
        .centerXEqualToView(_headView)
        .heightIs(getNumWithScanf(24))
        .widthIs(SCREEN_WIDTH);
        
        _personNameLab = [[UILabel alloc]init];
        _personNameLab.text = _talktalkModel.linkman;
        _personNameLab.shadowColor = [UIColor lightGrayColor];
        _personNameLab.shadowOffset = CGSizeMake(0, -1.0);
        _personNameLab.font = DEF_FontSize_12;
        _personNameLab.textAlignment = NSTextAlignmentCenter;
        _personNameLab.textColor = getColor(@"ffffff");
        [_headView addSubview:_personNameLab];
        _personNameLab.sd_layout
        .topSpaceToView(_companyLab,getNumWithScanf(5))
        .centerXEqualToView(_headView)
        .heightIs(getNumWithScanf(24))
        .widthIs(SCREEN_WIDTH);
    }
    return _headView;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 114)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.tableHeaderView = self.headView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //下拉刷新
        _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageSize = 10;
            [self getAllTalkTalkDetail];
            [self.mainTableView.header endRefreshing];
        }];
        
        //上啦加载
        _mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreShuoShuoData];
            [self.mainTableView.footer endRefreshing];
        }];
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"ShuoShuoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShuoShuoTableViewCell"];
        
    }
    return _mainTableView;
}

#pragma mark - TableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _shuoshuoModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShuoShuoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShuoShuoTableViewCell"];
    cell.model = _shuoshuoModelArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.backgroundColor = getColor(@"ffffff");
    cell.layer.borderColor = getColor(@"dddddd").CGColor;
    cell.layer.borderWidth = 0.5;
    cell.delegate = self;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(12))];
    
    if (section != _shuoshuoModelArray.count - 1) {
        blankView.backgroundColor = [UIColor clearColor];
    }else{
        blankView.backgroundColor = getColor(@"f7f7f7");
    }
    
    return blankView;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSAllTalkDetailModel *model = _shuoshuoModelArray[indexPath.section];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ShuoShuoTableViewCell class] contentViewWidth:SCREEN_WIDTH];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _shuoshuoModelArray.count - 1) {
        return 0;
    }
    return getNumWithScanf(12);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath;
    SSAllTalkDetailModel* model =[[SSAllTalkDetailModel alloc]init];
    model = _shuoshuoModelArray[indexPath.section];
//    NSLog(@"---modelArr=%@",_shuoshuoModelArray[indexPath.section]);
    NSLog(@"quid====%@====userId===%@",model.quid,[UserModel shareInstanced].userID);
    
    if ([model.quid integerValue] == [[UserModel shareInstanced].userID integerValue]) {
        MyTalkTalkCommentDetailViewController* mvc = [[MyTalkTalkCommentDetailViewController alloc]init];
        mvc.shuoshuoId = model.shuoshuoId;
        mvc.selectIndexPath = indexPath;
        [self.navigationController pushViewController:mvc animated:YES];
    }else{
        CommentDetailViewController* cvc = [[CommentDetailViewController alloc]init];
        cvc.shuoshuoUserId = model.quid;
        cvc.shuoshuoId = model.shuoshuoId;
        [self.navigationController pushViewController:cvc animated:YES];
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
