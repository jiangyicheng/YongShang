//
//  SelectAlbumCoverViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "SelectAlbumCoverViewController.h"

@interface SelectAlbumCoverViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImage * _image;
}
@property(nonatomic,strong)UIImagePickerController *imagePickerController;  //图片选择器
@end

@implementation SelectAlbumCoverViewController

/*------------------------------网络------------------------------------*/

/**
*  更换相册封面
*/
-(void)uploadTheAlbumCoverWithPhoto:(NSString*)selectphoto
{
    [self showprogressHUD];
    [YSBLL ChangeTheAlbumWithFlagId:[UserModel shareInstanced].userID andTalkurl:selectphoto andResultBlock:^(GQAddSupplyAndDemandModel *model, NSError *error) {
        [self hiddenProgressHUD];
        if ([model.ecode isEqualToString:@"0"]) {
            [UserModel shareInstanced].avatar_path = [self imageChangeToBase64:_image];
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"上传成功");
        }else if ([model.ecode isEqualToString:@"-2"]){
            [self uploadTheAlbumCoverWithPhoto:selectphoto];
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            [self uploadTheAlbumCoverWithPhoto:selectphoto];
            NSLog(@"异常错误");
        }
    }];
}

/*-----------------------------页面-------------------------------------*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavTitle:@"更换相册封面"];
    
    //布局
    UIButton* _albumSelectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, getNumWithScanf(30), SCREEN_WIDTH, getNumWithScanf(80))];
    _albumSelectBtn.backgroundColor = [UIColor whiteColor];
    [_albumSelectBtn addTarget:self action:@selector(selectPictuer) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(30), getNumWithScanf(250), getNumWithScanf(80))];
    firstLab.text = @"从手机相册选择";
    firstLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_albumSelectBtn];
    [self.view addSubview:firstLab];
    
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(110), SCREEN_WIDTH - getNumWithScanf(40), 0.5)];
    lineView.backgroundColor = getColor(@"dddddd");
    
    UIButton* takePhotobtn = [[UIButton alloc]initWithFrame:CGRectMake(0, getNumWithScanf(110), SCREEN_WIDTH, getNumWithScanf(80))];
    takePhotobtn.backgroundColor = [UIColor whiteColor];
    [takePhotobtn addTarget:self action:@selector(useCarema) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* secondLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(110), getNumWithScanf(200), getNumWithScanf(80))];
    secondLab.text = @"拍一张";
    secondLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:takePhotobtn];
    [self.view addSubview:secondLab];
    
    [self.view addSubview:lineView];
    
}

//图片选择器
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

#pragma mark - take photo

-(void)useCarema
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

#pragma mark - 相册选择

-(void)selectPictuer
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.sourceType = sourceType;
    if(iOS8Later) {
        _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - imagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self uploadTheAlbumCoverWithPhoto:[self imageChangeToBase64:_image]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
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
