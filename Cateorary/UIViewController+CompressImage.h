//
//  UIViewController+CompressImage.h
//  xingtongbeidou
//
//  Created by 孙宇 on 16/2/3.
//  Copyright © 2016年 mac mini01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CompressImage)

/*
 *
 *  压缩图片至目标尺寸
 *
 *  @param sourceImage 源图片
 *  @param targetWidth 图片最终尺寸的宽
 *
 *  @return 返回按照源图片的宽、高比例压缩至目标宽、高的图片
 */
- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

@end
