//
//  AddNewSupplyAndDemandViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/2.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "AddNewSupplyAndDemandViewController.h"
#import "YSIndustryTypeModel.h"
#import "TZTestCell.h"
#import "TZNormalCollectionViewCell.h"
#define KTag 1000000
#define MAX_LIMIT_NUMS  1000     //来限制最大输入只能1000个字符

@interface AddNewSupplyAndDemandViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,JYCDropDownMenuDelegate,TZImagePickerControllerDelegate,UITextViewDelegate>
{
    PlaceHoderTextView* _contentTextField;
//    UIButton* _publishTelBtn;     //公布电话
//    UIButton* _notPublishTelBtn;  //不公布电话
    UIButton* _publishBtn;        //发布
    NSMutableArray* _categoryArray;    //类别数组（供应。。。）
    NSMutableArray* _categoryIDArray;  //类别ID数组（供应。。。）
    NSMutableArray* _validIDArray;     //有效期ID数组（一天）
    NSMutableArray* _validArray;       //有效期数组
    NSInteger _categorySelectID;
    NSInteger _validSelectID;
    NSMutableArray* _imageArray;
    NSMutableArray* _selectedPhoto;        //选择的图片数组
    EditMySupplyAndDemandModel* _detailModel;
    NSString* _telPhoneStatus;         //电话是否公开
    NSString* gongqiuId;
    NSString* _memoString;                 //Base64图片字符串
}
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)JYCDropDownMenuView* categroyDropDownMenu;    //类别下拉列表
@property(nonatomic,strong)JYCDropDownMenuView*  validDateDropDownMenu;  //有效期下拉列表
@property(nonatomic,strong)JYCDropDownMenuView*  publishTelDropDownMenu;  //有效期下拉列表
@property(nonatomic,strong)UITapGestureRecognizer* hideDownlistTap;
@property(nonatomic,strong)UITapGestureRecognizer* hideValidDownlistTap;
@property(nonatomic,strong)UITapGestureRecognizer* hideTelDownlistTap;
@property(nonatomic,strong)UICollectionView* collectionView;     //装载图片容器

@end

@implementation AddNewSupplyAndDemandViewController

/*------------------------------网络------------------------------------*/

-(void)loadDownListArrayWithType:(NSString*)type
{
    [self showprogressHUD];
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/typeDetails.do?lxtype=%@&u_code=%@",type,[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            if ([type isEqualToString:@"3"]) {
                _categoryIDArray = [[NSMutableArray alloc]init];
                _categoryArray = [[NSMutableArray alloc]init];
                [self loadDownListArrayWithType:@"4"];
            }
            else if ([type isEqualToString:@"4"]){
                _validIDArray = [[NSMutableArray alloc]init];
                _validArray = [[NSMutableArray alloc]init];
            }
            
            //获取供求类型和有效期类型数组
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSIndustryTypeModel* industryModel = [YSIndustryTypeModel yy_modelWithJSON:obj];
                if ([type isEqualToString:@"3"]) {
                    [_categoryIDArray addObject:industryModel];
                    [_categoryArray addObject:industryModel.name];
                }
                else if ([type isEqualToString:@"4"]){
                    [_validIDArray addObject:industryModel];
                    [_validArray addObject:industryModel.name];
                }
            }];
            
            if (self.flagId) {
                NSLog(@"flagId===%@",self.flagId);
                
                //编辑我的供求信息
//                [self showprogressHUD];
                [YSBLL EditMySupplyAndBuyINfoWithFlagId:self.flagId andResultBlock:^(EditMySupplyAndDemandModel *model, NSError *error) {
                    if ([model.ecode isEqualToString:@"0"]) {
                        
                        _detailModel = model;
                        _telPhoneStatus = _detailModel.telphoneType;
                        
                        if ([type isEqualToString:@"3"]) {
                            for (int i = 0; i < _categoryIDArray.count; i++) {
                                YSIndustryTypeModel* model = _categoryIDArray[i];
                                if ([model.industryId isEqualToString:_detailModel.lxtype]) {
                                    _categorySelectID = (NSInteger)i;
                                }
                            }
                        }
                        else if ([type isEqualToString:@"4"]){
                            for (int j = 0; j < _validIDArray.count; j++) {
                                YSIndustryTypeModel* model = _validIDArray[j];
                                if ([model.industryId isEqualToString:_detailModel.termid]) {
                                    _validSelectID = (NSInteger)j;
                                }
                            }
                            [self createSubViews];
                        }
                    }else if ([model.ecode isEqualToString:@"-2"]){
                        NSLog(@"请求数据失败");
                    }else if ([model.ecode isEqualToString:@"-1"]){
                        NSLog(@"异常错误");
                    }
//                    [self hiddenProgressHUD];
                }];
                
            }else{
                [self createSubViews];
            }
            
            
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  供求信息新增  types 0 传图片 1 不传图片
 */
-(void)addNewSupplyAndDemandWithType:(NSString*)type andTermtime:(NSString*)time withType:(NSString*)types
{
    [self showprogressHUD];
    BOOL state ;
    if ([_publishTelDropDownMenu.titleLab.text isEqualToString:@"公布电话"]) {
        state = YES;
    }else if ([_publishTelDropDownMenu.titleLab.text isEqualToString:@"不公布电话"]){
        state = NO;
    }
    NSString* telStatus = [NSString stringWithFormat:@"%d",state];
    
    [YSBLL addSupplyAndDemandWithlxtype:type andContext:_contentTextField.text andTermtime:time andTelphonestatus:telStatus andCreatecid:[UserModel shareInstanced].userID imagesuccess:types andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            NSLog(@"%@",model.emessage);
            if ([model.sellbuyid isEqualToString:@"-1"]) {
                [self hiddenProgressHUD];
                [self showMessage:@"发布失败，供求信息已超额，您可以取消之前发布的供求信息后，再发布"];
            }else{
//                [self showTemplantMessage:@"发布成功"];
                gongqiuId = model.sellbuyid;
                if ([types isEqualToString:@"0"]) {
                    [self uploadImage];
                }else{
                    [self hiddenProgressHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"发布失败"];
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"发布失败"];
        }else if ([model.ecode isEqualToString:@"-3"]){
            [self hiddenProgressHUD];
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限发布供求" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
    }];
}

/**
 *  上传图片
 */
-(void)uploadImage
{
//    [self showprogressHUD];
    [self changeOrginImageToBase64];
    [YSBLL sellAndBuyUploadimagesWithflagId:gongqiuId producturl1:@"" producturl1s:@"" memo:_memoString andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [self hiddenProgressHUD];
            [MBProgressHUD showSuccess:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"图片上传成功");
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

///**
// *  供求信息重新发布
// */
//-(void)RePublishMySupplyAndDemand
//{
//    BOOL state ;
//    NSString* telStatus = [NSString stringWithFormat:@"%d",state];
//    [self showprogressHUD];
//    [YSBLL revocationOrPublishTheSupplyAndDemandWithFlagId:self.flagId andCreatecid:[UserModel shareInstanced].userID andLxtype:[self judgeTheCategory] andContext:_contentTextField.text andTelphonestatus:telStatus andTradeId:[self judgeTheValid] andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
//        if ([model.ecode isEqualToString:@"0"]) {
//            NSLog(@"%@",model.emessage);
//            if ([model.data isEqualToString:@"发布失败，供求信息已超额"]) {
//                [self showMessage:@"您好，每个企业只能同时发布三条在线供求信息，您可以取消之前发布的供求信息后，再发布"];
//            }else{
//                //判断从哪个页面进来，1:我的供求页面 2:供求详情页面
////                [self showTemplantMessage:@"发布成功"];
//                [MBProgressHUD showSuccess:@"重新发布成功"];
//                if ([self.formIndex isEqualToString:@"1"]) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else if ([self.formIndex isEqualToString:@"2"]){
//                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//                }
//            }
//            
//        }else if ([model.ecode isEqualToString:@"-2"]){
//            NSLog(@"请求数据失败");
//        }else if ([model.ecode isEqualToString:@"-1"]){
//            NSLog(@"异常错误");
//        }else if ([model.ecode isEqualToString:@"-3"]){
//            //没有权限
//            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限重新发布供求" preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//            [self presentViewController:alertController animated:YES completion:^{
//            }];
//        }
//        [self hiddenProgressHUD];
//    }];
//}

/*-----------------------------页面-------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"新增供求"];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.bgView];
    _selectedPhoto = [[NSMutableArray alloc]init];
    _imageArray = [NSMutableArray arrayWithArray:_selectedPhoto];
    [self loadDownListArrayWithType:@"3"];
}

#pragma mark - function

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

/**
 *  将选中的图片转换成base64字符串
 */
-(void)changeOrginImageToBase64
{
    _memoString = [NSString string];
    for (int i = 0 ; i < _imageArray.count; i++) {
        NSString* imageStr =  [self imageChangeToBase64:_imageArray[i]];
        _memoString = [_memoString stringByAppendingString:[NSString stringWithFormat:@",%@",imageStr]];
    }
    _memoString = [_memoString substringWithRange:NSMakeRange(1, _memoString.length-1)];
    //    NSLog(@"_memoString==%@",_memoString);
}

/**
 *  进入照片选择器
 */
- (void)pushImagePickerControllerWithImagesCount:(NSInteger)count {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
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
    imagePickerVc.photoWidth = 828;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *  删除照片
 *
 *  @param btn 删除的第几个
 */
-(void)deleteBtnClik:(UIButton *)btn
{
    [_imageArray removeObjectAtIndex:btn.tag - KTag];
    //    [_selectedAssert removeObjectAtIndex:btn.tag - KTag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:btn.tag - KTag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self changeHeight];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

/**
 *  改变Bgview的高度
 */
-(void)changeHeight
{
    if (_imageArray.count < 3) {
        _bgView.frame = CGRectMake(0, getNumWithScanf(12), SCREEN_WIDTH, getNumWithScanf(710));
//        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 32);
    }else if (_imageArray.count >=3 && _imageArray.count <= 6)
    {
        _bgView.frame = CGRectMake(0, getNumWithScanf(12), SCREEN_WIDTH, getNumWithScanf(710)+getNumWithScanf(150));
//        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+getNumWithScanf(80));
    }
}

/**
 *  判断选中的类别的id （供应或求购）
 *
 *  @return 供应或求购的ID
 */
-(NSString*)judgeTheCategory
{
    NSString* selectCategory = [NSString string];
    for (YSIndustryTypeModel* model in _categoryIDArray) {
        
        if ([model.name isEqualToString:_categroyDropDownMenu.titleLab.text]) {
            selectCategory = model.industryId;
        }
    }
    return selectCategory;
}

/**
 *  判断选中的有效期的id
 *
 *  @return 有效期的id 
 */
-(NSString*)judgeTheValid
{
    NSString* selectValid = [NSString string];
    for (YSIndustryTypeModel* model in _validIDArray) {
        
        if ([model.name isEqualToString:_validDateDropDownMenu.titleLab.text]) {
            selectValid = model.industryId;
        }
    }
    return selectValid;
}

/**
 *  发布
 */
-(void)PublishClick
{
    if (_contentTextField.text.length == 0) {
        [self showMessage:@"请输入内容"];
        return;
    }
//    if (_contentTextField.text.length <= 10) {
//        [self showMessage:@"请输入大于10个字符"];
//        return;
//    }
    if([[_contentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [self showMessage:@"请输入正确的字符"];
        return;
    }
    
    if (self.flagId) {
//        [self RePublishMySupplyAndDemand];
    }else{
        if (_imageArray.count > 0) {
           [self addNewSupplyAndDemandWithType:[self judgeTheCategory] andTermtime:[self judgeTheValid] withType:@"0"];
        }else{
            [self addNewSupplyAndDemandWithType:[self judgeTheCategory] andTermtime:[self judgeTheValid] withType:@"1"];
        }
        
    }
}

/**
 *  是否公布电话
 */
//-(void)isPublishTelClick:(UIButton*)btn
//{
//    if (btn == _publishTelBtn) {
//        _publishTelBtn.selected = YES;
//        _notPublishTelBtn.selected = NO;
//    }else if (btn == _notPublishTelBtn)
//    {
//        _publishTelBtn.selected = NO;
//        _notPublishTelBtn.selected = YES;
//    }
//}

#pragma mark - Init

-(UITapGestureRecognizer *)hideDownlistTap
{
    if (!_hideDownlistTap) {
        _hideDownlistTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDownPushList)];
        _hideDownlistTap.delegate = self;
    }
    return _hideDownlistTap;
}

-(UITapGestureRecognizer *)hideValidDownlistTap
{
    if (!_hideValidDownlistTap) {
        _hideValidDownlistTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideValidDownPushList)];
        _hideValidDownlistTap.delegate = self;
    }
    return _hideValidDownlistTap;
}

-(UITapGestureRecognizer *)hideTelDownlistTap
{
    if (!_hideTelDownlistTap) {
        _hideTelDownlistTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideTelDownPushList)];
        _hideTelDownlistTap.delegate = self;
    }
    return _hideTelDownlistTap;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(12), SCREEN_WIDTH, getNumWithScanf(710))];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _mainScrollView.backgroundColor = getColor(@"f7f7f7");
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }
    return _mainScrollView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - getNumWithScanf(160) - 30)/3, getNumWithScanf(130));
        layout.minimumInteritemSpacing = getNumWithScanf(15);
        layout.minimumLineSpacing = getNumWithScanf(15);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = getColor(@"ffffff");
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TZNormalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TZNormalCollectionViewCell"];
    }
    return _collectionView;
}

-(void)createSubViews
{
    //类别
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(40), getNumWithScanf(110), getNumWithScanf(64))];
    firstLab.text = @"类    别";
    firstLab.textColor = getColor(@"333333");
    firstLab.font = DEF_FontSize_12;
    [_bgView addSubview:firstLab];
    
    self.categroyDropDownMenu = [[JYCDropDownMenuView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(40), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _categroyDropDownMenu.layer.masksToBounds = YES;
    _categroyDropDownMenu.layer.cornerRadius = 5;
    _categroyDropDownMenu.layer.borderWidth = 0.5;
    _categroyDropDownMenu.selectIndex = _categorySelectID ? _categorySelectID : 0;
    _categroyDropDownMenu.tableTitleFont = DEF_FontSize_12;
    _categroyDropDownMenu.menuTitleFont = DEF_FontSize_12;
    _categroyDropDownMenu.layer.borderColor = getColor(@"e6e6e6").CGColor;
    _categroyDropDownMenu.NumOfRow = 3;
    _categroyDropDownMenu.delegate = self;
    [_categroyDropDownMenu createOneMenuTitleArray:_categoryArray];
    
    //有效期
    UILabel* thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(124), getNumWithScanf(110), getNumWithScanf(64))];
    thirdLab.text = @"有效期";
    thirdLab.textColor = getColor(@"333333");
    thirdLab.font = DEF_FontSize_12;
    [_bgView addSubview:thirdLab];
    
    self.validDateDropDownMenu = [[JYCDropDownMenuView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(124), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _validDateDropDownMenu.layer.masksToBounds = YES;
    _validDateDropDownMenu.layer.cornerRadius = 5;
    _validDateDropDownMenu.layer.borderWidth = 0.5;
    _validDateDropDownMenu.selectIndex = _detailModel ? _validSelectID : 0;
    _validDateDropDownMenu.tableTitleFont = DEF_FontSize_12;
    _validDateDropDownMenu.menuTitleFont = DEF_FontSize_12;
    _validDateDropDownMenu.layer.borderColor = getColor(@"e6e6e6").CGColor;
    _validDateDropDownMenu.NumOfRow = 3;
    _validDateDropDownMenu.delegate = self;
    [_validDateDropDownMenu createOneMenuTitleArray:_validArray];
    
    //是否公布电话
    UILabel* fourthLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(208), getNumWithScanf(110), getNumWithScanf(64))];
    fourthLab.text = @"联系方式";
    fourthLab.textColor = getColor(@"333333");
    fourthLab.font = DEF_FontSize_12;
    [_bgView addSubview:fourthLab];
    
    self.publishTelDropDownMenu = [[JYCDropDownMenuView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(208), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _publishTelDropDownMenu.layer.masksToBounds = YES;
    _publishTelDropDownMenu.layer.cornerRadius = 5;
    _publishTelDropDownMenu.layer.borderWidth = 0.5;
    if (_telPhoneStatus && [_telPhoneStatus isEqualToString:@"1"]) {
        _publishTelDropDownMenu.selectIndex = 0;
    }else if (_telPhoneStatus && [_telPhoneStatus isEqualToString:@"0"])
    {
        _publishTelDropDownMenu.selectIndex = 1;
    }else{
        _publishTelDropDownMenu.selectIndex = 0;
    }
//    _publishTelDropDownMenu.selectIndex = _detailModel ? _validSelectID : 0;
    _publishTelDropDownMenu.tableTitleFont = DEF_FontSize_12;
    _publishTelDropDownMenu.menuTitleFont = DEF_FontSize_12;
    _publishTelDropDownMenu.layer.borderColor = getColor(@"e6e6e6").CGColor;
    _publishTelDropDownMenu.NumOfRow = 3;
    _publishTelDropDownMenu.delegate = self;
    [_publishTelDropDownMenu createOneMenuTitleArray:@[@"公布电话",@"不公布电话"]];
    
    
    //内容
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(292), getNumWithScanf(110), getNumWithScanf(64))];
    secondLab.text = @"内    容";
    secondLab.textColor = getColor(@"333333");
    secondLab.font = DEF_FontSize_12;
    [_bgView addSubview:secondLab];
    
    _contentTextField = [[PlaceHoderTextView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(296), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(248))];
    _contentTextField.placeHoder = @"输入内容～";
    _contentTextField.delegate = self;
    NSString* mainBussinessStr = _detailModel.content;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    _contentTextField.text = _detailModel ? mainBussinessStr : nil;
    _contentTextField.placeHoderColor = getColor(@"999999");
    _contentTextField.layer.masksToBounds = YES;
    _contentTextField.layer.cornerRadius = 5;
    _contentTextField.layer.borderWidth = 0.5;
    _contentTextField.layer.borderColor = getColor(@"e6e6e6").CGColor;
    [_bgView addSubview:_contentTextField];
    
//    //公布电话
//    _publishTelBtn = [[UIButton alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(500), 100, 40)];
//    _publishTelBtn.backgroundColor = [UIColor clearColor];
//    [_publishTelBtn setTitle:@"公布电话" forState:UIControlStateNormal];
//    [_publishTelBtn setTitleColor:getColor(@"777777") forState:UIControlStateNormal];
//    [_publishTelBtn setImage:[UIImage imageNamed:@"listNormal"] forState:UIControlStateNormal];
//    [_publishTelBtn setImage:[UIImage imageNamed:@"listSelected"] forState:UIControlStateSelected];
//    _publishTelBtn.selected = YES;
//    [_publishTelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    [_publishTelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
//    [_publishTelBtn addTarget:self action:@selector(isPublishTelClick:) forControlEvents:UIControlEventTouchUpInside];
//    _publishTelBtn.titleLabel.font = DEF_FontSize_11;
//    [_bgView addSubview:_publishTelBtn];
//    
//    //不公布电话
//    _notPublishTelBtn = [[UIButton alloc]initWithFrame:CGRectMake(getNumWithScanf(350), getNumWithScanf(500), 110, 40)];
//    _notPublishTelBtn.backgroundColor = [UIColor clearColor];
//    [_notPublishTelBtn setTitle:@"不公布电话" forState:UIControlStateNormal];
//    [_notPublishTelBtn setTitleColor:getColor(@"777777") forState:UIControlStateNormal];
//    [_notPublishTelBtn setImage:[UIImage imageNamed:@"listNormal"] forState:UIControlStateNormal];
//    [_notPublishTelBtn setImage:[UIImage imageNamed:@"listSelected"] forState:UIControlStateSelected];
//    _notPublishTelBtn.titleLabel.font = DEF_FontSize_11;
//    [_notPublishTelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    [_notPublishTelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
//    [_notPublishTelBtn addTarget:self action:@selector(isPublishTelClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bgView addSubview:_notPublishTelBtn];
    [_bgView addSubview:self.publishTelDropDownMenu];
    [_bgView addSubview:_validDateDropDownMenu];
    [_bgView addSubview:self.categroyDropDownMenu];
    [_bgView addSubview:self.collectionView];
    
    //内容
    UILabel* sixthLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(564), getNumWithScanf(110), getNumWithScanf(64))];
    sixthLab.text = @"产品图片";
    sixthLab.textColor = getColor(@"333333");
    sixthLab.font = DEF_FontSize_12;
    [_bgView addSubview:sixthLab];
    
    _collectionView.sd_layout
    .topEqualToView(sixthLab)
    .leftSpaceToView(_bgView,getNumWithScanf(140))
    .rightSpaceToView(_bgView,getNumWithScanf(20))
    .bottomEqualToView(_bgView);
    
    //发布
    _publishBtn = [[UIButton alloc]init];
    _publishBtn.backgroundColor = getColor(@"3fbefc");
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_publishBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [_publishBtn addTarget:self action:@selector(PublishClick) forControlEvents:UIControlEventTouchUpInside];
    _publishBtn.titleLabel.font = DEF_FontSize_13;
    _publishBtn.layer.masksToBounds = YES;
    _publishBtn.layer.cornerRadius = 5;
    [_mainScrollView addSubview:_publishBtn];
    
    _publishBtn.sd_layout
    .topSpaceToView(self.bgView,getNumWithScanf(50))
    .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
    .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
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

#pragma mark - collectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return  _imageArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _imageArray.count) {
        TZNormalCollectionViewCell* cells = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZNormalCollectionViewCell" forIndexPath:indexPath];
        return cells;
    }
    
    TZTestCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.imageView.image = _imageArray[indexPath.item];
    cell.deleteBtn.tag = indexPath.item + KTag;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - collectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _imageArray.count) {
        [self pushImagePickerControllerWithImagesCount:6-_imageArray.count];
    }
}

#pragma mark - TZImagePickerControllerDelegate

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhoto = [NSMutableArray arrayWithArray:photos];
    //    _selectedAssert = [NSMutableArray arrayWithArray:assets];
    for (int i = 0; i < _selectedPhoto.count; i++) {
        [_imageArray addObject:_selectedPhoto[i]];
    }
    //    _tempArr = [NSMutableArray array];
    //    for (int i = 0; i < assets.count; i++) {
    //        [[TZImageManager manager]getOriginalPhotoWithAsset:assets[i] completion:^(UIImage *photo, NSDictionary *info) {
    //            [_tempArr addObject:photo];
    //        }];
    //    }
    [self changeHeight];
    [_collectionView reloadData];
}

#pragma mark - 点击空白下拉列表消失
/**
 *  点击下拉列表代理
 *
 *  @param opened 是否打开
 */
-(void)dropDownMenuDidClick:(BOOL)opened andSelf:(UIView *)selfView
{
    if(selfView == self.categroyDropDownMenu){
        if (self.categroyDropDownMenu.isOpened) {
            [self.view addGestureRecognizer:self.hideDownlistTap];
        }else{
            [self.view removeGestureRecognizer:_hideDownlistTap];
        }
    }else if (selfView == self.validDateDropDownMenu){
        if (self.validDateDropDownMenu.isOpened) {
            [self.view addGestureRecognizer:self.hideValidDownlistTap];
        }else{
            [self.view removeGestureRecognizer:_hideValidDownlistTap];
        }
    }else if (selfView == self.publishTelDropDownMenu){
        if (self.publishTelDropDownMenu.isOpened) {
            [self.view addGestureRecognizer:self.hideTelDownlistTap];
        }else{
            [self.view removeGestureRecognizer:_hideTelDownlistTap];
        }
    }
}

-(void)tableViewDidSelect
{
    [self.view removeGestureRecognizer:_hideDownlistTap];
    [self.view removeGestureRecognizer:_hideValidDownlistTap];
    [self.view removeGestureRecognizer:_hideTelDownlistTap];
}

-(void)hideDownPushList
{
    [self.categroyDropDownMenu hideDropDownList];
    [self dropDownMenuDidClick:self.categroyDropDownMenu.isOpened andSelf:self.categroyDropDownMenu];
}

-(void)hideValidDownPushList
{
    [self.validDateDropDownMenu hideDropDownList];
    [self dropDownMenuDidClick:self.validDateDropDownMenu.isOpened andSelf:self.validDateDropDownMenu];
}

-(void)hideTelDownPushList
{
    [self.publishTelDropDownMenu hideDropDownList];
    [self dropDownMenuDidClick:self.publishTelDropDownMenu.isOpened andSelf:self.publishTelDropDownMenu];
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
