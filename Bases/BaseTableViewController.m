//
//  BaseTableViewController.m
//  WNWJ
//
//  Created by 李莹 on 15/6/15.
//  Copyright (c) 2015年 Blue Mobi. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Config.h"
@interface BaseTableViewController ()
{
    UIView *alertView;
    UIView* blackView;
}
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UIView *alertWithLiftAndRightBtnView;

@end

@implementation BaseTableViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:getColor(@"ffffff")];
    
    [self.navigationController.navigationBar setBarTintColor:getColor(@"3fbefc")];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupForDismissKeyboard];
    _progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.tableView addSubview:_progressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/**
 *  通用提示框
 */
-(void)showAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message andButtonName:(NSString*)btnName
{
    UIAlertController *useralert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [useralert addAction:[UIAlertAction actionWithTitle:btnName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:useralert animated:YES completion:^{
        
    }];
}

//根据字的个数确定labe的高
- (CGFloat)kdetailTextHeight:(NSString *)text width:(CGFloat)width{
    
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:17.0f]} context:nil];
    return rectToFit.size.height;
}

- (void)showCustomAlertViewWithTitle:(NSString *)title {
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, [self kdetailTextHeight:title width:SCREEN_WIDTH - 50] + 72)];

    alertView.backgroundColor = [UIColor whiteColor];
    blackView = [[UIView alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

    alertView.center = blackView.center;
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, CGRectGetWidth(alertView.frame) - 30, [self kdetailTextHeight:title width:SCREEN_WIDTH - 50] + 22)];
    titleLabel.text = title;
    titleLabel.textColor = getColor(@"595959");
    titleLabel.font = DEF_FontSize_12;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [alertView addSubview:titleLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, [self kdetailTextHeight:title width:SCREEN_WIDTH - 50] + 32, CGRectGetWidth(alertView.frame), 0.5)];
    lineView.backgroundColor = getColor(@"dddddd");
    [alertView addSubview:lineView];
    
    UIButton* alertBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, [self kdetailTextHeight:title width:SCREEN_WIDTH - 50] + 32, CGRectGetWidth(alertView.frame), 40)];
    [alertBtn setTitle:@"确定" forState:UIControlStateNormal];
    alertBtn.titleLabel.font = DEF_FontSize_13;
    [alertBtn setTitleColor:getColor(@"666666") forState:UIControlStateNormal];
    [alertBtn addTarget:self action:@selector(hiddenAlertView) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:alertBtn];

    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
//    [self.navigationController.view addSubview:blackView];
    [blackView addSubview:alertView];
    

    [UIView animateWithDuration:0.3 animations:^{
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.618];
    }];

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.2 animations:^{
//            blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
//            alertView.hidden = YES;
//        } completion:^(BOOL finished) {
//            blackView.hidden = YES;
//            [blackView removeFromSuperview];
//        }];
//        self.navigationController.navigationBar.userInteractionEnabled = YES;
//        self.tabBarController.tabBar.userInteractionEnabled = YES;
//        self.view.userInteractionEnabled = YES;
//        
//    });
}

-(void)hiddenAlertView
{
    [UIView animateWithDuration:0.2 animations:^{
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        alertView.hidden = YES;
    } completion:^(BOOL finished) {
        blackView.hidden = YES;
        [blackView removeFromSuperview];
    }];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

- (void)showMessage:(NSString*)message{
    
    [self showCustomAlertViewWithTitle:message];
}

- (void) failureWithStatus:(NSString*)status message:(NSString*)message{
    
    NSLog(@"status:%@,msg:%@", status,message);
}

- (void) showError:(NSError*)error{
    NSLog(@"%@",error);

    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            [self showMessage:@"请检查你的网络"];
            break;
        case NSURLErrorTimedOut:
            [self showMessage:@"请求超时，请查看你的网络"];
            break;
        case NSURLErrorCannotConnectToHost:
            [self showMessage:@"服务器繁忙，请稍后重试"];
            break;
        case NSURLErrorNetworkConnectionLost:
            [self showMessage:@"处理过程中网络中断，请重试"];
            break;
        default:
            [self showMessage:@"未知错误"];
            break;
    }

}

-(void)showprogressHUD{
    [_progressHUD show:YES];
}

-(void)hiddenProgressHUD{
    [_progressHUD hide:YES];
}
//获取现在时间
- (NSString *)nowTime {
    
    NSDate *todayDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: todayDate];
    NSDate *localeDate = [todayDate  dateByAddingTimeInterval: interval];
    NSString *dateStr = [NSString stringWithFormat:@"%@",localeDate];
    return dateStr;
}
/**
 *  获取当前毫秒
 */
- (NSString *)getTimeNow
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    double i=time;      //NSTimeInterval返回的是double类型
//    NSLog(@"1970timeInterval:%f",i);
    return [NSString stringWithFormat:@"%.0lf",i];
}
#pragma mark - SandBox存取数据
- (void)saveTheDataToCachesWithData:(id)data toThePlistFile:(NSString *)fileName
{
    //获取沙盒目录，PS，这里包括以下目录均为Caches，可以修改的
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSLog(@"==%@",paths);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Caches 目录未找到");
        return;
    }
    NSArray *array = [[NSArray alloc] initWithObjects:data,nil];
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [array writeToFile:filePath atomically:YES];
}
- (NSArray *)readTheDataFromCachesFromPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    return array;
}
@end
