//
//  MyTabBarViewController.m
//  XinChengOA
//
//  Created by 姜易成 on 16/7/14.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "YongShangMainViewController.h"
#import "GongQiuMainViewController.h"
#import "MessageMainViewController.h"
#import "ShuoshuoMainViewController.h"
#import "MyNavViewController.h"

@interface MyTabBarViewController ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    
    
}

-(void)setAppViewController:(UIViewController *)AppViewController
{
    _AppViewController = AppViewController;
    YongShangMainViewController* yongShangVc = [[YongShangMainViewController alloc]init];
    yongShangVc.AppViewController = self.AppViewController;
    [self addChildVC:yongShangVc title:@"甬商" image:@"yongshangLabNormal" selectImage:@"yongshangLabSelect"];
    GongQiuMainViewController* gongQiuVc = [[GongQiuMainViewController alloc]init];
    [self addChildVC:gongQiuVc title:@"供求" image:@"gongqiuLabNormal" selectImage:@"gomhqiuLabSelected"];
    
    [self addChildVC:[[MessageMainViewController alloc]init] title:@"消息" image:@"xiaoxiLabNormal" selectImage:@"xiaoxiLabSelect"];
    ShuoshuoMainViewController* shuoShuoVc = [[ShuoshuoMainViewController alloc]init];
    //    myVc.tabBarItem.badgeValue = @"8";
    [self addChildVC:shuoShuoVc title:@"说说" image:@"shuoshuoLabNormal" selectImage:@"shuoshuoSelected"];
    self.delegate = self;
}

#pragma mark - 添加子视图

-(void)addChildVC:(UIViewController* )childVC title:(NSString*)title image:(NSString*)image selectImage:(NSString*)selectImg
{
    //子视图的文字
    childVC.title = title;
    //设置子视图Item的图片
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中图片
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置文字样式
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:getColor(@"3fbefc")} forState:UIControlStateSelected];
    
    //子视图包装导航栏
    MyNavViewController* nav = [[MyNavViewController alloc]initWithRootViewController:childVC];
    [childVC.navigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    childVC.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self addChildViewController:nav];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([[UserModel shareInstanced].userType integerValue] == 0) {
        if (viewController == self.viewControllers[1] || viewController == self.viewControllers[3]) {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有访问权限" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
            
            return NO;
        }
    }
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
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
