//
//  BaseViewController.m
//  XinChengOA
//
//  Created by 姜易成 on 16/7/14.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "BaseViewController.h"
#import "Config.h"

@interface BaseViewController ()
{
    UIView *alertView;
    UIView* blackView;
}
@property(nonatomic,strong) MBProgressHUD* progressHUD;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getColor(@"f7f7f7")];
    [self.navigationController.navigationBar setBarTintColor:getColor(@"3fbefc")];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:DEF_FontSize_14,NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self setupForDismissKeyboard];
}

-(MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
        _progressHUD.labelText = @"正在加载";
    }
    return _progressHUD;
}

-(void)showprogressHUD{
    [self.navigationController.view addSubview:self.progressHUD];
    [_progressHUD show:YES];
}

-(void)hiddenProgressHUD{
    [_progressHUD hide:YES];
    [self.progressHUD removeFromSuperview];
}

/**
 *  时间戳转日期
 *
 *  @param string 时间戳
 *
 *  @return 日期string
 */
-(NSString*)exChangeStringToDate:(NSString*)string
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateStyle:NSDateFormatterMediumStyle];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    string = [string substringWithRange:NSMakeRange(0, string.length - 3)];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string integerValue]];
    NSString* strs = [dateformatter stringFromDate:confromTimesp];
    return strs;
}

/**
 *  导航栏标题
 *
 *  @param title 标题名称
 */
-(void)NavTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

/**
 *  提示框
 */
-(void)setAlertTitle:(NSString*)title andMessage:(NSString*)message andBtnName:(NSString*)btnName
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:btnName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

//根据字的个数确定labe的高
- (CGFloat)kdetailTextHeight:(NSString *)text width:(CGFloat)width{
    
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :DEF_FontSize_13} context:nil];
    return rectToFit.size.height;
}

-(void)showTemplantAlertViewWithTitle:(NSString*)title
{
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, [self kdetailTextHeight:title width:SCREEN_WIDTH - 50] + 40)];
    
    alertView.backgroundColor = [UIColor whiteColor];
    blackView = [[UIView alloc]initWithFrame:CGRectOffset(self.navigationController.view.frame, 0, 0)];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    alertView.center = blackView.center;
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, CGRectGetWidth(alertView.frame) - 30, [self kdetailTextHeight:title width:SCREEN_WIDTH - 50] + 40)];
    titleLabel.text = title;
    titleLabel.textColor = getColor(@"595959");
    titleLabel.font = DEF_FontSize_12;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [alertView addSubview:titleLabel];
    
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    //    [self.navigationController.view addSubview:blackView];
    [blackView addSubview:alertView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    
    });
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
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
    
    
   
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

-(void)showTemplantMessage:(NSString *)message
{
    [self showTemplantAlertViewWithTitle:message];
}

#pragma mark - SandBox存取数据

- (void)saveTheDataToCachesWithData:(id)data toThePlistFile:(NSString *)fileName
{
    //获取沙盒目录，PS，这里包括以下目录均为Caches，可以修改的
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSLog(@"==%@",paths);
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
