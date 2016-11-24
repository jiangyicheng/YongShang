//
//  ReviewImagesViewController.m
//  tablebg
//
//  Created by 关作印 on 16/3/7.
//  Copyright © 2016年 sssss. All rights reserved.
//

#import "ReviewImagesViewController.h"
#import "UIImageView+WebCache.h"
#import "Config.h"

@interface ReviewImagesViewController()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *animationImageView;
@end
@implementation ReviewImagesViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    CGRect rect = [_rectArray[_index.row] CGRectValue];
    self.view.backgroundColor = [UIColor blackColor];
    _animationImageView = [[UIImageView alloc]initWithFrame:rect];
    _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.webImageViewArray) {
        [_animationImageView sd_setImageWithURL:[NSURL URLWithString:_webImageViewArray[_index.row]] placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];
    }else {
        _animationImageView.image = _imageArray[_index.row];
    }
    
    
    [self.view addSubview:_animationImageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _animationImageView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            if (finished) {
                [_animationImageView removeFromSuperview];
                [self setUpUI];
            }
        }];

    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

-(void)setUpUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.userInteractionEnabled = YES;
//    _scrollView.bouncesZoom = NO;
//    _scrollView.maximumZoomScale = 2;
//    _scrollView.minimumZoomScale = 0.5;
    
    _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * _index.row, 0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    _scrollView.userInteractionEnabled = YES;
    [_scrollView addGestureRecognizer:tap];
    
    if (_webImageViewArray) {
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_webImageViewArray.count, SCREEN_HEIGHT);
        for (int i = 0; i < _webImageViewArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *i , 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_webImageViewArray[i]] placeholderImage:[UIImage imageNamed:@"loadFailed"] options:SDWebImageAllowInvalidSSLCertificates];
            [_scrollView addSubview:imageView];
        }
    }else {
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_imageArray.count, SCREEN_HEIGHT);
        for (int i = 0; i < _imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *i , 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = _imageArray[i];
            [_scrollView addSubview:imageView];
        }
    }
    
    
    [self.view addSubview:_scrollView];
}

-(void)click{
    [_scrollView removeFromSuperview];
  
    NSInteger index = _scrollView.contentOffset.x/SCREEN_WIDTH;
    CGRect rect = [_rectArray[index] CGRectValue];
    if (_webImageViewArray) {
        [_animationImageView sd_setImageWithURL:[NSURL URLWithString:_webImageViewArray[index]] placeholderImage:nil];
    }else {
        _animationImageView.image = _imageArray[index];
    }
    
    [self.view addSubview:_animationImageView];
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _animationImageView.frame = rect;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

@end
