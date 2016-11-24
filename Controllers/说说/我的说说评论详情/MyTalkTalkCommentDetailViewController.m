//
//  MyTalkTalkCommentDetailViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/9.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MyTalkTalkCommentDetailViewController.h"
#import "MyTalkTalkCommentDetailTableViewCell.h"
#import "CommentDetailTableViewCell.h"
#import "PrisePeopleCollectionViewCell.h"
#define KToolBarH 44

@interface MyTalkTalkCommentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AlertViewDelegate,DeleteCommentDelegate,FaceDidSelectedDelegate,UITextViewDelegate,longTouchTheCommentDelegate,FaceDidSelectedDelegate>

{
    
    UIButton* _sendBtn;               //发送按钮
    UIButton* _smailBtn;              //表情
    BOOL _isSmailFace;
    UIView* _lineView;
    CGFloat _toolBarHeight;
    CGFloat _toolBarAddHeight;
    CGFloat _moveY;                    //键盘高度
    AlertView* _alertView;            //提示框
    UIButton* _blackView;             //提示框背景
    SSTalkTalkDetailModel* _detailModel;
    NSArray* _titleArray;
    UIImageView* _priseImageView;
    NSInteger _testArrayCount;
    NSMutableArray* _dataModelArray;   //留言数组
    NSMutableArray* _clickLikedArray;  //点赞数组
    NSIndexPath* _deleteIndexPath;    //删除的cell位置
    UIButton* _deleteCommentBtn;         //删除评论
    NSInteger _commentNum;             //我评论的数量
    NSInteger _addAndDeleteNum;        //删除或添加评论之后的总评论数量
    NSInteger _clickZanNum;            //点赞的数量
}

@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)UICollectionView* mainCollectionView;
@property(nonatomic,strong)UIView* footerView;            //tableView的底视图
@property(nonatomic,strong)UIView* toolBarView;           //工具栏
@property(nonatomic,strong)FaceKeyBoardView* faceView;    //表情键盘
@property(nonatomic,strong)PlaceHoderTextView* inputTextView;       //输入框

@end

@implementation MyTalkTalkCommentDetailViewController

/*------------------------------网络------------------------------------*/
/**
*  说说评论详情
*/
-(void)getShuoShuoCommentDetail
{
    NSLog(@"---%@---%@",self.shuoshuoId,[UserModel shareInstanced].postName);
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
 *  删除我的说说
 *
 *  @param flagId 说说Id
 */
-(void)deleteMyShuoShuoWithFlagId:(NSString*)flagId
{
    [YSBLL DeleteMyShuoShuoDetailWithFlagId:flagId andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteTheShuoShuo" object:nil userInfo:@{@"selectIndexPath":_selectIndexPath}];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
            [MBProgressHUD showError:@"删除说说失败"];
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            [MBProgressHUD showError:@"删除说说失败"];
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
        }else if ([model.ecode isEqualToString:@"-2"]){
            [MBProgressHUD showError:@"评论失败"];
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            [MBProgressHUD showError:@"评论失败"];
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
            [self getShuoShuoCommentDetail];
            [self cancleChangeBgView];
            NSLog(@"删除评论成功～～～");
        }else if ([model.ecode isEqualToString:@"-2"]){
            [MBProgressHUD showError:@"删除评论失败"];
            NSLog(@"请求数据失败 删除评论");
        }else if ([model.ecode isEqualToString:@"-1"]){
            [MBProgressHUD showError:@"删除评论失败"];
            NSLog(@"异常错误  删除评论");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限删除评论" preferredStyle:UIAlertControllerStyleAlert];
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
    
    __weak __block MyTalkTalkCommentDetailViewController *copy_self = self;
    //获取图片并显示
    [self.faceView setFunctionBlock:^(UIImage *image, NSString *imageText)
     {
         //         NSString *str = [NSString stringWithFormat:@"%@%@",copy_self.inputTextView.text, imageText];
         
         //         copy_self.inputTextView.text = imageText;
         [copy_self.inputTextView insertText:imageText];
     }];
    
    [self getShuoShuoCommentDetail];
}


#pragma mark - function

/**
 *  发送监听  监听评论的数量
 */
-(void)sendNotifiacation
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentNumChanged" object:nil userInfo:@{@"isComment":@(_commentNum),@"commentNum":@(_addAndDeleteNum),@"clickZanNum":@(_clickZanNum)}];
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
 *  发送评论
 */
-(void)commentTheTalkTalk
{
    [self commentAndPriseWithType:@"2" withFlagId:self.shuoshuoId withFriendId:[UserModel shareInstanced].userID];
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
 *  选中表情
 */
-(void)faceDidSelected:(UIButton *)btn
{
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
 *  删除评论
 */
-(void)commentDidDelete
{
    [self showAlertView];
}

/**
 *  提示框确定按钮点击事件
 */
-(void)alertViewConfirmBtnClick
{
    [self deleteMyShuoShuoWithFlagId:self.shuoshuoId];
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
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), SCREEN_HEIGHT - 64 - 44 - getNumWithScanf(12))];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.tableFooterView = self.footerView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"MyTalkTalkCommentDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTalkTalkCommentDetailTableViewCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"CommentDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentDetailTableViewCell"];
    }
    return _mainTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataModelArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MyTalkTalkCommentDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyTalkTalkCommentDetailTableViewCell"];
        cell.model = _detailModel;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CommentDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailTableViewCell"];
        cell.commentModel = _dataModelArray[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.personImage.layer.masksToBounds = YES;
        cell.delegate = self;
        cell.personImage.layer.cornerRadius = (cell.personImage.frame.size.width/2);
        cell.commentImageView.hidden = YES;
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
        return [tableView cellHeightForIndexPath:indexPath model:_detailModel keyPath:@"model" cellClass:[MyTalkTalkCommentDetailTableViewCell class] contentViewWidth:SCREEN_WIDTH - getNumWithScanf(24)];
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
    return cell;
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat inputViewContentSize = _inputTextView.contentSize.height;
    if (_toolBarHeight && _toolBarHeight < inputViewContentSize && _toolBarHeight != 0) {
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
