//
//  MBProgressHUD+JYC.h
//  MBProgressHUD使用方法
//
//  Created by 姜易成 on 16/10/19.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (JYC)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
