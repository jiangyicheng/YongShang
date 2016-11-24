//
//  BaseTableViewController.h
//  WNWJ
//
//  Created by 李莹 on 15/6/15.
//  Copyright (c) 2015年 Blue Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "UIViewController+DismissKeyboard.h"
//#import <MJRefresh.h>
//#import "ConfigUniversal.h"
//#import "UIViewController+DismissKeyboard.h"

@interface BaseTableViewController : UITableViewController

@property (nonatomic, strong) NSString *pageTime;
- (void) showMessage:(NSString*)message;

/**
 *  显示错误的code码和信息
 *
 *  @param code    返回的code码
 *  @param message 返回的信息
 */
- (void) failureWithStatus:(NSString*)Status message:(NSString*)message;
/**
 *  显示错误信息
 *
 *  @param error 返回的错误信息
 */
- (void) showError:(NSError*)error;
/**
 *  通用提示框
 */
-(void)showAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message andButtonName:(NSString*)btnName;

/**
 *  显示大菊花
 */
-(void)showprogressHUD;
/**
 *  隐藏大菊花
 */
-(void)hiddenProgressHUD;
/**
 *  获取现在时间
 *
 *  @return 返回现在时间字符串
 */
- (NSString *)nowTime;
/**
 *  获取当前毫秒
 */
- (NSString *)getTimeNow;
/**
 *  通过文件名读取沙盒中Plist文件
 *
 *  @param fileName 文件名
 *
 */
- (NSArray *)readTheDataFromCachesFromPlistFile:(NSString *)fileName;
/**
 *  通过文件名将数据存入沙盒中Plist文件
 *
 *  @param data     要存入的数据
 *  @param fileName 文件名
 */
- (void)saveTheDataToCachesWithData:(id)data toThePlistFile:(NSString *)fileName;

@end
