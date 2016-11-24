//
//  ChatMessageViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ChatMessageViewController.h"
#import "MessageModel.h"
#import "CellFrameModel.h"
#import "ChatMessageTableViewCell.h"
#import "ChatSetViewController.h"
#import "MessageMainModel.h"
#import "TouchDownGestureRecognizer.h"
#import "RecordingView.h"

#define KToolBarH 44

#define MSGMAXLENGTH 56
#define FACE_NAME_LEN   6

static NSString* const KChatMessageCell = @"ChatMessageTableViewCell";

@interface ChatMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,FaceDidSelectedDelegate,TZImagePickerControllerDelegate>
{
    NSMutableArray* _cellFrameDatas;
    MyLabel* _companyNameLab;
    MyLabel * _SupplyAndDemandLab;
    UILabel* _contactPeopleLab;
    UILabel* _contactTelLab;
    UILabel* _secondLab;         //供应（不变）
    UILabel* _thirdLab;          //联系人（不变）
    UILabel* _fourthLab;         //联系电话（不变）
//    UITextView* _inputTextView;  //输入框
    UIButton* _voiceBtn;         //语音
    UIButton* _smailBtn;         //表情
    UIButton* _addMoreBtn;       //更多
    UIButton* _speakBtn;         //按住说话按钮
    UIButton* _sendBtn;          //发送按钮
    NSString* _faceImageName;    //表情按钮图片string
    UIView* _lineView;
    BOOL _isSmailFace;
    BOOL _isVoiceBtn;
    CGFloat _toolBarHeight;
    CGFloat _toolBarAddHeight;
    CGFloat _testHeight;
    CGFloat _companyNameHeight;
    CGFloat _moveY;
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    NSString* isJoinBlackList;        //是否将别人加入黑名单
    NSString* isJoinedBlackList;      //是否被别人加入黑名单
    UIImage* _photo;
    GQSupplyAndDemandDetailsModel* _detailModel;
}
@property(nonatomic,strong)UITableView* mainTableview;
@property(nonatomic,strong)UIView* headView;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIView* toolBarView;    //工具栏
@property(nonatomic,strong)FaceKeyBoardView* faceView;    //表情键盘

@property(nonatomic,strong)UITextView* inputTextView;  //输入框

@end

@implementation ChatMessageViewController

/*------------------------------网络------------------------------------*/

/**
*  移出黑名单 （0:为不加入黑名单，1加入黑名单）
*/
-(void)removeFormBlcakListWithType:(NSString*)type
{
    [YSBLL addToBlackListWithRecipientuid:[UserModel shareInstanced].userID andBrecipientuid:self.qcId andFlagType:@"0" andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            
            if ([type isEqual:@"1"]) {
                //发文字
                [self sendmessage];
            }else if ([type isEqual:@"2"]){
                //发图片
                [self sendPictureWithImage:_photo];
            }
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
*  查询黑名单
*/
-(void)selectBlackList
{
    //别人是否将我拉入黑名单
    [YSBLL selectTheBlackListWithRecipientuid:self.qcId andBrecipientuid:[UserModel shareInstanced].userID andResultBlock:^(id responseObj, NSError *error) {
        NSString* isSuccess = responseObj[@"ecode"];
//        NSLog(@"ecode---%@",isSuccess);
        if ([isSuccess isEqualToString:@"0"]) {
            NSString* isBlackList = [responseObj[@"data"][@"isblacklist"] stringValue];
           isJoinedBlackList = isBlackList;
            
            //  我是否将别人拉入黑名单
            [YSBLL selectTheBlackListWithRecipientuid:[UserModel shareInstanced].userID andBrecipientuid:self.qcId andResultBlock:^(id responseObj, NSError *error) {
                NSString* isSuccess = responseObj[@"ecode"];
                if ([isSuccess isEqualToString:@"0"]) {
                    NSString* isBlackList = [responseObj[@"data"][@"isblacklist"] stringValue];
                    isJoinBlackList = isBlackList;
                    
//                    if ([isJoinedBlackList isEqual:@"0"]) {
//                    //没有被加入黑名单
//                        if ([isJoinBlackList isEqual:@"1"]) {
//                            //已将他加入黑名单,则移除
//                            [self removeFormBlcakListWithType:type];
//                        }else if ([isJoinBlackList isEqual:@"0"]){
//                            //未将他加入黑名单
//                            if ([type isEqual:@"1"]) {
//                                //发文字
//                                [self sendmessage];
//                            }else if ([type isEqual:@"2"]){
//                                //发图片
//                                [self sendPictureWithImage:_photo];
//                            }
//                        }
//                        
//                    }else if ([isJoinedBlackList isEqual:@"1"]){
//                    //已经被加入黑名单
//                        [MBProgressHUD showSuccess:@"你已经被加入黑名单"];
//                    }
                    
                }else if ([isSuccess isEqualToString:@"-2"]){
                    NSLog(@"请求数据失败");
                }else if ([isSuccess isEqualToString:@"-1"]){
                    NSLog(@"异常错误");
                }
            }];
            
        }else if ([isSuccess isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([isSuccess isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  供求详情
 */
-(void)loadSupplyAndDemandDetailInfo
{
    [self showprogressHUD];
    [YSBLL SupplyAndDemandDetailWithFlagId:self.sellbuyid andCompanyId:[UserModel shareInstanced].companyId andResultBlock:^(GQSupplyAndDemandDetailsModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _detailModel = model;
            
            _companyNameLab.text = model.companyname;
            _secondLab.text = [NSString stringWithFormat:@"%@:",_detailModel.typeName];
            NSString* mainBussinessStr = _detailModel.content;
            mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            _SupplyAndDemandLab.text = mainBussinessStr;
            _contactPeopleLab.text = _detailModel.linkman;
            if ([_detailModel.telphone isEqualToString:@"-1"]) {
                _contactTelLab.text = @"保密";
            }else{
                _contactTelLab.text = _detailModel.telphone;
            }
            
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/*-----------------------------页面-------------------------------------*/

#pragma mark - 加载数据

-(void)loadData
{
    _cellFrameDatas = [[NSMutableArray alloc]init];
    
    NSMutableArray *array = [[YSDatabase shareYSDatabase]queryMessgeData:self.qcId];
    
    for (int i = 0; i< [array count]; i ++) {
        MessageModel* message = [array objectAtIndex:i];

        CellFrameModel* lastFrame = [_cellFrameDatas lastObject];
        CellFrameModel* cellFrame = [[CellFrameModel alloc]init];
        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
        cellFrame.message = message;
        [_cellFrameDatas addObject:cellFrame];
    }
    
    NSLog(@"hahaha%ld",_cellFrameDatas.count);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self selectBlackList];
}

- (void)viewDidLoad {
    
    NSLog(@"--联系人--%@",self.linkMan);
    
    [super viewDidLoad];
    [self loadData];
    
    [self NavTitle:@"在线沟通"];
    //获取document目录
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* document = [paths lastObject];
    NSLog(@"%@",document);
//    NSString* plistFilePath = [document stringByAppendingPathComponent:@"images.plist"];
//    [imageFiles writeToFile:plistFilePath atomically:YES];
    
    _testHeight = [self kdetailTextHeight:_supplyAndDemandString width:(SCREEN_WIDTH - getNumWithScanf(199))];
    _companyNameHeight = [self kdetailTextHeight:_companyName width:(SCREEN_WIDTH - getNumWithScanf(40))];
    
    //监听键盘位置
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.view addSubview:self.toolBarView];
    [self.view addSubview:self.mainTableview];
    //自动滚动到最后一行
    if([_cellFrameDatas count] > 0){
        NSIndexPath* lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
        [_mainTableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
    [self createNavTitle];
    
    
    [self loadSupplyAndDemandDetailInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataMsgList)
                                                 name:@"updataMsgList"
                                               object:nil];
     
    __weak __block ChatMessageViewController *copy_self = self;
    //获取图片并显示
    [self.faceView setFunctionBlock:^(UIImage *image, NSString *imageText)
     {
//         NSString *str = [NSString stringWithFormat:@"%@%@",copy_self.inputTextView.text, imageText];
         
//         copy_self.inputTextView.text = imageText;
         [copy_self.inputTextView insertText:imageText];

     }];
    
    self.voiceArray = [[NSMutableArray alloc] init];  
    
}

- (void)updataMsgList{
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
        [_mainTableview reloadData];
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
        [_mainTableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });

}

/**
 *  设置导航栏
 */
-(void)createNavTitle
{
    UIButton* editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(60), getNumWithScanf(26))];
    editBtn.titleLabel.font = DEF_FontSize_13;
    [editBtn setTitle:@"设置" forState:UIControlStateNormal];
    [editBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(chatSetClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10.0f;
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
}

#pragma mark - function

/**
 *  设置
 */
-(void)chatSetClick
{
    ChatSetViewController* svc = [[ChatSetViewController alloc]init];
    svc.userId = self.qcId;
    [self.navigationController pushViewController:svc animated:YES];
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
        self.view.transform = CGAffineTransformMakeTranslation(0, _moveY);
    }];
}

/**
 *  点击语音按钮
 */
-(void)sendVoiceBtnClick
{
//    NSString* imageName = [NSString string];
//    if (!_isVoiceBtn) {
//        imageName = @"keyBoard";
//        _inputTextView.hidden = YES;
//        _smailBtn.hidden = YES;
//        _speakBtn.hidden = NO;
//        _lineView.hidden = YES;
//        [self.view endEditing:YES];
//    }else{
//        imageName = @"voice";
//        _inputTextView.hidden = NO;
//        _smailBtn.hidden = NO;
//        _speakBtn.hidden = YES;
//        _lineView.hidden = NO;
//        
//        if (_inputTextView.inputView == self.faceView) {
//            _isSmailFace = !_isSmailFace;
//        }
//        _inputTextView.inputView = nil;
//        [_inputTextView reloadInputViews];
//        if (![_inputTextView isFirstResponder]) {
//            [_inputTextView becomeFirstResponder];
//        }
//    }
//    [_voiceBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [_smailBtn setImage:[UIImage imageNamed:@"smailFace"] forState:UIControlStateNormal];
//    _isVoiceBtn = ! _isVoiceBtn;
}

//弹出框相关（语音）
- (void)p_record:(UIButton*)button
{
    [_speakBtn setHighlighted:YES];
    if (![[self.view subviews] containsObject:_recordingView])
    {
        [self.view addSubview:_recordingView];
    }
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
    [_speakBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
    //    [[RecorderManager sharedManager] setDelegate:self];
    //    [[RecorderManager sharedManager] startRecording];
    NSLog(@"record");
    
    
    if(self.isPlaying){
        return;
    }
    
    if(!self.isSpeak){
        self.isSpeak = YES;
//        [RecorderManager sharedManager].delegate = self;
//        [[RecorderManager sharedManager] startRecording];
    }
}

- (void)p_endCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
    [_speakBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)p_willCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowCancelSendState];
    [_speakBtn setTitle:@"松开手指 取消发送" forState:UIControlStateNormal];
    NSLog(@"will cancel record");
}

- (void)p_sendRecord:(UIButton*)button
{
    [_speakBtn setHighlighted:NO];
    [_recordingView setHidden:YES];
    //    [[RecorderManager sharedManager] stopRecording];
    [_speakBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    NSLog(@"send record");
}

- (void)p_cancelRecord:(UIButton*)button
{
    [_speakBtn setHighlighted:NO];
    [_recordingView setHidden:YES];
    //    [[RecorderManager sharedManager] cancelRecording];
    [_speakBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    NSLog(@"cancel record");
}

/**
 *  点击表情(弹出表情键盘)
 */
-(void)faceBoardClick
{
    if (_isSmailFace) {
        _faceImageName = @"smailFace";
    }else{
        _faceImageName = @"keyBoard";
    }
    _isSmailFace = !_isSmailFace;
    [_smailBtn setImage:[UIImage imageNamed:_faceImageName] forState:UIControlStateNormal];
    
    if ([_faceImageName isEqualToString:@"keyBoard"]) {
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
    
//    [self changeKeyboardToFaceView];
}

/**
 *  点击更多功能
 */
-(void)moreFunctionClick
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //是否可以选择原图
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    //    imagePickerVc.selectedAssets = _selectedAssert; // optional, 可选的
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = getColor(@"3fbefc");
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = getColor(@"3fbefc");
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.photoWidth = 414;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *  切换键盘
 */
-(void) changeKeyboardToFaceView
{
    if ([_inputTextView.inputView isEqual:self.faceView])
    {
        _inputTextView.inputView = nil;
        [_inputTextView reloadInputViews];
    }
    else
    {
        _inputTextView.inputView = self.faceView;
        [_inputTextView reloadInputViews];
    }
    
    if (![_inputTextView isFirstResponder])
    {
        [_inputTextView becomeFirstResponder];
    }
}

/**
 *  选中表情
 */
-(void)faceDidSelected:(UIButton *)btn
{
    
    
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
        _inputTextView = [[UITextView alloc]init];
        _inputTextView.font = DEF_FontSize_12;
        _inputTextView.delegate = self;
        [_toolBarView addSubview:_inputTextView];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = getColor(@"3fbefc");
        [_toolBarView addSubview:_lineView];
        
        _inputTextView.sd_layout
        .topSpaceToView(_toolBarView,5)
        .leftSpaceToView(_toolBarView,KToolBarH)
        .rightSpaceToView(_toolBarView,KToolBarH*2)
        .bottomSpaceToView(_toolBarView,5);
        
        _lineView.sd_layout
        .leftEqualToView(_inputTextView)
        .rightEqualToView(_inputTextView)
        .topSpaceToView(_inputTextView,0)
        .heightIs(1);
        
        //语音按钮
        _voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KToolBarH, KToolBarH)];
        [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(sendVoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:_voiceBtn];
        _voiceBtn.sd_layout
        .leftSpaceToView(_toolBarView,0)
        .bottomSpaceToView(_toolBarView,0)
        .widthIs(KToolBarH)
        .heightIs(KToolBarH);
        
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
        
        //更多按钮
        _addMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - KToolBarH, 0, KToolBarH, KToolBarH)];
        [_addMoreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_addMoreBtn addTarget:self action:@selector(moreFunctionClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:_addMoreBtn];
        _addMoreBtn.sd_layout
        .rightSpaceToView(_toolBarView,3)
        .bottomSpaceToView(_toolBarView,0)
        .widthIs(KToolBarH)
        .heightIs(KToolBarH);
        
        //按住说话按钮
        _speakBtn = [[UIButton alloc]initWithFrame:CGRectMake(KToolBarH+KToolBarH/2, 7, SCREEN_WIDTH - KToolBarH*3, 30)];
        [_speakBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        _speakBtn.backgroundColor = getColor(@"ffffff");
        [_speakBtn setTitleColor:getColor(@"999999") forState:UIControlStateNormal];
        _speakBtn.layer.masksToBounds = YES;
        _speakBtn.layer.cornerRadius = 3;
        _speakBtn.layer.borderWidth = 0.8;
        _speakBtn.titleLabel.font = DEF_FontSize_11;
        _speakBtn.layer.borderColor = getColor(@"dddddd").CGColor;
        [_toolBarView addSubview:_speakBtn];
        _speakBtn.hidden = YES;
        //给按住说话按钮添加手势
        _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
        __weak ChatMessageViewController* weakSelf = self;
        _touchDownGestureRecognizer.touchDown = ^{
            [weakSelf p_record:nil];
        };
        
        _touchDownGestureRecognizer.moveInside = ^{
            [weakSelf p_endCancelRecord:nil];
        };
        
        _touchDownGestureRecognizer.moveOutside = ^{
            [weakSelf p_willCancelRecord:nil];
        };
        
        _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
            if (inside)
            {
                [weakSelf p_sendRecord:nil];
            }
            else
            {
                [weakSelf p_cancelRecord:nil];
            }
        };
        [_speakBtn addGestureRecognizer:_touchDownGestureRecognizer];
        _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
        [_recordingView setHidden:YES];
        [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y - 64)];
        _speakBtn.sd_layout
        .bottomSpaceToView(_toolBarView,5)
        .leftSpaceToView(_toolBarView,KToolBarH)
        .rightSpaceToView(_toolBarView,KToolBarH)
        .heightIs(34);
        
        //发送按钮
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendMessageBtn) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.backgroundColor = getColor(@"3fbefc");
        _sendBtn.titleLabel.font = DEF_FontSize_12;
        _sendBtn.hidden = YES;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 5;
        [_toolBarView addSubview:_sendBtn];
        _sendBtn.sd_layout
        .leftSpaceToView(_smailBtn,0)
        .widthIs(KToolBarH)
        .bottomSpaceToView(_toolBarView,5)
        .heightIs(34);
        
    }
    return _toolBarView;
}

//发消息
- (void)sendMessageBtn{

//    [self selectBlackListWithType:@"1"];
    if ([isJoinedBlackList isEqual:@"0"]) {
        //没有被加入黑名单
        if ([isJoinBlackList isEqual:@"1"]) {
            //已将他加入黑名单,则移除
            [self removeFormBlcakListWithType:@"1"];
        }else if ([isJoinBlackList isEqual:@"0"]){
            //未将他加入黑名单
            [self sendmessage];
        }
    }else if ([isJoinedBlackList isEqual:@"1"]){
        //已经被加入黑名单
        [MBProgressHUD showSuccess:@"你已经被加入黑名单"];
    }
}

-(void)sendmessage{
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000; //时间戳
    NSInteger time = [[[NSString stringWithFormat:@"%f",interval] substringToIndex:10] intValue];
    NSString *msgTime = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld000",time]];
    
    MessageModel* message = [[MessageModel alloc]init];
    message.text = _inputTextView.text;
    message.time = msgTime;
    message.type = 0;
    message.messageType = @"0";
    [self updataModel:message];
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    //保存聊天信息
    [[YSDatabase shareYSDatabase]saveMessage:@"9020" msgId:uuid mfromId:[UserModel shareInstanced].userID time:time mtoId:self.qcId msgContentStr:_inputTextView.text msgStatusStr:@"0" type:@"0"];
    
    //保存好友
    if (![[YSDatabase shareYSDatabase] isSaveFriendId:self.qcId]) {
        [[YSDatabase shareYSDatabase]saveFriendList:self.qcId fName:self.companyName contactname:[UserModel shareInstanced].name portal:[UserModel shareInstanced].icon tel:self.telPhone info:[NSString stringWithFormat:@"%@:%@",self.GQName,self.supplyAndDemandString] linkman:self.linkMan headimageurl:self.headImageUrl sellbuyid:self.sellbuyid msgStatus:@"0"];
    }else{
        [[YSDatabase shareYSDatabase]motifityTheFriendList:self.sellbuyid info:[NSString stringWithFormat:@"%@:%@",self.GQName,self.supplyAndDemandString] linkman:self.linkMan friendId:self.qcId companyname:self.companyName andGQName:nil];
    }
    
    //发消息
    [[YSSocketProtocol shareSocketProtocol]sendData:@"9020" msgId:uuid msgContent:_inputTextView.text mtoId:self.qcId name:[UserModel shareInstanced].name portal:[UserModel shareInstanced].icon tel:self.telPhone company:self.companyName info:[NSString stringWithFormat:@"%@:%@",self.GQName,self.supplyAndDemandString] linkMan:self.linkMan withType:0 sellbuyid:self.sellbuyid];
    
    [_inputTextView resignFirstResponder];
    _inputTextView.text = nil;
    self.toolBarView.frame = CGRectMake(0, _moveY+SCREEN_HEIGHT - 64 -KToolBarH, SCREEN_WIDTH, KToolBarH);
    _toolBarHeight = 0;
    _toolBarAddHeight = 0;
    if (_inputTextView.text.length > 0) {
        _sendBtn.hidden = NO;
        _addMoreBtn.hidden = YES;
    }else if (_inputTextView.text.length == 0){
        _sendBtn.hidden = YES;
        _addMoreBtn.hidden = NO;
    }
}

- (void)updataModel:(MessageModel *)model{

    //3.创建一个cellFrameModel类
    CellFrameModel* cellFrame = [[CellFrameModel alloc]init];
    CellFrameModel* lastCellFrame = [_cellFrameDatas lastObject];
    model.showTime = ![lastCellFrame.message.time isEqualToString:model.time];
    
    cellFrame.message = model;
    
    //4.添加新数据
    [_cellFrameDatas addObject:cellFrame];
    [_mainTableview reloadData];
    
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
    [_mainTableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
        
//        self.functionView = [[FunctionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, getNumWithScanf(285))];
//        self.functionView.backgroundColor = getColor(@"fafafa");
////        self.functionView.delegate = self;
//        self.functionView.userInteractionEnabled = YES;
//        self.functionView.backgroundColor = [UIColor blackColor];


    }
    return _faceView;
}

-(UITableView *)mainTableview
{
    if (!_mainTableview) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        _mainTableview.dataSource = self;
        _mainTableview.delegate = self;
        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableview.backgroundColor = getColor(@"efefef");
        _mainTableview.tableHeaderView = self.headView;
//        _mainTableview.bounces = NO;
        
//        [_mainTableview registerClass:[ChatMessageTableViewCell class] forCellReuseIdentifier:KChatMessageCell];
    }
    return _mainTableview;
}

/**
 *  头视图背景
 */
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(10), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(183)+_testHeight+_companyNameHeight-getNumWithScanf(28))];
        _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
        _bgView.layer.borderWidth = 0.5;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

/**
 *  头视图
 */
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(210)+_testHeight+_companyNameHeight-getNumWithScanf(28))];
        [_headView addSubview:self.bgView];
        [self createSubviews];
        [self layout];
    }
    return _headView;
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
    _companyNameLab.text = self.companyName;
    [_bgView addSubview:_companyNameLab];
    
    _secondLab = [[UILabel alloc]init];
    _secondLab.textColor = getColor(@"595959");
    _secondLab.font = DEF_FontSize_13;
    _secondLab.text = [NSString stringWithFormat:@"%@:",self.GQName];
    [_bgView addSubview:_secondLab];
    
    _SupplyAndDemandLab = [[MyLabel alloc]init];
    _SupplyAndDemandLab.textColor = getColor(@"595959");
    _SupplyAndDemandLab.font = DEF_FontSize_13;
    //        _SupplyAndDemandLab.backgroundColor = [UIColor redColor];
    _SupplyAndDemandLab.textAlignment = NSTextAlignmentLeft;
    _SupplyAndDemandLab.lineBreakMode = NSLineBreakByWordWrapping;
    [_SupplyAndDemandLab setVerticalAlignment:VerticalAlignmentTop];
    _SupplyAndDemandLab.numberOfLines = 0;
    NSString* mainBussinessStr = self.supplyAndDemandString;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    _SupplyAndDemandLab.text = mainBussinessStr;
    [_bgView addSubview:_SupplyAndDemandLab];
    
    _thirdLab = [[UILabel alloc]init];
    _thirdLab.textColor = getColor(@"595959");
    _thirdLab.font = DEF_FontSize_13;
    _thirdLab.text = @"联  系  人:";
    [_bgView addSubview:_thirdLab];
    
    _fourthLab = [[UILabel alloc]init];
    _fourthLab.textColor = getColor(@"595959");
    _fourthLab.font = DEF_FontSize_13;
    _fourthLab.text = @"联系电话:";
    [_bgView addSubview:_fourthLab];
    
    _contactPeopleLab = [[UILabel alloc]init];
    _contactPeopleLab.textColor = getColor(@"595959");
    _contactPeopleLab.font = DEF_FontSize_13;
    _contactPeopleLab.text = self.linkMan;
    [_bgView addSubview:_contactPeopleLab];
    
    _contactTelLab = [[UILabel alloc]init];
    _contactTelLab.textColor = getColor(@"595959");
    _contactTelLab.font = DEF_FontSize_13;
//    _contactTelLab.text = self.telPhone;
    if ([self.telPhone isEqualToString:@"-1"]) {
        _contactTelLab.text = @"保密";
    }else{
        _contactTelLab.text = _detailModel.telphone;
    }
    [_bgView addSubview:_contactTelLab];
    
    [self layout];
    
}

-(void)layout
{
    _companyNameLab.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(_companyNameHeight+getNumWithScanf(5))
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .rightSpaceToView(_bgView,getNumWithScanf(20));
    
    _secondLab.sd_layout
    .leftSpaceToView(_bgView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(28))
    .widthIs(getNumWithScanf(130))
    .topSpaceToView(_companyNameLab,getNumWithScanf(18));
    
    _SupplyAndDemandLab.sd_layout
    .topEqualToView(_secondLab)
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellFrameDatas.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    ChatMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell)
    {
        cell = [[ChatMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.headImageUrl = self.headImageUrl;
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat inputViewContentSize = _inputTextView.contentSize.height;
    if (_toolBarHeight && _toolBarHeight < inputViewContentSize) {
        _toolBarAddHeight = _toolBarAddHeight + 15;
        self.toolBarView.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - MIN(_toolBarAddHeight, 15*4)-KToolBarH, SCREEN_WIDTH, MIN(_toolBarAddHeight, 15*4)+KToolBarH);
    }else if(_toolBarHeight && _toolBarHeight > inputViewContentSize)
    {
        _toolBarAddHeight = _toolBarAddHeight - 15;
        if (_toolBarHeight > 0) {
           self.toolBarView.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - MIN(_toolBarAddHeight, 15*4)-KToolBarH, SCREEN_WIDTH, MIN(_toolBarAddHeight, 15*4)+KToolBarH);
        }
        
    }
    _toolBarHeight = inputViewContentSize;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [_sendBtn.layer addAnimation:animation forKey:nil];
    [_addMoreBtn.layer addAnimation:animation forKey:nil];
    if (textView.text.length > 0) {
        _sendBtn.hidden = NO;
        _addMoreBtn.hidden = YES;
    }else if (textView.text.length == 0){
        _sendBtn.hidden = YES;
        _addMoreBtn.hidden = NO;
    }
}

#pragma mark - TZImagePickerControllerDelegate

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
   
    _photo = [photos lastObject];
    if ([isJoinedBlackList isEqual:@"0"]) {
        //没有被加入黑名单
        if ([isJoinBlackList isEqual:@"1"]) {
            //已将他加入黑名单,则移除
            [self removeFormBlcakListWithType:@"2"];
        }else if ([isJoinBlackList isEqual:@"0"]){
            //发图片
            [self sendPictureWithImage:_photo];
        }
    }else if ([isJoinedBlackList isEqual:@"1"]){
        //已经被加入黑名单
        [MBProgressHUD showSuccess:@"你已经被加入黑名单"];
    }
    
}

//发图片
-(void)sendPictureWithImage:(UIImage*)image
{
    NSString* photoStr = [self imageChangeToBase64:image];
    [YSBLL saveTheChatImageWithContextimage:photoStr andResultBlock:^(SaveTheChatMessageModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000; //时间戳
            NSInteger time = [[[NSString stringWithFormat:@"%f",interval] substringToIndex:10] intValue];
            NSString *msgTime = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld000",time]];
            
            MessageModel* message = [[MessageModel alloc]init];
            message.text = model.chatimage;
            message.time = msgTime;
            message.type = 0;
            message.messageType = @"1";
            [self updataModel:message];
            
            NSString *uuid = [[NSUUID UUID] UUIDString];
            
            //保存聊天信息
            [[YSDatabase shareYSDatabase]saveMessage:@"9020" msgId:uuid mfromId:[UserModel shareInstanced].userID time:time mtoId:self.qcId msgContentStr:model.chatimage msgStatusStr:@"0" type:@"1"];
            
            //保存好友
            if (![[YSDatabase shareYSDatabase] isSaveFriendId:self.qcId]) {
                [[YSDatabase shareYSDatabase]saveFriendList:self.qcId fName:self.companyName contactname:[UserModel shareInstanced].name portal:[UserModel shareInstanced].icon tel:self.telPhone info:[NSString stringWithFormat:@"%@:%@",self.GQName,self.supplyAndDemandString] linkman:self.linkMan headimageurl:self.headImageUrl sellbuyid:self.sellbuyid msgStatus:@"0"];
            }else{
                [[YSDatabase shareYSDatabase]motifityTheFriendList:self.sellbuyid info:[NSString stringWithFormat:@"%@:%@",self.GQName,self.supplyAndDemandString] linkman:self.linkMan friendId:self.qcId companyname:self.companyName andGQName:nil];
            }
            
            //发消息
            [[YSSocketProtocol shareSocketProtocol]sendData:@"9020" msgId:uuid msgContent:model.chatimage mtoId:self.qcId name:[UserModel shareInstanced].name portal:[UserModel shareInstanced].icon tel:self.telPhone company:self.companyName info:[NSString stringWithFormat:@"%@%@",self.GQName,self.supplyAndDemandString] linkMan:self.linkMan withType:1 sellbuyid:self.sellbuyid];
            
            NSLog(@"说说图片上传成功～～～～%@---\n%@",model.chatimage,model.chatimagesl);
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败2");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误2");
        }
    }];
}

//UIImage图片转成base64字符串
-(NSString*)imageChangeToBase64:(UIImage*)originImage
{
    NSData* data = UIImageJPEGRepresentation(originImage, 1.0f);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(originImage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(originImage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(originImage, 0.9);
        }
    }
    NSString* _encodeImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodeImageStr;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [NSString string];
    dateString = [self compareDate:date];
    if ([dateString isEqualToString:@"昨天"]) {
        dateString = [self compareDate:date];
    }else if([dateString isEqualToString:@"今天"]){
        dateString = [self compareCurrentTime:date];
    }else{
        dateString = [formatter stringFromDate:date];
    }
    return dateString;
}

-(NSString *) compareCurrentTime:(NSDate*) compareDate
//计算指定时间与当前的时间差
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

/**
 *  判断日期为今天还是昨天
 *
 *  @param date 日期
 *
 *  @return
 */
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"updataMsgList"];
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
