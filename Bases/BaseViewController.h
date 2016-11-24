//
//  BaseViewController.h
//  XinChengOA
//
//  Created by 姜易成 on 16/7/14.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "UIViewController+DismissKeyboard.h"
@interface BaseViewController : UIViewController

/**
 *  显示大菊花
 */
-(void)showprogressHUD;
/**
 *  隐藏大菊花
 */
-(void)hiddenProgressHUD;

//根据字的个数确定labe的高
- (CGFloat)kdetailTextHeight:(NSString *)text width:(CGFloat)width;

/**
 *  时间戳转日期
 *
 *  @param string 时间戳
 *
 *  @return 日期string
 */
-(NSString*)exChangeStringToDate:(NSString*)string;

/**
 *  导航栏标题
 *
 *  @param title 标题名称
 */
-(void)NavTitle:(NSString*)title;

/**
 *  显示弹出信息
 *
 *  @param message message
 */
- (void)showMessage:(NSString*)message;

/**
 *  显示弹出信息（马上消失）
 *
 *  @param message message
 */
-(void)showTemplantMessage:(NSString*)message;

/**
 *  提示框
 */
-(void)setAlertTitle:(NSString*)title andMessage:(NSString*)message andBtnName:(NSString*)btnName;

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
