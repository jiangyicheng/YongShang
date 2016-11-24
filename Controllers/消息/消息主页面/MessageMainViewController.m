//
//  MessageMainViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MessageMainViewController.h"
#import "MessageMainTableViewCell.h"
#import "ChatMessageViewController.h"
#import "DeleteAndStickChatView.h"
#import "MessageMainModel.h"
#import "MessageModel.h"

@interface MessageMainViewController ()<UITableViewDataSource,UITableViewDelegate,DeleteAndStickDelegate,longTouchTheCellDelegate>
{
    UIButton* _blackBtn;
    NSIndexPath* _selectIndexPath;
}
@property(nonatomic,strong)UITableView* mainTableView;
@property(nonatomic,strong)DeleteAndStickChatView* alertView;
@end

@implementation MessageMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"updataMsgList"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* document = [paths lastObject];
    NSLog(@"%@",document);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataMsgList)
                                                 name:@"updataMsgList"
                                               object:nil];
    
    [self.view addSubview:self.mainTableView];
}

//收到消息 刷新页面
-(void)updataMsgList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)loadData
{
    _idArray = [[NSMutableArray alloc]init];
    _nameArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *timeArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *friendArr = [[YSDatabase shareYSDatabase]queryfriendData];
    if ([friendArr count] > 0) {
        for (int i = 0; i< [friendArr count]; i ++) {
            MessageMainModel* message = [friendArr objectAtIndex:i];
            NSString *idStr = message.friendId;
            [_idArray addObject:idStr];
            [_nameArray addObject:message.name];
        }
        
        for (int i = 0; i < [_idArray count]; i ++) {
            NSString *friId = [_idArray objectAtIndex:i];
            NSMutableArray *arr = [[YSDatabase shareYSDatabase]queryMessgeData:friId];
            MessageModel *model = [arr objectAtIndex:[arr count] - 1];
            NSString *contentStr = model.text;
            NSString *time = model.time;
            NSInteger timestr = model.timestr;
            MessageMainModel* models = [friendArr objectAtIndex:i];
            
            if ([model.messageType isEqualToString:@"1"]) {
                contentStr = @"[图片]";
            }
            MessageMainModel* msgModel = [[MessageMainModel alloc]init];
            msgModel.friendId = friId;
            msgModel.content = contentStr;
            msgModel.time = time;
            msgModel.timestr = timestr;
            msgModel.name = [_nameArray objectAtIndex:i];
            msgModel.contactname = models.contactname,
            msgModel.contactTel = models.contactTel;
            msgModel.portal = models.portal;
            msgModel.info = models.info;
            msgModel.GQName = models.GQName;
            msgModel.sellbuyid = models.sellbuyid;
            [timeArr addObject:msgModel];
        }
    }
    
    NSArray *array =[timeArr sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        
        MessageMainModel *object1 = (MessageMainModel *)obj1;
        
        MessageMainModel *object2 = (MessageMainModel *)obj2;
        
        NSComparisonResult result = [[NSString stringWithFormat:@"%ld",object1.timestr]  compare:[NSString stringWithFormat:@"%ld",object2.timestr]];
        
        return result == NSOrderedAscending;
    }];
    
    _dataArray = [array mutableCopy];
//    [_dataArray addObjectsFromArray:array];
    
    NSLog(@"%@", _dataArray);
    
    [_mainTableView reloadData];
    
    NSLog(@"%@",_dataArray);
    
}

#pragma mark - function

/**
 *  长按某条消息
 */
-(void)longTouchTheCellWithCell:(UITableViewCell *)cell andGesture:(UILongPressGestureRecognizer *)longTouch
{
    if (longTouch.state == UIGestureRecognizerStateBegan) {
        _selectIndexPath = [self.mainTableView indexPathForCell:cell];
        [self showStickAndDeleteView];
    }
}

/**
 *  弹出提示框
 */
-(void)showStickAndDeleteView
{
    _blackBtn = [[UIButton alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    self.alertView.center = _blackBtn.center;
    [_blackBtn addSubview:self.alertView];
    [_blackBtn addTarget:self action:@selector(hideMoreFunctionView) forControlEvents:UIControlEventTouchUpInside];
    _blackBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.alertView.deleteChatBtn.hidden = NO;
    self.alertView.stickChatBtn.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:_blackBtn];
    
    [UIView animateWithDuration:0.2 animations:^{
        _blackBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

/**
 *  隐藏提示框
 */
-(void)hideMoreFunctionView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.deleteChatBtn.hidden = YES;
        self.alertView.stickChatBtn.hidden = YES;
    } completion:^(BOOL finished) {
        _blackBtn.hidden = YES;
        [_blackBtn removeFromSuperview];
    }];
}

/**
 *  置顶聊天
 */
-(void)firstStickBtnDidSelect
{
//    NSString* friendId = _idArray[_selectIndexPath.row];
//    [[YSDatabase shareYSDatabase]becomeFirstDataWithFriendId:friendId];
//    [self loadData];
    [self hideMoreFunctionView];
}

/**
 *  删除聊天
 */
-(void)secondDeleteBtnDidSelect
{
    MessageMainModel* msgModel = _dataArray[_selectIndexPath.row];
    [[YSDatabase shareYSDatabase]deleteDataWithFriendId:msgModel.friendId];
    [self loadData];
    [self hideMoreFunctionView];
}

/**
 *  更多功能
 *
 *  @return self
 */
-(DeleteAndStickChatView *)alertView
{
    if (!_alertView) {
        _alertView = [[DeleteAndStickChatView alloc]initWithFrame:CGRectMake(0, 0, getNumWithScanf(320), getNumWithScanf(160))];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 5;
        _alertView.delegate = self;
    }
    return _alertView;
}

#pragma mark - Init

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _mainTableView.backgroundColor = getColor(@"f7f7f7");
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.layer.borderColor = getColor(@"dddddd").CGColor;
        _mainTableView.layer.borderWidth = 0.5;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [_mainTableView registerNib:[UINib nibWithNibName:@"MessageMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageCell"] ;
    }
    return _mainTableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageMainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    cell.model = _dataArray[indexPath.row];
    cell.imageViews.layer.masksToBounds = YES;
    cell.imageViews.layer.cornerRadius = getNumWithScanf(60)-10;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(120);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageViewController* cvc = [[ChatMessageViewController alloc]init];
    MessageMainModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSString* sellAndBuy = [model.info substringFromIndex:5];
    NSString* gqName = [model.info substringToIndex:4];
    cvc.qcId = model.friendId;
    cvc.companyName = model.name;
    cvc.supplyAndDemandString = sellAndBuy;
    cvc.linkMan = model.contactname;
    cvc.telPhone = model.contactTel;
    cvc.headImageUrl = model.portal;
    cvc.GQName = gqName;
    cvc.sellbuyid = model.sellbuyid;
    [self.navigationController pushViewController:cvc animated:YES];
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
