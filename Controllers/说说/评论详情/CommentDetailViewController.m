//
//  CommentDetailViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "ShuoShuoDetailTableViewCell.h"
#import "CommentDetailTableViewCell.h"
#import "PrisePeopleCollectionViewCell.h"
#import "ReportViewController.h"
#import "EnterPriseInfoViewController.h"
#import "SSTalkTalkCommonDetailModel.h"
#define KToolBarH 44
#define MSGMAXLENGTH 56
#define FACE_NAME_LEN   6

@interface CommentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,FaceDidSelectedDelegate,UITextViewDelegate,IconViewClickDelegate,longTouchTheCommentDelegate,FaceDidSelectedDelegate>

{
    UIButton* _sendBtn;               //发送按钮
    UIButton* _smailBtn;              //表情
    BOOL _isSmailFace;
    UIView* _lineView;
    UIImageView* _priseImageView;
    NSInteger _testArrayCount;
    CGFloat _toolBarHeight;
    CGFloat _toolBarAddHeight;
    CGFloat _moveY;                    //键盘高度
    SSTalkTalkDetailModel* _detailModel;
    NSMutableArray* _dataModelArray;   //留言数组
    NSMutableArray* _clickLikedArray;  //点赞数组
    UIButton* _blackView;              //提示框背景
    NSIndexPath* _deleteIndexPath;     //删除的cell位置
    UIButton* _deleteCommentBtn;       //删除评论
    NSInteger _commentNum;             //我评论的数量
    NSInteger _addAndDeleteNum;        //删除或添加评论之后的总评论数量
    NSInteger _clickZanNum;            //点赞的数量
}
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)UICollectionView* mainCollectionView;
@property(nonatomic,strong)UIView* footerView;            //tableView的底视图
@property(nonatomic,strong)UIView* toolBarView;           //工具栏
@property(nonatomic,strong)FaceKeyBoardView* faceView;    //表情键盘
@property(nonatomic,strong)PlaceHoderTextView* inputTextView;    //输入框

@end

@implementation CommentDetailViewController

/*------------------------------网络------------------------------------*/

/**
*  获取说说评论详情接口
*/
-(void)getShuoShuoCommentDetail
{
    [YSBLL shuoShuoCommentDetailWithFlagId:self.shuoshuoId andResultBlock:^(SSTalkTalkDetailModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _detailModel = model;
            
            _dataModelArray = [[NSMutableArray alloc]init];
            _clickLikedArray = [[NSMutableArray alloc]init];
            NSMutableArray* commentArr = [[NSMutableArray alloc]init];
            [_detailModel.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SSTalkTalkCommonDetailModel* model = [SSTalkTalkCommonDetailModel yy_modelWithJSON:obj];
                if ([model.type isEqualToString:@"2"]) {
                    [_dataModelArray addObject:model];
                    if ([model.uid integerValue] == [[UserModel shareInstanced].userID integerValue]) {
                        [commentArr addObject:model];
                    }
                }else if ([model.type isEqualToString:@"1"]){
                    [_clickLikedArray addObject:model];
                }
            }];
            
            _commentNum = commentArr.count;
            _addAndDeleteNum = _dataModelArray.count;
            _clickZanNum = _clickLikedArray.count ;
            [self sendNotifiacation];
            NSLog(@"---commentNUm--%ld",_commentNum);
            
            NSInteger row = _clickLikedArray.count / 8;
            NSInteger col = _clickLikedArray.count % 8;
            
            if (col == 0) {
                _testArrayCount = row;
            }else{
                _testArrayCount = row + 1;
            }
            
            [self.view addSubview:self.mainTableView];
            [self.mainTableView reloadData];
            [self.view addSubview:self.toolBarView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误1");
        }
    }];
}

/**
 *  评论
 *
 *  @param type     评论评论
 *  @param flagId   说说编号
 *  @param friendId 说说的用户编号
 */
-(void)commentAndPriseWithType:(NSString*)type withFlagId:(NSString*)flagId withFriendId:(NSString*)friendId
{
    [YSBLL shuoshuoCommentAndPriseFlagId:flagId andCreateid:[UserModel shareInstanced].userID andFriendid:friendId andLxtype:type andMemo:_inputTextView.text andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [self getShuoShuoCommentDetail];
            [_inputTextView resignFirstResponder];
            _inputTextView.text = nil;
            self.toolBarView.frame = CGRectMake(0, _moveY+SCREEN_HEIGHT - 64 -KToolBarH, SCREEN_WIDTH, KToolBarH);
            _toolBarHeight = 0;
            _toolBarAddHeight = 0;
            [self isSendTheText];
//            _commentNum++;
//            [self sendNotifiacation];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误1");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限评论说说" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
    }];
}

/**
 * 删除评论
 */
-(void)deleteTheCommentWithFlagId:(NSString*)flagId
{
    [YSBLL shuoshuoCommentDeleteWithFlagId:flagId andUserid:[UserModel shareInstanced].userID andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSLog(@"删除评论成功～～～");
            [self getShuoShuoCommentDetail];
            [self cancleChangeBgView];
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            [MBProgressHUD showError:@"删除评论失败"];
            NSLog(@"请求数据失败 删除评论");
        }else if ([model.ecode isEqualToString:@"-1"]){
            [MBProgressHUD showError:@"删除评论失败"];
            NSLog(@"异常错误  删除评论");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限删除说说" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self cancleChangeBgView];
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"评论详情"];
    
    //监听键盘位置
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updataMsgList)
//                                                 name:@"updataMsgList"
//                                               object:nil];
    
    __weak __block CommentDetailViewController *copy_self = self;
    //获取图片并显示
    [self.faceView setFunctionBlock:^(UIImage *image, NSString *imageText)
     {
         //         NSString *str = [NSString stringWithFormat:@"%@%@",copy_self.inputTextView.text, imageText];
         
         //         copy_self.inputTextView.text = imageText;
         [copy_self.inputTextView insertText:imageText];
         
     }];
    
    [self createNavTitle];
    [self getShuoShuoCommentDetail];
}


-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    editBtn.titleLabel.font = DEF_FontSize_13;
    [editBtn setTitle:@"举报" forState:UIControlStateNormal];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
}

#pragma  mark - function

/**
 *  举报
 */
-(void)reportBtnClick
{
    ReportViewController* rvc = [[ReportViewController alloc]init];
    rvc.BecomplaintedUId = self.shuoshuoUserId;
    rvc.beComplaintedCId = @"";
    rvc.complaintedUId = [UserModel shareInstanced].userID;
    rvc.complaintedCId = @"";
    rvc.infomationSource = @"4";
    rvc.flagId = self.shuoshuoId;
    rvc.context = _detailModel.talkcontext;
    
    NSMutableArray* imagePathsArray = [[NSMutableArray alloc]init];
    if (_detailModel.imageurl1s) {
        [imagePathsArray addObject:_detailModel.imageurl1s];
    }
    if (_detailModel.imageurl2s) {
        [imagePathsArray addObject:_detailModel.imageurl2s];
    }
    if (_detailModel.imageurl3s) {
        [imagePathsArray addObject:_detailModel.imageurl3s];
    }
    if (_detailModel.imageurl4s) {
        [imagePathsArray addObject:_detailModel.imageurl4s];
    }
    if (_detailModel.imageurl5s) {
        [imagePathsArray addObject:_detailModel.imageurl5s];
    }
    if (_detailModel.imageurl6s) {
        [imagePathsArray addObject:_detailModel.imageurl6s];
    }
    if (_detailModel.imageurl7s) {
        [imagePathsArray addObject:_detailModel.imageurl7s];
    }
    if (_detailModel.imageurl8s) {
        [imagePathsArray addObject:_detailModel.imageurl8s];
    }
    if (_detailModel.imageurl9s) {
        [imagePathsArray addObject:_detailModel.imageurl9s];
    }
    NSString* smallString = [NSString string];
    for (int i = 0 ; i < imagePathsArray.count; i++) {
        smallString = [smallString stringByAppendingString:[NSString stringWithFormat:@",%@",imagePathsArray[i]]];
    }
    smallString = [smallString substringWithRange:NSMakeRange(1, smallString.length-1)];
//    NSLog(@"---%@",smallString);
    rvc.contextimage = smallString;
    [self.navigationController pushViewController:rvc animated:YES];
}

/**
 *  发送评论
 */
-(void)commentTheTalkTalk
{
    [self commentAndPriseWithType:@"2" withFlagId:self.shuoshuoId withFriendId:self.shuoshuoUserId];
}

/**
 *  长按某条评论
 */
-(void)longTouchTheCommentWithCell:(UITableViewCell *)cell andGesture:(UILongPressGestureRecognizer *)longTouch
{
    if (longTouch.state == UIGestureRecognizerStateBegan) {
        NSLog(@"点击了长安");
        _deleteIndexPath = [_mainTableView indexPathForCell:cell];
        SSTalkTalkCommonDetailModel* model = _dataModelArray[_deleteIndexPath.row - 1];
        if ([model.clicklikecid integerValue] == [[UserModel shareInstanced].companyId integerValue]) {
            [self changeBgViewWithTap];
        }
    }
}

/**
 *  删除评论
 */
-(void)deleteCommentBtnDidClick
{
    SSTalkTalkCommonDetailModel* model = _dataModelArray[_deleteIndexPath.row - 1];
    [self deleteTheCommentWithFlagId:model.commentId];
}

/**
 *  发送监听  监听评论的数量
 */
-(void)sendNotifiacation
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentNumChanged" object:nil userInfo:@{@"isComment":@(_commentNum),@"commentNum":@(_addAndDeleteNum),@"clickZanNum":@(_clickZanNum),@"clickZanNum":@(_clickZanNum)}];
}

/**
 *  删除评论弹窗
 */
-(void)changeBgViewWithTap
{
    _blackView = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    [_blackView addTarget:self action:@selector(cancleChangeBgView) forControlEvents:UIControlEventTouchUpInside];
    _deleteCommentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(160), getNumWithScanf(70))];
    _deleteCommentBtn.backgroundColor = [UIColor whiteColor];
    _deleteCommentBtn.layer.masksToBounds = YES;
    _deleteCommentBtn.layer.cornerRadius = 5;
    [_deleteCommentBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteCommentBtn setTitleColor:getColor(@"595959") forState:UIControlStateNormal];
    _deleteCommentBtn.titleLabel.font = DEF_FontSize_13;
    [_deleteCommentBtn addTarget:self action:@selector(deleteCommentBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteCommentBtn.center = _blackView.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    [_blackView addSubview:_deleteCommentBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

/**
 *  取消删除
 */
-(void)cancleChangeBgView
{
    [UIView animateWithDuration:0.2 animations:^{
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _deleteCommentBtn.hidden = YES;
    } completion:^(BOOL finished) {
        _blackView.hidden = YES;
        [_blackView removeFromSuperview];
    }];
}

/**
 *  点击表情(弹出表情键盘)
 */
-(void)faceBoardClick
{
    NSString* imageName = [NSString string];
    if (_isSmailFace) {
        imageName = @"smailFace";
    }else{
        imageName = @"keyBoard";
    }
    _isSmailFace = !_isSmailFace;
    [_smailBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    if ([imageName isEqualToString:@"keyBoard"]) {
        _inputTextView.inputView = self.faceView;
        [_inputTextView reloadInputViews];
    }
    else{
        _inputTextView.inputView = nil;
        [_inputTextView reloadInputViews];
    }
    if (![_inputTextView isFirstResponder])
    {
        [_inputTextView becomeFirstResponder];
    }
}

/**
 *  键盘发生改变时调用
 */
-(void)keyBoardWillChange:(NSNotification*)noti
{
    NSDictionary* userInfo = noti.userInfo;
    //获取键盘弹出延迟时间
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //获取键盘的frame
    CGRect keyframe = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    _moveY = keyframe.origin.y - SCREEN_HEIGHT;
    [UIView animateWithDuration:duration animations:^{
        self.toolBarView.transform = CGAffineTransformMakeTranslation(0, _moveY);
    }];
}

/**
 *  选中表情
 */
-(void)faceDidSelected:(UIButton *)btn
{
    NSString *s = @"This is a smiley \ue415 face";
    NSLog(@"face---%@",s);
    [_inputTextView insertText:btn.titleLabel.text];
    [self isSendTheText];
}

/**
 *  发送表情
 */
-(void)sendFace:(UIButton *)btn
{
    
}

/**
 *  删除表情
 */
-(void)deletFace:(UIButton *)btn
{
    [_inputTextView deleteBackward];
}

/**
 *  点击头像
 *
 *  @param cell 头像的位置cell
 */
-(void)iconViewDidClick:(UITableViewCell *)cell
{
    EnterPriseInfoViewController* evc = [[EnterPriseInfoViewController alloc]init];
    evc.companyID = _detailModel.companyId;
    [self.navigationController pushViewController:evc animated:YES];
}

/**
 *  是否发送文本
 */
-(void)isSendTheText
{
    if (_inputTextView.text.length > 0) {
        _sendBtn.enabled = YES;
        _sendBtn.backgroundColor = getColor(@"3fbefc");
    }else if (_inputTextView.text.length == 0){
        _sendBtn.backgroundColor = getColor(@"abe5fe");
        _sendBtn.enabled = NO;
    }
}


#pragma mark - Init

/**
 *  工具栏
 *
 *  @return self
 */
-(UIView *)toolBarView
{
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - KToolBarH - 64, SCREEN_WIDTH, KToolBarH)];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        
        //输入框
        _inputTextView = [[PlaceHoderTextView alloc]init];
        _inputTextView.placeHoder = @"评论";
        _inputTextView.placeHoderColor = getColor(@"999999");
        _inputTextView.font = DEF_FontSize_12;
        _inputTextView.delegate = self;
        [_toolBarView addSubview:_inputTextView];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = getColor(@"3fbefc");
        [_toolBarView addSubview:_lineView];
        
        _inputTextView.sd_layout
        .topSpaceToView(_toolBarView,5)
        .leftSpaceToView(_toolBarView,10)
        .rightSpaceToView(_toolBarView,KToolBarH*2+20)
        .bottomSpaceToView(_toolBarView,5);
        
        _lineView.sd_layout
        .leftEqualToView(_inputTextView)
        .rightEqualToView(_inputTextView)
        .topSpaceToView(_inputTextView,0)
        .heightIs(1);
        
        //表情按钮
        _smailBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - KToolBarH*2, 0, KToolBarH, KToolBarH)];
        [_smailBtn setImage:[UIImage imageNamed:@"smailFace"] forState:UIControlStateNormal];
        [_smailBtn addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:_smailBtn];
        _smailBtn.sd_layout
        .leftSpaceToView(_inputTextView,-5)
        .bottomSpaceToView(_toolBarView,0)
        .widthIs(KToolBarH)
        .heightIs(KToolBarH);
        
        //发送按钮
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        _sendBtn.backgroundColor = getColor(@"abe5fe");
        _sendBtn.titleLabel.font = DEF_FontSize_12;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.enabled = NO;
        [_sendBtn addTarget:self action:@selector(commentTheTalkTalk) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:_sendBtn];
        _sendBtn.sd_layout
        .leftSpaceToView(_smailBtn,0)
        .widthIs(KToolBarH + 10)
        .bottomSpaceToView(_toolBarView,5)
        .heightIs(34);
    }
    return _toolBarView;
}

/***
 *  表情键盘
 ***/
-(FaceKeyBoardView *)faceView
{
    if (!_faceView) {
        _faceView = [[FaceKeyBoardView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, getNumWithScanf(285))];
        _faceView.backgroundColor = getColor(@"fafafa");
        _faceView.delegate = self;
        _faceView.userInteractionEnabled = YES;
    }
    return _faceView;
}

/**
 *  点赞人列表
 *
 *  @return  self
 */
-(UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat insert = (SCREEN_WIDTH - getNumWithScanf(54) - 20 - getNumWithScanf(52)*8)/8;
        layout.itemSize = CGSizeMake(getNumWithScanf(52), getNumWithScanf(52));
        layout.minimumInteritemSpacing = insert;
        layout.minimumLineSpacing = insert;
        layout.sectionInset = UIEdgeInsetsMake(insert, 0, 0, insert);
        
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(getNumWithScanf(30)+20, 0, SCREEN_WIDTH - getNumWithScanf(54) - 20 , getNumWithScanf(80)*_testArrayCount) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = getColor(@"ffffff");
        
        //注册collectionViewCell
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"PrisePeopleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PrisePeopleCollectionViewCell"];
        
    }
    return _mainCollectionView;
}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(80)*_testArrayCount)];
    
        UIView* blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(30)+21, getNumWithScanf(80)*_testArrayCount)];
        blankView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:blankView];
        
        _priseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, getNumWithScanf(30), getNumWithScanf(30), getNumWithScanf(30))];
        _priseImageView.image = [UIImage imageNamed:@"zanSelected"];
        [blankView addSubview:_priseImageView];
        
        [_footerView addSubview:self.mainCollectionView];
        
        if (_clickLikedArray.count == 0) {
            _footerView.hidden = YES;
        }
    }
    return _footerView;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), SCREEN_HEIGHT - 64 - KToolBarH - getNumWithScanf(12))];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.tableFooterView = self.footerView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"ShuoShuoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShuoShuoDetailTableViewCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"CommentDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentDetailTableViewCell"];
    }
    return _mainTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataModelArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ShuoShuoDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShuoShuoDetailTableViewCell"];
        cell.model = _detailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else{
        CommentDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailTableViewCell"];
        cell.commentModel = _dataModelArray[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.personImage.layer.masksToBounds = YES;
        cell.commentImageView.hidden = YES;
        cell.delegate = self;
        if (indexPath.row == 1) {
            cell.commentImageView.hidden = NO;
        }
        return cell;
    }
    return nil;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [tableView cellHeightForIndexPath:indexPath model:_detailModel keyPath:@"model" cellClass:[ShuoShuoDetailTableViewCell class] contentViewWidth:SCREEN_WIDTH - getNumWithScanf(24)];
    }
    return [tableView cellHeightForIndexPath:indexPath model:_dataModelArray[indexPath.row-1] keyPath:@"commentModel" cellClass:[CommentDetailTableViewCell class] contentViewWidth:SCREEN_WIDTH - getNumWithScanf(24)];
}

#pragma mark - ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainTableView) {
       [_inputTextView resignFirstResponder];
    }
}

#pragma mark - collectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _clickLikedArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PrisePeopleCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PrisePeopleCollectionViewCell" forIndexPath:indexPath];
    SSTalkTalkCommonDetailModel* model = _clickLikedArray[indexPath.item];
    [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.headimageurl] placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];
//    cell.personImage.layer.masksToBounds = YES;
//    cell.personImage.layer.cornerRadius = (cell.personImage.frame.size.width/2);
    return cell;
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat inputViewContentSize = _inputTextView.contentSize.height;
    if (_toolBarHeight && _toolBarHeight < inputViewContentSize) {
        _toolBarAddHeight = _toolBarAddHeight + 15;
        self.toolBarView.frame = CGRectMake(0, _moveY+SCREEN_HEIGHT - 64 - MIN(_toolBarAddHeight, 15*4)-KToolBarH, SCREEN_WIDTH, MIN(_toolBarAddHeight, 15*4)+KToolBarH);
    }else if(_toolBarHeight && _toolBarHeight > inputViewContentSize)
    {
        _toolBarAddHeight = _toolBarAddHeight - 15;
        if (_toolBarHeight > 0) {
            self.toolBarView.frame = CGRectMake(0, _moveY+SCREEN_HEIGHT - 64 - MIN(_toolBarAddHeight, 15*4)-KToolBarH, SCREEN_WIDTH, MIN(_toolBarAddHeight, 15*4)+KToolBarH);
        }
        
    }
    _toolBarHeight = inputViewContentSize;
    
    [self isSendTheText];
}

//查看聊天消息中是否有表情
- (NSArray *)imageData:(NSString *)text{
    
    //    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSString *str = @"\\[[^\\[\\]]*\\]";
    NSError *error = nil;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:str
                                                                             options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *resultArr = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    return resultArr;
    
}

- (NSMutableAttributedString *)findImage:(NSString *)text{
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"[笑]", @"[冷漠]", @"[皱眉]", @"[沮丧]",
                      @"[惊讶]", @"[哭笑]", @"[汗]", @"[亲]", @"[心]", @"[碎]", @"[蜡烛]", @"[花]", nil];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Image" ofType:@"plist"];
    NSArray *headers = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *textArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (NSDictionary *dict in headers) {
        [nameArr addObject:[dict objectForKey:@"ImageName"]];
        [textArr addObject:[dict objectForKey:@"ImageText"]];
    }
    
    NSArray *resultArr = [self imageData:text];
    
    for (NSInteger i = 0; i  < [resultArr count]; ++i) {
        NSTextCheckingResult *result = resultArr[i];
        NSRange range =  [result range];
        NSString *subStr = [text substringWithRange:range];
        
        for (int j = 0; j < [array count]; j ++) {
            if ([subStr isEqualToString:[array objectAtIndex:j]]) {
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [imageDic setObject:[nameArr objectAtIndex:j] forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [imageArray addObject:imageDic];
            }
        }
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:text];
    for (NSInteger i = [imageArray count]-1; i>=0; i--) {
        NSDictionary *dic = imageArray[i];
        NSRange range = [dic[@"range"] rangeValue];
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, 15, 15);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributeString replaceCharactersInRange:range withAttributedString:string];
    }
    
    return attributeString;
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
