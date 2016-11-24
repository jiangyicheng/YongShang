//
//  FaceKeyBoardView.m
//  自定义键盘
//
//  Created by 姜易成 on 16/8/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "FaceKeyBoardView.h"
#import "Config.h"
#import "FaceView.h"
//1.－－－将数字转为
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
#define maxCol 4

@interface FaceKeyBoardView ()<UIScrollViewDelegate>
{
    NSInteger page;
    NSArray* _dataArray;
    UIPageControl* _pageControl;
    UIButton* _deletBtn;
    UIButton* _sendBtn;
}
@property(nonatomic,strong)UIScrollView* scrollView;
@end

@implementation FaceKeyBoardView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _dataArray = [self defaultEmoticons];
//        //确定页数
//        page = _dataArray.count / 12;
//        NSInteger count = _dataArray.count % 12;
//        if (count != 0) {
//            page = page + 1;
//        }
//        page = 1;
        [self addSubview:self.scrollView];
    }
    return self;
}

//获取默认表情数组
- (NSArray *)defaultEmoticons {

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Image" ofType:@"plist"];
    NSArray *headers = [NSArray arrayWithContentsOfFile:path];
    
    if (headers.count == 0) {
        NSLog(@"访问的plist文件不存在");
    }
    else
    {
        //调用headers方法显示表情
        [self header:headers];
    }

    return headers;
}

//负责把查出来的图片显示
-(void) header:(NSArray *)headers
{
    [_scrollView removeFromSuperview];

    
    NSMutableArray *nameArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *textArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary *dict in headers) {
        [nameArr addObject:[dict objectForKey:@"ImageName"]];
        [textArr addObject:[dict objectForKey:@"ImageText"]];
    }

    page = nameArr.count / 12;
    NSInteger count = nameArr.count % 12;
    if (count != 0) {
        page = page + 1;
    }
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(15), SCREEN_WIDTH, getNumWithScanf(255))];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*page, getNumWithScanf(255));
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    
    CGFloat scrollHeight = (self.frame).size.height - 30;
    
    //根据图片量来计算scrollView的Contain的宽度
//    CGFloat width = (headers.count/(scrollHeight/30))*30;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, scrollHeight);
    _scrollView.pagingEnabled = YES;
    
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = SCREEN_WIDTH/4;
    CGFloat btnH = getNumWithScanf(255/3);
    for (int j = 0; j < page; j++) {
        NSInteger count;
        if (j != page-1) {
            count = (j+1)*12;
        }else{
            count = headers.count;
        }
        
        for (NSInteger i = j*12; i < count; i++) {
            
            //获取图片信息
            UIImage *image;
            if ([nameArr[i] isKindOfClass:[NSString class]])
            {
                image = [UIImage imageNamed:nameArr[i]];
            }else
            {
                image = nameArr[i];
            }
            
            NSString *imageText = textArr[i];
            
            NSInteger col = (i-(j*12))%maxCol;
            NSInteger row = (i-(j*12))/maxCol;
            btnX = (j*self.bounds.size.width)+col*(btnW) + SCREEN_WIDTH/8 -15;
            btnY = row*(btnH)+(getNumWithScanf(255/6)-15);
            FaceView *face = [[FaceView alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
            [face setImage:image ImageText:imageText];
            [_scrollView addSubview:face];
            
            //face的回调，当face点击时获取face的图片
            __weak __block FaceKeyBoardView *copy_self = self;
            [face setFaceBlock:^(UIImage *image, NSString *imageText)
             {
                 copy_self.block(image, imageText);
             }];
        }
    }
    
//    //图片坐标
//    CGFloat x = 0;
//    CGFloat y = 0;
//    NSLog(@"face--%@",nameArr);
//    //往scroll上贴图片
//    for (int i = 0; i < nameArr.count; i ++) {
//        //获取图片信息
//        UIImage *image;
//        if ([nameArr[i] isKindOfClass:[NSString class]])
//        {
//            image = [UIImage imageNamed:nameArr[i]];
//        }else
//        {
//            image = nameArr[i];
//        }
//        
//        NSString *imageText = textArr[i];
//        
//        //计算图片位置
//        y = (i%(int)(scrollHeight/30)) * 40;
//        x = (i/(int)(scrollHeight/30)) * (self.frame.size.width / 4) + (self.frame.size.width / 4 - 30) / 2;
////        x = (self.frame.size.width - 120) / 5 * i + (self.frame.size.width - 120) / 5;
//        
//        FaceView *face = [[FaceView alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
//        face.backgroundColor = [UIColor redColor];
//        [face setImage:image ImageText:imageText];
//        
//        //face的回调，当face点击时获取face的图片
//        __weak __block FaceKeyBoardView *copy_self = self;
//        [face setFaceBlock:^(UIImage *image, NSString *imageText)
//         {
//             copy_self.block(image, imageText);
//         }];
//        
//        
//    }

    [_scrollView setNeedsDisplay];
    
}

-(void)setFunctionBlock:(FunctionBlock)block
{
    self.block = block;
}

//-(UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getNumWithScanf(30), SCREEN_WIDTH, 120)];
//        _scrollView.pagingEnabled = YES;
//        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*page, 120);
//        _scrollView.showsHorizontalScrollIndicator = NO;

//        CGFloat btnX = 0;
//        CGFloat btnY = 0;
//        CGFloat btnW = self.bounds.size.width/7;
//        CGFloat btnH = getNumWithScanf(55);
//        for (int j = 0; j < page; j++) {
//            NSInteger count;
//            if (j != page-1) {
//                count = (j+1)*21;
//            }else{
//                count = _dataArray.count;
//            }
//            
//        for (NSInteger i = j*21; i < count; i++) {
//            UIButton* faceButton = [[UIButton alloc]init];
//            [faceButton setTitle:_dataArray[i] forState:UIControlStateNormal];
//                    
//            NSInteger col = (i-(j*21))%maxCol;
//            NSInteger row = (i-(j*21))/maxCol;
//            btnX = (j*self.bounds.size.width)+col*(btnW);
//            btnY = row*(btnH);
//            faceButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
//            [faceButton addTarget:self action:@selector(faceButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
//            [_scrollView addSubview:faceButton];
//        }
//        }
        
        
//        _scrollView.pagingEnabled = YES;
//        _scrollView.delegate = self;
//        
//        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 75 , getNumWithScanf(195), 150, getNumWithScanf(90))];
//        _pageControl.numberOfPages = page;
//        _pageControl.pageIndicatorTintColor = getColor(@"bbbbbb");
//        _pageControl.currentPageIndicatorTintColor = getColor(@"999999");
//        [self addSubview:_pageControl];
//        
//        //发送表情按钮
//        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - getNumWithScanf(80), getNumWithScanf(217), getNumWithScanf(70), getNumWithScanf(45))];
//        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//        _sendBtn.titleLabel.font = DEF_FontSize_12;
//        _sendBtn.layer.masksToBounds = YES;
//        _sendBtn.layer.cornerRadius = 5;
//        [_sendBtn addTarget:self action:@selector(sendbtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_sendBtn setBackgroundColor:getColor(@"3fbefc")];
//        [self addSubview:_sendBtn];
//        
//        //删除表情按钮
//        _deletBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - getNumWithScanf(180), getNumWithScanf(217), getNumWithScanf(70), getNumWithScanf(45))];
//        [_deletBtn setTitle:@"删除" forState:UIControlStateNormal];
//        _deletBtn.titleLabel.font = DEF_FontSize_12;
//        _deletBtn.layer.masksToBounds = YES;
//        _deletBtn.layer.cornerRadius = 5;
//        [_deletBtn addTarget:self action:@selector(deletbtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_deletBtn setBackgroundColor:getColor(@"3fbefc")];
//        [self addSubview:_deletBtn];
//    }
//    return _scrollView;
//}

-(void)faceButtonDidClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(faceDidSelected:)]) {
        [self.delegate faceDidSelected:btn];
    }
}

-(void)sendbtnDidClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(sendFace:)]) {
        [self.delegate sendFace:btn];
    }
}

-(void)deletbtnDidClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(deletFace:)]) {
        [self.delegate deletFace:btn];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        _pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
