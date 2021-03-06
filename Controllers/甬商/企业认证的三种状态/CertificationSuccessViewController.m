//
//  CertificationSuccessViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/9.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "CertificationSuccessViewController.h"
#import "EnterPriseCertificationAgainViewController.h"
#import "CertificationINGViewController.h"

@interface CertificationSuccessViewController ()<SDPhotoBrowserDelegate>
{
    MyLabel* _enterPriseNameLab;
    UIImageView* _licenseImageView;
    UILabel* _vaildLab;
    UIView* bgView;
}
@end

@implementation CertificationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavTitle:@"企业认证"];
    
    CGFloat companyNameHeight = [self kdetailTextHeight:self.enterPriseName width:SCREEN_WIDTH - getNumWithScanf(180)];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(getNumWithScanf(12), getNumWithScanf(12), SCREEN_WIDTH - getNumWithScanf(24), getNumWithScanf(300)+companyNameHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderColor = getColor(@"dddddd").CGColor;
    bgView.layer.borderWidth = 0.5;
    [self.view addSubview:bgView];
    
    UILabel* firstLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(20), getNumWithScanf(20), getNumWithScanf(130), getNumWithScanf(26))];
    firstLab.text = @"企业名称:";
    firstLab.textColor = getColor(@"333333");
    firstLab.font = DEF_FontSize_13;
    [bgView addSubview:firstLab];
    
    _enterPriseNameLab = [[MyLabel alloc]init];
    _enterPriseNameLab.textColor = getColor(@"333333");
    _enterPriseNameLab.font = DEF_FontSize_13;
    _enterPriseNameLab.text = _enterPriseName;
    _enterPriseNameLab.lineBreakMode = NSLineBreakByWordWrapping;
    _enterPriseNameLab.numberOfLines = 0;
    [_enterPriseNameLab setVerticalAlignment:VerticalAlignmentTop];
    [bgView addSubview:_enterPriseNameLab];
    
    _enterPriseNameLab.sd_layout
    .leftSpaceToView(firstLab,getNumWithScanf(10))
    .topSpaceToView(bgView,getNumWithScanf(18))
    .widthIs(SCREEN_WIDTH - getNumWithScanf(180))
    .heightIs(companyNameHeight+getNumWithScanf(5));
    
    UILabel* secondLab = [[UILabel alloc]init];
    secondLab.text = @"营业执照:";
    secondLab.textColor = getColor(@"333333");
    secondLab.font = DEF_FontSize_13;
    [bgView addSubview:secondLab];
    
    secondLab.sd_layout
    .leftSpaceToView(bgView,getNumWithScanf(20))
    .topSpaceToView(_enterPriseNameLab,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130))
    .heightIs(getNumWithScanf(26));
    
    UIView* imageBView = [[UIView alloc]init];
    [bgView addSubview:imageBView];
    
    imageBView.sd_layout
    .topSpaceToView(secondLab,getNumWithScanf(0))
    .leftEqualToView(_enterPriseNameLab)
    .widthIs(getNumWithScanf(150))
    .heightIs(getNumWithScanf(150));
    
    _licenseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(getNumWithScanf(0), getNumWithScanf(0), getNumWithScanf(150), getNumWithScanf(100))];
    _licenseImageView.backgroundColor = [UIColor redColor];
//    _licenseImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_licenseImageView sd_setImageWithURL:[NSURL URLWithString:_licenseImages] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
    UITapGestureRecognizer* touchTheImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DidTouchTheImage)];
    _licenseImageView.userInteractionEnabled = YES;
    [_licenseImageView addGestureRecognizer:touchTheImage];
    
    [imageBView addSubview:_licenseImageView];
    
    UILabel* thirdLab = [[UILabel alloc]init];
    thirdLab.text = @"有效期至:";
    thirdLab.textColor = getColor(@"333333");
    thirdLab.font = DEF_FontSize_13;
    [bgView addSubview:thirdLab];
    
    thirdLab.sd_layout
    .topSpaceToView(imageBView,getNumWithScanf(20))
    .leftSpaceToView(bgView,getNumWithScanf(20))
    .widthIs(getNumWithScanf(130))
    .heightIs(getNumWithScanf(26));
    
    _vaildLab = [[UILabel alloc]initWithFrame:CGRectMake(getNumWithScanf(160), getNumWithScanf(220),SCREEN_WIDTH - getNumWithScanf(160), getNumWithScanf(24))];
    _vaildLab.text = _vaild;
    _vaildLab.textColor = getColor(@"333333");
    _vaildLab.font = DEF_FontSize_12;
    [bgView addSubview:_vaildLab];
    
    _vaildLab.sd_layout
    .topEqualToView(thirdLab)
    .leftSpaceToView(thirdLab,getNumWithScanf(20))
    .widthIs(SCREEN_WIDTH - getNumWithScanf(160))
    .heightIs(getNumWithScanf(26));
    
    UIButton* unCertificationBtn = [[UIButton alloc]init];
    [unCertificationBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    [unCertificationBtn setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    unCertificationBtn.backgroundColor = getColor(@"3fbefc");
    unCertificationBtn.layer.masksToBounds = YES;
    unCertificationBtn.layer.cornerRadius = 5;
    unCertificationBtn.titleLabel.font = DEF_FontSize_13;
    [unCertificationBtn addTarget:self action:@selector(unCertificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unCertificationBtn];
    
    unCertificationBtn.sd_layout
    .leftSpaceToView(self.view,getNumWithScanf(30))
    .rightSpaceToView(self.view,getNumWithScanf(30))
    .heightIs(getNumWithScanf(80))
    .topSpaceToView(bgView,getNumWithScanf(80));
}

/**
 *  点击浏览图片
 */
-(void)DidTouchTheImage
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = 0;
    browser.sourceImagesContainerView = _licenseImageView.superview;
    browser.imageCount = 1;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.licenseImage;
    NSURL* url = [NSURL URLWithString:imageName];
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return _licenseImageView.image;
}

/**
 *  重新认证
 */
-(void)unCertificationBtnClick
{
    EnterPriseCertificationAgainViewController* cvc = [[EnterPriseCertificationAgainViewController alloc]init];
    cvc.enterPriseName = self.enterPriseName;
    cvc.vaild = self.vaild;
    cvc.licenseImages = self.licenseImages;
    [self.navigationController pushViewController:cvc animated:YES];
//    [self showprogressHUD];
//    [YSBLL getCommonWithUrl:[NSString stringWithFormat:@"appservice/afreshApply.do?flagId=%@",[UserModel shareInstanced].companyId] andResultBlock:^(CommonModel *model, NSError *error) {
//        if ([model.ecode isEqualToString:@"0"]) {
//            CertificationINGViewController* cvc = [[CertificationINGViewController alloc]init];
//            cvc.enterPriseName = self.enterPriseName;
//            cvc.vaild = self.vaild;
//            [self.navigationController pushViewController:cvc animated:YES];
//        }else if ([model.ecode isEqualToString:@"-2"]){
//            NSLog(@"请求数据失败");
//        }else if ([model.ecode isEqualToString:@"-1"]){
//            NSLog(@"异常错误");
//        }
//        [self hiddenProgressHUD];
//    }];
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
