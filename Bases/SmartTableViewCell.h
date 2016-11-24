//
//  SmartTableViewCell.h
//  PaintingAddiction
//
//  Created by 李莹 on 14-4-8.
//  Copyright (c) 2014年 Binly Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartTableViewCell : UITableViewCell
+ (id) cellForTableView:(UITableView*)tableView;
+ (NSString*)cellIdentifier;
- (id) initWithCellIdentifier:(NSString*)cellID;
+ (CGFloat) heightForCellWithContent:(id)content;
- (NSMutableAttributedString *) changeStringColorWithPlaceString:(NSString *)placeString changeColorString:(NSString*)changeColorString color:(NSString *)color;
- (CGFloat)kdetailTextHeight:(NSString *)text width:(CGFloat)width;
@end
