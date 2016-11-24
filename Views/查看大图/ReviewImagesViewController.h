//
//  ReviewImagesViewController.h
//  tablebg
//
//  Created by 关作印 on 16/3/7.
//  Copyright © 2016年 sssss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewImagesViewController : UIViewController

@property (nonatomic,strong)NSArray *imageArray;
//如果网络图片，传网络图片数组
@property (nonatomic,strong)NSMutableArray *webImageViewArray;
//点击进入时的索引
@property (nonatomic,strong)NSIndexPath *index;
//存放所有小图的位置
@property (nonatomic, strong) NSMutableArray *rectArray;
@end
