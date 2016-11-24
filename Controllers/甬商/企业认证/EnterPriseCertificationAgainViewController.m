//
//  EnterPriseCertificationAgainViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/10/11.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "EnterPriseCertificationAgainViewController.h"
#import "UIViewController+CompressImage.h"
#import "TZTestCell.h"
#import "TZNormalCollectionViewCell.h"
#import "CertificationINGViewController.h"
#import "CertificationSuccessViewController.h"
#import "CertificationFailedViewController.h"

@interface EnterPriseCertificationAgainViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextField* _enterPriseNameTextField;
    UITextField* _validDateTextField;
    UIButton* _submitBtn;
    UIImageView* _licenseImageView;
    UIImage *_newImage;
    UIImage* _originImage;
    NSString* nameStr;
}
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)UIImagePickerController *imagePickerController;  //图片选择器


@end

@implementation EnterPriseCertificationAgainViewController

/*------------------------------网络------------------------------------*/

/**
 *  企业重新认证
 */
-(void)submitTheCertificationAgainWithNewsDetails:(NSString*)newsDetails
{
    [self showprogressHUD];
    [YSBLL enterPriseCertificationAgainWithFlagName:_enterPriseNameTextField.text andNewsdetails:newsDetails andOperate:_validDateTextField.text andFlagID:[UserModel shareInstanced].companyId andResultBlock:^(CommonModel *model, NSError *error) {
        [self hiddenProgressHUD];
        if ([model.ecode isEqualToString:@"0"]) {
            CertificationINGViewController* cvc = [[CertificationINGViewController alloc]init];
            cvc.enterPriseName = _enterPriseNameTextField.text;
            cvc.vaild = _validDateTextField.text;
            [self.navigationController pushViewController:cvc animated:YES];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
            [MBProgressHUD showError:@"请求数据失败"];
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }else if ([model.ecode isEqualToString:@"-4"]){
            [self hiddenProgressHUD];
            [MBProgressHUD showError:@"企业认证中，不能重复提交"];
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainScrollView];
    [self NavTitle:@"企业认证"];
    [_mainScrollView addSubview:self.bgView];
    [self creatSubViews];
}

#pragma mark - function

/**
 *  提交按钮
 */
-(void)submitCertificationClick
{
    if(_enterPriseNameTextField.text.length == 0 ){
        [self showMessage:@"请输入企业名称"];
        return;
    }
    if (_validDateTextField.text.length == 0) {
        [self showMessage:@"请输入有效期"];
        return;
    }
    if([[_enterPriseNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [self showMessage:@"请输入正确的字符"];
        return;
    }
    if (![TSRegularExpressionUtil validateMonthAndYear:_validDateTextField.text]) {
        [self showMessage:@"请输入正确的有效期"];
        return;
    }
    if (!self.licenseImages && !_newImage) {
        [self showMessage:@"请上传营业执照"];
        return;
    }
    NSString* imageString64 = [NSString string];
    if (!_newImage) {
        imageString64 = @"";
    }else{
        imageString64 = [self imageChangeToBase64:_originImage];
    }
    [self submitTheCertificationAgainWithNewsDetails:imageString64];
}

/**
 *  点击上传
 */
-(void)upLoadPicture
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self useCamera];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self usePhoto];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

/**
 *  拍照
 */
-(void)useCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

/**
 *  从相册选择
 */
-(void)usePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.sourceType = sourceType;
    if(iOS8Later) {
        _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:_imagePickerController animated:YES completion:nil];
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

#pragma mark - Init


/**
 *  图片选择器
 */
-(UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
//        _imagePickerController.allowsEditing = YES;
        [_imagePickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:getColor(@"ffffff")}];
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            //            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            //            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerController;
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(10), SCREEN_WIDTH, SCREEN_HEIGHT - getNumWithScanf(10) - 64)];
        _mainScrollView.backgroundColor = getColor(@"f7f7f7");
        //        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-getNumWithScanf(10));
        
    }
    return _mainScrollView;
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, getNumWithScanf(548))];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = getColor(@"dddddd").CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}

-(void)creatSubViews
{
    //圈子名称
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(40), getNumWithScanf(110), getNumWithScanf(64))];
    firstLab.text = @"企业名称";
    firstLab.textColor = getColor(@"333333");
    firstLab.font = DEF_FontSize_12;
    [_bgView addSubview:firstLab];
    
    _enterPriseNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(40), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _enterPriseNameTextField.text = self.enterPriseName;
    _enterPriseNameTextField.placeholder = @"输入企业名称";
    [_enterPriseNameTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_enterPriseNameTextField setValue:DEF_FontSize_12 forKeyPath:@"_placeholderLabel.font"];
    _enterPriseNameTextField.font = DEF_FontSize_12;
    _enterPriseNameTextField.textColor = getColor(@"4d4d4d");
    _enterPriseNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _enterPriseNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_enterPriseNameTextField];
    
    _licenseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(180), getNumWithScanf(150), getNumWithScanf(100))];
    _licenseImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadPicture)];
    [_licenseImageView addGestureRecognizer:tap];
   
    [_licenseImageView sd_setImageWithURL:[NSURL URLWithString:self.licenseImages] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
    [_bgView addSubview:_licenseImageView];
    
    //有效期
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(368), getNumWithScanf(110), getNumWithScanf(64))];
    secondLab.text = @"有效期至";
    secondLab.textColor = getColor(@"333333");
    secondLab.font = DEF_FontSize_12;
    [_bgView addSubview:secondLab];
    
    _validDateTextField = [[UITextField alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(368), SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(64))];
    _validDateTextField.font = DEF_FontSize_12;
    _validDateTextField.text = self.vaild;
    _validDateTextField.placeholder = @"输入营业执照的有效期(例:XXXX.XX.XX)";
    [_validDateTextField setValue:getColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    [_validDateTextField setValue:DEF_FontSize_11 forKeyPath:@"_placeholderLabel.font"];
    _validDateTextField.textColor = getColor(@"4d4d4d");
    _validDateTextField.borderStyle = UITextBorderStyleRoundedRect;
    _validDateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_validDateTextField];
    
    //上传执照
    UILabel* thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(140), getNumWithScanf(280), getNumWithScanf(200), getNumWithScanf(64))];
    thirdLab.text = @"上传营业执照";
    thirdLab.textColor = getColor(@"777777");
    thirdLab.font = DEF_FontSize_11;
    [_bgView addSubview:thirdLab];
    
    //通知
    UILabel* notiLab = [[UILabel alloc]initWithFrame:CGRectMake(0, getNumWithScanf(488), SCREEN_WIDTH, getNumWithScanf(26))];
    notiLab.text = @"我们将在三个工作日将审核结果通知你";
    notiLab.textColor = getColor(@"333333");
    notiLab.font = DEF_FontSize_12;
    notiLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:notiLab];
    
    //提交
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    _submitBtn.backgroundColor = getColor(@"3fbefc");
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 5;
    [_submitBtn addTarget:self action:@selector(submitCertificationClick) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.titleLabel.font = DEF_FontSize_13;
    [self.view addSubview:_submitBtn];
    
    _submitBtn.sd_layout
    .leftSpaceToView(self.view,getNumWithScanf(30))
    .rightSpaceToView(self.view,getNumWithScanf(30))
    .heightIs(getNumWithScanf(80))
    .topSpaceToView(_bgView,getNumWithScanf(80));
    
}

#pragma mark - imagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _originImage = image;
    _newImage = [self compressImage:image toTargetWidth:getNumWithScanf(140)];
    
    CGFloat minHeight = MIN(_newImage.size.height, getNumWithScanf(160));
    _licenseImageView.frame = CGRectMake(getNumWithScanf(140), getNumWithScanf(180)-(getNumWithScanf(-100)+minHeight), getNumWithScanf(150), minHeight);
    _licenseImageView.image = _newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
