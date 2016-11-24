//
//  YongShangNotificationViewController.m
//  YongShang
//
//  Created by 姜易成 on 16/9/13.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "YongShangNotificationViewController.h"
#import "YSBLL+YongShang.h"

@interface YongShangNotificationViewController ()
{
    YSTopInfoDetailModel* _infoDetailModel;
    CGFloat _labHeight;
}
@property(nonatomic,strong)UIScrollView* mainScrollView;

@end

@implementation YongShangNotificationViewController

/*------------------------------网络------------------------------------*/

-(void)loadTopInfoDetailData
{
    [self showprogressHUD];
    [YSBLL getInfoDetailWithFlagId:self.imageId andResultBlock:^(YSTopInfoDetailModel *model, NSError *error) {
        NSLog(@"-----%@",model.ecode);
        if ([model.ecode isEqualToString:@"0"]) {
            _infoDetailModel = model;
            _labHeight = [self kdetailTextHeight:_infoDetailModel.context width:SCREEN_WIDTH - 20];
            [self.view addSubview:self.mainScrollView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
        [self hiddenProgressHUD];
    }];
}

/*-----------------------------页面-------------------------------------*/

-(void)viewDidLoad
{
    [self NavTitle:@"甬商"];
    self.view.backgroundColor = getColor(@"f7f7f7");
    [self loadTopInfoDetailData];
}

#pragma mark - Init
-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 64)];
        _mainScrollView.backgroundColor = getColor(@"f7f7f7");
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 64, getNumWithScanf(390)+20+_labHeight));
        
        //标题
        UILabel* titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, getNumWithScanf(30), SCREEN_WIDTH - 20, getNumWithScanf(26))];
        titleLab.font = DEF_FontSize_13;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = getColor(@"333333");
        titleLab.text = _infoDetailModel.title;
        [_mainScrollView addSubview:titleLab];
        
        //日期
        UILabel* dateLab = [[UILabel alloc]initWithFrame:CGRectMake(0, getNumWithScanf(65), SCREEN_WIDTH, getNumWithScanf(22))];
        dateLab.text = _infoDetailModel.createtime;
        dateLab.textColor = getColor(@"888888");
        dateLab.textAlignment = NSTextAlignmentCenter;
        dateLab.font = DEF_FontSize_11;
        [_mainScrollView addSubview:dateLab];
        
        //image
        UIImageView* imageUrl = [[UIImageView alloc]initWithFrame:CGRectMake(10, getNumWithScanf(110), SCREEN_WIDTH - 20, getNumWithScanf(280))];
        [imageUrl sd_setImageWithURL:[NSURL URLWithString:_infoDetailModel.imageurl] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
        [_mainScrollView addSubview:imageUrl];
        
        UILabel * contextLab = [[UILabel alloc]initWithFrame:CGRectMake(10, getNumWithScanf(390), SCREEN_WIDTH - 20, _labHeight+20)];
        contextLab.font = DEF_FontSize_13;
        contextLab.numberOfLines = 0;
        contextLab.textColor = getColor(@"595959");
        contextLab.text = _infoDetailModel.context;
        [_mainScrollView addSubview:contextLab];
    }
    return _mainScrollView;
}

@end
