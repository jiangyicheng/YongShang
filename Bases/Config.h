//
//  Config.h
//  TianjinBoHai
//
//  Created by 李莹 on 15/1/16.
//  Copyright (c) 2015年 Binky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark --------log

/**
 *  风格橙色
 */
extern NSString *orangeColor;

#define VOTETEXTCOLOR [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1]
//打印方法名，行数
#ifdef DEBUG
#   define DLOG(fmt, ...) NSLog((@"********\n%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLOG(...)
#endif

//debug log
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define DLogRect(rect)  DLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y,rect.size.width, rect.size.height)
#   define DLogPoint(pt) DLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)
#   define DLogSize(size) DLog(@"%s w=%f, h=%f", #size, size.width, size.height)
#   define DLogColor(_COLOR) DLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)
#   define DLogSuperViews(_VIEW) { for (UIView* view = _VIEW; view; view = view.superview) { GBLog(@"%@", view); } }
#   define DLogSubViews(_VIEW) \
{ for (UIView* view in [_VIEW subviews]) { GBLog(@"%@", view); } }
#   else
#   define DLog(...)
#   define DLogRect(rect)
#   define DLogPoint(pt)
#   define DLogSize(size)
#   define DLogColor(_COLOR)
#   define DLogSuperViews(_VIEW)
#   define DLogSubViews(_VIEW)
#   endif

#define DEF_SUCESS_CODE @"yes"
#define DEF_ERROR_CODE @"no"

#define DOBJ(obj)  DLOG(@"%s: %@", #obj, [(obj) description])
//当前方法和行数
#define MARK    NSLog(@"********%@\nMARK: %s, %d",[self class] , __PRETTY_FUNCTION__, __LINE__)
//输出日志
#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)

#ifdef DEBUG

/// DEBUG模式下进行调试打印

#define DEF_DEBUG(...)   NSLog(__VA_ARGS__)

#else

#define DEF_DEBUG(...)   {}

#endif
//5S宽高比例

#define WIDTH_5S_SCALE 320.0 * [UIScreen mainScreen].bounds.size.width
#define HEIGHT_5S_SCALE 568.0 * [UIScreen mainScreen].bounds.size.height

#define WIDTH_4S_SCALE 568.0 * 480.0

//通用字号
#define DEF_FontSize_25 globalFont(25.0/WIDTH_5S_SCALE)
#define DEF_FontSize_18 globalFont(18.0/WIDTH_5S_SCALE)
#define DEF_FontSize_17 globalFont(17.0/WIDTH_5S_SCALE)
#define DEF_FontSize_16 globalFont(16.0/WIDTH_5S_SCALE)
#define DEF_FontSize_15 globalFont(15.0/WIDTH_5S_SCALE)
#define DEF_FontSize_14 globalFont(14.0/WIDTH_5S_SCALE)
#define DEF_FontSize_13 globalFont(13.0/WIDTH_5S_SCALE)
#define DEF_FontSize_12 globalFont(12.0/WIDTH_5S_SCALE)
#define DEF_FontSize_11 globalFont(11.0/WIDTH_5S_SCALE)
#define DEF_FontSize_10 globalFont(10.0/WIDTH_5S_SCALE)
#define DEF_FontSize_9 globalFont(9.0/WIDTH_5S_SCALE)
#define DEF_FontSize_8 globalFont(8.0/WIDTH_5S_SCALE)

//屏幕宽高

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



@interface Config : NSObject
UIColor* getColor(NSString * hexColor);

//字号调整

UIFont * globalFont(CGFloat size);

//获取真实比例

CGFloat getNumWithScanf(CGFloat measureNum);

@end
