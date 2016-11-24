//
//  WelComePageViewController.m
//  YongShangTong
//
//  Created by 姜易成 on 16/10/8.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "WelComePageViewController.h"
#import "MyTabBarViewController.h"

//应用授权接口
static NSString* const APPAuthorizationUrl = @"https://portal.cjzc.net.cn/oauth/token?client_id=CJTCYST&client_secret=54FC9FFE40D6DB82&grant_type=implicit";

//用户授权接口
static NSString* const UserAuthorizationUrlPerString = @"https://portal.cjzc.net.cn/helper/oauth/me?access_token=";

//获取companyid接口
//static NSString* const GetCompanyIdUrlPerString = @"https://yst.cjzc.net.cn/cjsdys/appservice/loginapp.do?flagId=";
//static NSString* const GetCompanyIdUrlPerString = @"https://yst.cjtc.net.cn/yyht/appservice/loginapp.do?flagId=";
//static NSString* const GetCompanyIdUrlPerString = @"http://10.58.132.30:8080/cjsdys/appservice/loginapp.do?flagId=";
static NSString* const GetCompanyIdUrlPerString = @"http://118.178.58.178:8080/cjsdys/appservice/loginapp.do?flagId=";

@interface WelComePageViewController ()
{
    NSString* access_token;  //用户access_token
    NSString* UserAuthorizationUrl;
    NSString* UserToken;  //用户token
    NSString* userId;  //用户ID
    NSString* GetCompanyIdUrl;
}
@end

@implementation WelComePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    NSBundle* root_bundle = [NSBundle bundleWithPath:[UserModel shareInstanced].root_bundle];
    
    //背景图片
    UIImage* iamge = [UIImage imageNamed:@"启动页" inBundle:root_bundle compatibleWithTraitCollection:nil];
    UIImageView* bgImage = [[UIImageView alloc]initWithImage:iamge];
    bgImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:bgImage];
    
//    应用授权
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(haha) userInfo:nil repeats:NO];
    [self haha];
    [[UploadNotSuccessImage shareUpload]hahahaeithApp:self];
    NSLog(@"---%@",[UploadNotSuccessImage shareUpload].app);
}

-(void)haha
{
    [YSBLL getLoginResultBlock:^(loginModel *model, NSError *error) {
        if ([model.ecode isEqualToString:@"0"]) {
            [UserModel shareInstanced].companyId = model.createcompanyid;
            [UserModel shareInstanced].tradeId = model.tradeId;
            [UserModel shareInstanced].userID = model.userId;
            [UserModel shareInstanced].name = model.userName;
            [UserModel shareInstanced].icon = model.headimgurl;
            [UserModel shareInstanced].postName = @"cjtc0000001407@trial0167";
            [UserModel shareInstanced].userType = model.talkAndSellbuyStatus;
            NSLog(@"talkAndSellbuyStatus--%@",model.talkAndSellbuyStatus);
            NSLog(@"companyId==%@tradeId==%@userId==%@userName==%@",model.createcompanyid,model.tradeId,model.userId,model.userName);
            [[YSSocketProtocol shareSocketProtocol] socketConnect];
            [self presentNewView];
        }else if ([model.ecode isEqualToString:@"-2"]){
            NSLog(@"请求数据失败");
        }else if ([model.ecode isEqualToString:@"-1"]){
            NSLog(@"异常错误");
        }
    }];
    
}
//-(void)viewDidAppear:(BOOL)animated{
//    [self presentNewView];
//}

//应用授权
-(void)requestAPPAuthorization
{
    [[AFHTTPSessionManager manager]GET:APPAuthorizationUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        access_token = responseObject[@"access_token"];
        UserAuthorizationUrl = [UserAuthorizationUrlPerString stringByAppendingString:access_token];
        NSString* tokenUrl = [NSString string];
        
        UserToken = @"9ABB24BDA946E621D5696F9236B00AF7D890FC4A2F46BD58D68F906C858234AC0A44D361024E09067AEE4D93560EF5A2";
        tokenUrl = [@"&token=" stringByAppendingString:UserToken];
        UserAuthorizationUrl = [UserAuthorizationUrl stringByAppendingString:tokenUrl];
        
        //获取用户授权
        [[AFHTTPSessionManager manager]GET:UserAuthorizationUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"----response-%@",responseObject);
            NSNumber* resultNum = responseObject[@"result"];
            //登录失败
            if ([resultNum integerValue] == 1) {
                UIAlertController* alertController =  [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else if([resultNum integerValue] == 0){
                NSDictionary* dic = responseObject[@"data"][@"resObj"];
                //获取用户ID
                userId = dic[@"userid"];
                [UserModel shareInstanced].postName = userId;
            
//                [UserModel shareInstanced].icon = dic[@"icon"];
                [UserModel shareInstanced].sex = dic[@"sex"];
//                [UserModel shareInstanced].userType = dic[@"usertype"];
           
                //获取到获取companyid接口
                GetCompanyIdUrl = [GetCompanyIdUrlPerString stringByAppendingString:[UserModel shareInstanced].postName];
                NSLog(@"---userID---%@",[UserModel shareInstanced].postName);
            
            //获取用户companyId
            [[AFHTTPSessionManager manager]GET:[NSString stringWithFormat:@"%@&u_code=%@",GetCompanyIdUrl,[UserModel shareInstanced].postName] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary* dict = responseObject[@"data"];
                [UserModel shareInstanced].companyId = dict[@"companyid"];
                [UserModel shareInstanced].tradeId = dict[@"orgid"];
                [UserModel shareInstanced].userID = dict[@"uid"];
                [UserModel shareInstanced].name = dict[@"u_name"];
                [UserModel shareInstanced].icon = dict[@"headimgurl"];

                [self presentNewView];
                NSLog(@"companyId==%@tradeId==%@userId==%@userName==%@",[UserModel shareInstanced].companyId,[UserModel shareInstanced].tradeId,[UserModel shareInstanced].userID,[UserModel shareInstanced].name);
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                NSLog(@"+++失败");
            }];
            }
            
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                NSLog(@"+++失败");
        }];
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"----失败");
    }];
}

//跳转到主页面
-(void)presentNewView
{
//    NSString* userType = [UserModel shareInstanced].userType;
//    NSString* titleMessage;
//    if ([userType isEqualToString:@"admin"]) {
//        titleMessage = @"请您分配权限后，再进入此系统";
//    }else{
//        titleMessage = @"您没有访问权限";
//    }
//    UIAlertController* alertController =  [UIAlertController alertControllerWithTitle:@"提示" message:titleMessage preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    MyTabBarViewController* mvc = [[MyTabBarViewController alloc]init];
    mvc.AppViewController = self;
    [self presentViewController:mvc animated:YES completion:nil];
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
