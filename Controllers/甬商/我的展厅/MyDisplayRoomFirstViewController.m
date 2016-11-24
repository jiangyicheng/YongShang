//
//  MyDisplayRoomFirstViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/26.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MyDisplayRoomFirstViewController.h"
#import "TZTestCell.h"
#import "TZNormalCollectionViewCell.h"
#import "MyDisplayRoomFinishViewController.h"
#import "YSIndustryTypeModel.h"
#define KTag 10000
#define MAX_LIMIT_NUMS  1000     //来限制最大输入只能1000个字符

@interface MyDisplayRoomFirstViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,JYCDropDownMenuDelegate,TZImagePickerControllerDelegate,UITextViewDelegate>
{
    UITextField* _enterPriseNameTextField;
    UITextField* _contactPeopleTextField;
    UITextField* _contactTelTextField;
    UITextField* _addressTextField;
    PlaceHoderTextView* _BusinessTextField;
    UIButton* _submitBtn;
    UIView* _bgView;
    NSMutableArray* _imageArray;
    NSMutableArray* _selectedPhoto;        //选择的图片数组
    NSMutableArray* _industryNameArray;    //行业数组
    NSString* _selectListIndex;            //下拉列表选中的index
    NSMutableArray* _listArray;
    NSMutableArray* _tempArr;
    NSString* _enterPriseNum;              //企业编号
    NSString* _memoString;                 //Base64图片字符串
}
@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)JYCDropDownMenuView* dropDownMenuView;  //下拉列表
@property(nonatomic,strong)UICollectionView* collectionView;     //装载图片容器
@property(nonatomic,strong)UITapGestureRecognizer* hideDownlistTap;

@end

@implementation MyDisplayRoomFirstViewController

/*------------------------------网络------------------------------------*/

/**
 *  所属行业列表接口
 */
-(void)loadDownListArray
{
    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/typeDetails.do?lxtype=1&u_code=%@",[UserModel shareInstanced].postName] andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            _industryNameArray = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSIndustryTypeModel* industryModel = [YSIndustryTypeModel yy_modelWithJSON:obj];
                [_industryNameArray addObject:industryModel];
            }];
            _listArray = [[NSMutableArray alloc]init];
            [_industryNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSIndustryTypeModel* model = obj;
                [_listArray addObject:model.name];
            }];
            [self.view addSubview:self.mainScrollView];
            [self scrollViewAddSubView];
            [_dropDownMenuView createOneMenuTitleArray:_listArray];
            [self changeHeight];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
}

/**
 *  新增我的展厅接口
 */
-(void)submitPramaWithNet
{
    [self showprogressHUD];
    [self selectIndex];
    [YSBLL getResultWithFlagId:[UserModel shareInstanced].tradeId andUserid:[UserModel shareInstanced].userID andCompanyname:_enterPriseNameTextField.text andTrade:_selectListIndex andLinkman:_contactPeopleTextField.text andPhone:_contactTelTextField.text andMainbusiness:_BusinessTextField.text andOperate:@"1" andCreatecompanyid:[UserModel shareInstanced].companyId andlinkaddress:_addressTextField.text andResultBlock:^(YSMyDisPlayRoomDetailModel *model, NSError *error) {
        if ([model.ecode isEqual:@"0"]) {
            NSLog(@"提交成功啦～～～");
            _enterPriseNum = model.imagesid;
            if (_imageArray.count > 0) {
                [self upLoadThePicture];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"提交失败"];
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"提交失败"];
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  上传图片
 */
-(void)upLoadThePicture
{
    
    [YSBLL upLoadThePictureWithFlagId:_enterPriseNum andProducturl1:@"" andProducturl1s:@"" andMemo:_memoString andResultBlock:^(CommonModel *model, NSError *error) {
        if ([model.ecode isEqual:@"0"]) {
            NSLog(@"上传成功1～～～～");
            MyDisplayRoomFinishViewController* fvc = [[MyDisplayRoomFinishViewController alloc]init];
            [self.navigationController pushViewController:fvc animated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
            
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            
            NSLog(@"异常错误");
        }
    }];
}

/*------------------------------页面------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"我的展厅"];
    _selectedPhoto = [[NSMutableArray alloc]init];
    _imageArray = [NSMutableArray arrayWithArray:_selectedPhoto];
    [self loadDownListArray];
    
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
 *  提交
 */
-(void)submitBtnClick
{
    if(_enterPriseNameTextField.text.length == 0)
    {
        [self showMessage:@"企业名称不能为空，请填写内容"];
        return;
    }

    if (_contactPeopleTextField.text.length == 0 ) {
        [self showMessage:@"联系人不能为空，请填写内容"];
        return;
    }
    //    if (![TSRegularExpressionUtil validateUserName:_contactPeopleTextField.text]) {
    //        [self showMessage:@"请输入正确的联系人"];
    //        return;
    //    }
    if (_contactTelTextField.text.length == 0) {
        [self showMessage:@"联系电话不能为空，请填写内容"];
        return;
    }
    if (![TSRegularExpressionUtil validateTelephone:_contactTelTextField.text]) {
        [self showMessage:@"请输入正确的联系电话"];
        return;
    }
    if (_addressTextField.text.length == 0) {
        [self showMessage:@"联系地址不能为空，请填写内容"];
        return;
    }
    if (_BusinessTextField.text.length == 0) {
        [self showMessage:@"主营业务不能为空，请填写内容"];
        return;
    }
    if (_BusinessTextField.text.length <= 10) {
        [self showMessage:@"请输入大于10个字符"];
        return;
    }
    if([[_BusinessTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 || [[_enterPriseNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 ||[[_contactPeopleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 ||[[_addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0 ) {
        [self showMessage:@"请输入正确的字符"];
        return;
    }
    
    [self changeOrginImageToBase64];
    [self submitPramaWithNet];
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
        _bgView.frame = CGRectMake(0, getNumWithScanf(12), SCREEN_WIDTH, getNumWithScanf(882));
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 32);
    }else if (_imageArray.count >=3 && _imageArray.count <= 6)
    {
        _bgView.frame = CGRectMake(0, getNumWithScanf(12), SCREEN_WIDTH, getNumWithScanf(882)+getNumWithScanf(150));
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+getNumWithScanf(80));
    }
}

#pragma mark - Init

-(UITapGestureRecognizer *)hideDownlistTap
{
    if (!_hideDownlistTap) {
        _hideDownlistTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDownPushList)];
        _hideDownlistTap.delegate = self;
    }
    return _hideDownlistTap;
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

-(void)scrollViewAddSubView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(12), SCREEN_WIDTH, getNumWithScanf(950))];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
    [_mainScrollView addSubview:_bgView];
    
    //企业名称
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(40), getNumWithScanf(110), getNumWithScanf(64))];
    firstLab.text = @"企业名称";
    firstLab.textColor = getColor(@"333333");
    firstLab.font = DEF_FontSize_12;
    [_bgView addSubview:firstLab];
    
    _enterPriseNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(40), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _enterPriseNameTextField.placeholder = @"输入企业名称";
//    _enterPriseNameTextField.text = self.model ? self.model.companyName : nil;
    [_enterPriseNameTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_enterPriseNameTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    _enterPriseNameTextField.font = DEF_FontSize_12;
    _enterPriseNameTextField.textColor = getColor(@"4d4d4d");
    _enterPriseNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _enterPriseNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_enterPriseNameTextField];
    
    //企业归属
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(124), getNumWithScanf(110), getNumWithScanf(64))];
    secondLab.text = @"细分市场";
    secondLab.textColor = getColor(@"333333");
    secondLab.font = DEF_FontSize_12;
    [_bgView addSubview:secondLab];
    
    self.dropDownMenuView = [[JYCDropDownMenuView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(124), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _dropDownMenuView.layer.masksToBounds = YES;
    _dropDownMenuView.layer.cornerRadius = 5;
    _dropDownMenuView.layer.borderWidth = 0.5;
//    _dropDownMenuView.selectIndex = [self getIndexAtList];
    _dropDownMenuView.tableTitleFont = DEF_FontSize_12;
    _dropDownMenuView.menuTitleFont = DEF_FontSize_12;
    _dropDownMenuView.layer.borderColor = getColor(@"e6e6e6").CGColor;
    _dropDownMenuView.NumOfRow = 4;
    _dropDownMenuView.delegate = self;
    
    //联系人
    UILabel* thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(208), getNumWithScanf(110), getNumWithScanf(64))];
    thirdLab.text = @"联系人";
    thirdLab.textColor = getColor(@"333333");
    thirdLab.font = DEF_FontSize_12;
    [_bgView addSubview:thirdLab];
    
    _contactPeopleTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(208), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _contactPeopleTextField.placeholder = @"输入联系人";
//    _contactPeopleTextField.text = self.model ? self.model.linkman : nil;
    [_contactPeopleTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_contactPeopleTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    _contactPeopleTextField.font = DEF_FontSize_12;
    _contactPeopleTextField.textColor = getColor(@"4d4d4d");
    _contactPeopleTextField.borderStyle = UITextBorderStyleRoundedRect;
    _contactPeopleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_contactPeopleTextField];
    
    //联系电话
    UILabel* fourthLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(292), getNumWithScanf(110), getNumWithScanf(64))];
    fourthLab.text = @"联系电话";
    fourthLab.textColor = getColor(@"333333");
    fourthLab.font = DEF_FontSize_12;
    [_bgView addSubview:fourthLab];
    
    _contactTelTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(292), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _contactTelTextField.placeholder = @"输入联系电话";
//    _contactTelTextField.text = self.model ? self.model.phone : nil;
    [_contactTelTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_contactTelTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    _contactTelTextField.font = DEF_FontSize_12;
    _contactTelTextField.textColor = getColor(@"4d4d4d");
    _contactTelTextField.borderStyle = UITextBorderStyleRoundedRect;
    _contactTelTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_contactTelTextField];
    
    //联系地址
    UILabel* newLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(376), getNumWithScanf(110), getNumWithScanf(64))];
    newLab.text = @"联系地址";
    newLab.textColor = getColor(@"333333");
    newLab.font = DEF_FontSize_12;
    [_bgView addSubview:newLab];
    
    _addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(376), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _addressTextField.placeholder = @"输入联系地址";
//    _addressTextField.text = self.model ? self.model.linkaddress : nil;
    [_addressTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_addressTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    _addressTextField.font = DEF_FontSize_12;
    _addressTextField.textColor = getColor(@"4d4d4d");
    _addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_addressTextField];
    
    //主营业务
    UILabel* fivthLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(460), getNumWithScanf(110), getNumWithScanf(64))];
    fivthLab.text = @"主营业务";
    fivthLab.textColor = getColor(@"333333");
    fivthLab.font = DEF_FontSize_12;
    [_bgView addSubview:fivthLab];
    
    _BusinessTextField = [[PlaceHoderTextView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(464), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(248))];
    _BusinessTextField.placeHoder = @"输入内容～";
//    NSString* mainBussinessStr = self.model.mainbusiness;
//    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
//    _BusinessTextField.text = self.model ? mainBussinessStr : nil;
    _BusinessTextField.placeHoderColor = getColor(@"999999");
    _BusinessTextField.layer.masksToBounds = YES;
    _BusinessTextField.delegate = self;
    _BusinessTextField.layer.cornerRadius = 5;
    _BusinessTextField.layer.borderWidth = 0.5;
    _BusinessTextField.layer.borderColor = getColor(@"e6e6e6").CGColor;
    [_bgView addSubview:_BusinessTextField];
    [_bgView addSubview:self.dropDownMenuView];
    
    //产品图片
    UILabel* sixthLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(732), getNumWithScanf(110), getNumWithScanf(64))];
    sixthLab.text = @"产品图片";
    sixthLab.textColor = getColor(@"333333");
    sixthLab.font = DEF_FontSize_12;
    [_bgView addSubview:sixthLab];
    //    self.collectionView.backgroundColor = [UIColor redColor];
    //    _bgView.backgroundColor = [UIColor greenColor];
    [_bgView addSubview:self.collectionView];
    
    _collectionView.sd_layout
    .topEqualToView(sixthLab)
    .leftSpaceToView(_bgView,getNumWithScanf(140))
    .rightSpaceToView(_bgView,getNumWithScanf(20))
    .bottomEqualToView(_bgView);
    
    //提交
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _submitBtn.backgroundColor = getColor(@"3fbefc");
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 8;
    _submitBtn.titleLabel.font = DEF_FontSize_13;
    [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_submitBtn];
    
    _submitBtn.sd_layout
    .topSpaceToView(_bgView,getNumWithScanf(60))
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


#pragma mark - UIScrollViewDelegate

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
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


/**
 *  点击下拉列表代理
 *
 *  @param opened 是否打开
 */
-(void)dropDownMenuDidClick:(BOOL)opened andSelf:(UIView *)selfView
{
    if (opened) {
        [self.view addGestureRecognizer:self.hideDownlistTap];
    }else{
        [self.view removeGestureRecognizer:_hideDownlistTap];
    }
}

-(void)tableViewDidSelect
{
    [self.view removeGestureRecognizer:_hideDownlistTap];
    [self selectIndex];
}

-(void)selectIndex
{
    for (int i = 0 ; i < _industryNameArray.count; i++) {
        YSIndustryTypeModel* model = _industryNameArray[i];
        if ([model.name isEqualToString:_dropDownMenuView.titleLab.text]) {
            _selectListIndex = model.industryId ;
        }
    }
}


-(void)hideDownPushList
{
    [self.dropDownMenuView hideDropDownList];
    [self dropDownMenuDidClick:self.dropDownMenuView.isOpened andSelf:self.dropDownMenuView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
