//
//  JYCDropDownMenuView.h
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYCDropDownMenuDelegate <NSObject>

@optional
-(void)dropDownMenuDidClick:(BOOL)opened andSelf:(UIView*)selfView;
-(void)tableViewDidSelect;

@end

@interface JYCDropDownMenuView : UIView

/**
 *  选中后显示文字的lable
 */
@property(nonatomic,strong)UILabel* titleLab;

/**
 *  菜单标题的字体大小
 */
@property (nonatomic,strong) UIFont* menuTitleFont;

/**
 *  下拉列表字体的大小
 */
@property (nonatomic,strong) UIFont* tableTitleFont;

/**
 *  下拉列表的高度
 */
@property (nonatomic) CGFloat cellHeight;

/**
 *  是否打开
 */
@property (nonatomic) BOOL isOpened;

/**
 *  列表显示数组的第几项数据
 */
@property (nonatomic) NSInteger selectIndex;

/**
 *  list展示行数
 */
@property (nonatomic) NSInteger NumOfRow;

@property (nonatomic,assign) id<JYCDropDownMenuDelegate> delegate;

- (void)createOneMenuTitleArray:(NSArray *)menuTitleArray;
-(void)hideDropDownList;

@end
