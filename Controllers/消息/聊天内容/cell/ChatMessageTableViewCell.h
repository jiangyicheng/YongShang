//
//  ChatMessageTableViewCell.h
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellFrameModel;

@interface ChatMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) CellFrameModel* cellFrame;
@property (nonatomic,strong) NSString* headImageUrl;

@end
