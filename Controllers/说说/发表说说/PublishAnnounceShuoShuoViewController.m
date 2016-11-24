//
//  PublishAnnounceShuoShuoViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "PublishAnnounceShuoShuoViewController.h"
#import "PublishAnnounceShuoShuoCollectionReusableView.h"
#import "TZTestCell.h"
#define KTag 1000

@interface PublishAnnounceShuoShuoViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate>
{
    UIButton* _sendBtn;   //发送
//    NSMutableArray* _selectedAssert;       //缩略图数组
    NSMutableArray* _selectedPhoto;        //选择的图片数组
    NSString* _talktalkId;                 //说说编号
    PublishAnnounceShuoShuoCollectionReusableView* _headerView;
    NSMutableArray* _imageBase64DataArray;  //图片base64数组
    NSMutableArray* _imageArray;
    NSMutableArray* _notSuccessImageArray;  //未上传成功的图片数组
    NSArray* _notSuccessImage64Array;
}
@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)UICollectionView* collectionView;     //装载图片容器

@end

@implementation PublishAnnounceShuoShuoViewController

/*------------------------------网络------------------------------------*/

/**
*  我的说说新增接口
*/
-(void)addNewTalkTalk
{
    NSString* shuoshuoString = _headerView.publishContentTextField.text;
    //去掉首尾的换行和空格符
    shuoshuoString = [shuoshuoString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* totalTalk = [NSString string];
    if (_imageArray.count == 0) {
        totalTalk = @"0";
    }else{
        totalTalk = [NSString stringWithFormat:@"%ld",_imageArray.count];
    }
    [self showprogressHUD];
    [YSBLL AddNewTalkTalkWithCreatecid:[UserModel shareInstanced].userID andContext:shuoshuoString andTotalTalk:totalTalk andResultBlock:^(YSMyDisPlayRoomDetailModel *model, NSError *error) {
        
         if ([model.ecode isEqualToString:@"0"]) {
            if ([model.imagesid isEqualToString:@"0"]) {
                [self showMessage:@"发布失败，当日发布说说已超额"];
            }else{
                _talktalkId = model.imagesid;
                
                //获取当前时间戳
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[date timeIntervalSince1970]*1000;
                NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
                NSDictionary* shuoshuoDict = @{@"shuoshuoId":model.imagesid,
                                               @"shuoshuoContent":shuoshuoString,
                                               @"shuoshuoCreatTime":timeString,
                                               @"shuoshuoImage":_imageArray};
                //发送通知  新增说说
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addNewShuoShuo" object:nil userInfo:shuoshuoDict];
                if (_imageArray.count > 0) {
                    [self changeOrginImageToBase64WithCount:0];
                    [self uploadThePictureWithPictNum:0];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else if ([model.ecode isEqualToString:@"-2"]){
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"说说发表失败"];
            NSLog(@"请求数据失败1");
        }else if ([model.ecode isEqualToString:@"-1"]){
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"说说发表失败"];
            NSLog(@"异常错误1");
        }else if ([model.ecode isEqualToString:@"-3"]){
            //没有权限
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有权限发表说说" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:^{
            }];
        }
        [self hiddenProgressHUD];
    }];
}

/**
 *  上传图片
 */
-(void)uploadThePictureWithPictNum:(int)pictNum
{
    if (pictNum < _imageArray.count) {
        [YSBLL upLoadShuoShuoPictureWithFlagId:_talktalkId andImageurl1:_imageBase64DataArray[0] andImageurl2:_imageBase64DataArray[1] andImageurl3:_imageBase64DataArray[2] andImageurl4:_imageBase64DataArray[3] andImageurl5:_imageBase64DataArray[4] andImageurl6:_imageBase64DataArray[5] andImageurl7:_imageBase64DataArray[6] andImageurl8:_imageBase64DataArray[7] andImageurl9:_imageBase64DataArray[8] andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
            if ([model.ecode isEqualToString:@"0"]) {
                NSLog(@"说说图片上传成功～～～～%d",pictNum);
                [UserModel shareInstanced].imageLastCount = [NSString stringWithFormat:@"%d",pictNum];
                [UserModel shareInstanced].shuoshuoId = _talktalkId;
                [UserModel shareInstanced].imageTotalCount = [NSString stringWithFormat:@"%ld",_imageArray.count];
                NSMutableArray* imageArr  = [self changeImageToString];
                [self saveTheDataToCachesWithData:imageArr toThePlistFile:@"imageNotUpload"];
                
                [self changeOrginImageToBase64WithCount:pictNum+1];
                [self uploadThePictureWithPictNum:pictNum + 1];
            }else if ([model.ecode isEqualToString:@"-2"]){
                NSLog(@"请求数据失败2");
            }else if ([model.ecode isEqualToString:@"-1"]){
                NSLog(@"异常错误2");
            }
        }];
    }
}

/**
 *  上传未成功的图片
 */
//-(void)uploadPictureNormalWith:(NSMutableArray*)array andCount:(int)count
//{
//    if (count < array.count) {
//        [YSBLL upLoadShuoShuoPictureWithFlagId:_talktalkId andImageurl1:array[0] andImageurl2:array[1] andImageurl3:array[2] andImageurl4:array[3] andImageurl5:array[4] andImageurl6:array[5] andImageurl7:array[6] andImageurl8:array[7] andImageurl9:array[8] andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
//            if ([model.ecode isEqualToString:@"0"]) {
//                NSLog(@"说说图片上传成功～～～～%d",count);
//                [self uploadImageArrChangedWithCount:count+1 andImageArray:_notSuccessImage64Array];
//                [self uploadPictureNormalWith:array andCount:count+1];
//            }else if ([model.ecode isEqualToString:@"-2"]){
//                NSLog(@"请求数据失败2");
//            }else if ([model.ecode isEqualToString:@"-1"]){
//                NSLog(@"异常错误2");
//                [UserModel shareInstanced].imageLastCount = [NSString stringWithFormat:@"%d",count];
//            }
//        }];
//    }
//}

/**
 *  上传未成功的图片
 */
//-(void)uploadTheImageNotSuccess
//{
//    NSLog(@"检测未上传的图片。。。。。。。。。。");
//    if ([UserModel shareInstanced].imageLastCount != nil) {
//        int imageLastCount = [[UserModel shareInstanced].imageLastCount intValue];
//        int imageTotalCount = [[UserModel shareInstanced].imageTotalCount intValue];
//   
//        if (imageLastCount != (imageTotalCount - 1) ) {
//            NSArray* image64Array = [self readTheDataFromCachesFromPlistFile:@"imageNotUpload"];
//            [self uploadImageArrChangedWithCount:imageLastCount andImageArray:image64Array];
//            [self uploadPictureNormalWith:_notSuccessImageArray andCount:imageLastCount];
//    }
//    }
//}

/*------------------------------页面------------------------------------*/

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _selectedPhoto = [[NSMutableArray alloc]init];
    _imageArray = [[NSMutableArray alloc]init];
//    _selectedAssert = [[NSMutableArray alloc]init];
    
    
    //添加通知 检测未上传的图片
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadTheImageNotSuccess) name:@"checkTheImageNotUpload" object:nil];
    
    [self NavTitle:@"发表说说"];
    [self.view addSubview:self.mainScrollView];
}

#pragma mark - function

/**
 *  发表说说
 */
-(void)publishTalkTalk
{
    if (_headerView.publishContentTextField.text.length == 0) {
        [self showMessage:@"请输入说说内容"];
        return;
    }
    if([[_headerView.publishContentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [self showMessage:@"请输入正确的字符"];
        return;
    }
    [self addNewTalkTalk];
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

-(NSMutableArray*)changeImageToString
{
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 9; i++) {
        if (i < _imageArray.count) {
            NSString* base64Str = [self imageChangeToBase64:_imageArray[i]];
            [tempArray addObject:base64Str];
        }
//            else{
//            [tempArray addObject:@""];
//        }
    }
    return tempArray;
}
//
//-(void)uploadImageArrChangedWithCount:(int)count andImageArray:(NSArray*)imageArray
//{
//    _notSuccessImageArray =  [[NSMutableArray alloc]init];
//    for (int i = 0 ; i < 9; i++) {
//        if (i < imageArray.count) {
//            if (i == count) {
//                [_notSuccessImageArray addObject:imageArray[i]];
//            }else{
//                [_notSuccessImageArray addObject:@""];
//            }
//            
//        }else{
//            [_notSuccessImageArray addObject:@""];
//        }
//    }
//}

/**
 *  将选中的图片转换成base64字符串
 */
-(void)changeOrginImageToBase64WithCount:(int)count
{
    _imageBase64DataArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 9; i++) {
        if (i < _imageArray.count) {
            if (i == count) {
                NSString* base64Str = [self imageChangeToBase64:_imageArray[i]];
                [_imageBase64DataArray addObject:base64Str];
            }else{
                [_imageBase64DataArray addObject:@""];
            }
            
        }else{
            [_imageBase64DataArray addObject:@""];
        }
    }
    
//    NSLog(@"_smallPicUrlString==%@",_imageBase64DataArray);

}

/**
 *  进入照片选择器
 */
- (void)pushImagePickerControllerWithCount:(NSInteger)count {
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
    imagePickerVc.photoWidth = 727;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *  当选择的图片改变时，改变collectionview高度
 */
-(void)changeHeight
{
    if (_imageArray.count < 4) {
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(410));
    }else if (_imageArray.count < 8){
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(410)+(SCREEN_WIDTH -getNumWithScanf(20)*5)/4 + getNumWithScanf(20));
    }else if (_imageArray.count >= 8)
    {
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(410)+(SCREEN_WIDTH -getNumWithScanf(20)*5)/2 + getNumWithScanf(40));
    }
    
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
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_mainScrollView addSubview:self.collectionView];
    }
    return _mainScrollView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH -getNumWithScanf(20)*5)/4,(SCREEN_WIDTH -getNumWithScanf(20)*5)/4);
        layout.minimumInteritemSpacing = getNumWithScanf(20);
        layout.minimumLineSpacing = getNumWithScanf(20);
        layout.sectionInset = UIEdgeInsetsMake(0, getNumWithScanf(20), 0, getNumWithScanf(20));
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, getNumWithScanf(250));
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(410)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.layer.borderColor = getColor(@"dddddd").CGColor;
        _collectionView.layer.borderWidth = 0.5;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = getColor(@"ffffff");
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TZNormalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TZNormalCollectionViewCell"];
        [_collectionView registerClass:[PublishAnnounceShuoShuoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"publishHeadView"];
        
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:getColor(@"3fbefc")];
        _sendBtn.titleLabel.font = DEF_FontSize_13;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 5;
        [_sendBtn addTarget:self action:@selector(publishTalkTalk) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:_sendBtn];
        _sendBtn.sd_layout
        .topSpaceToView(_collectionView,getNumWithScanf(80))
        .leftSpaceToView(self.mainScrollView,getNumWithScanf(30))
        .rightSpaceToView(self.mainScrollView,getNumWithScanf(30))
        .heightIs(getNumWithScanf(80));
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _imageArray.count) {
        TZNormalCollectionViewCell* cells = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZNormalCollectionViewCell" forIndexPath:indexPath];
        return cells;
    }
    
    TZTestCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.imageView.image = _imageArray[indexPath.item];
    cell.deleteBtn.tag = indexPath.row + KTag;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"publishHeadView" forIndexPath:indexPath];
    [_headerView.personImageBtn sd_setImageWithURL:[NSURL URLWithString:self.headImageUrl] placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];
    return _headerView;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _imageArray.count && _imageArray.count < 9) {
        [self pushImagePickerControllerWithCount:9-_imageArray.count];
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
    
    NSMutableArray* tempArr = [NSMutableArray array];
    for (int i = 0; i < assets.count; i++) {
        [[TZImageManager manager]getOriginalPhotoWithAsset:assets[i] completion:^(UIImage *photo, NSDictionary *info) {
            [tempArr addObject:photo];
            NSLog(@"----%@",photo);
        }];
    }
    [self changeHeight];
    [_collectionView reloadData];
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
