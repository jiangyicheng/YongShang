//
//  JYCDropDownMenuView.m
//  YongShang
//
//  Created by 姜易成 on 16/8/30.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "JYCDropDownMenuView.h"
#import "JYCDropDownTableViewCell.h"

@interface JYCDropDownMenuView ()<UITableViewDataSource,UITableViewDelegate>
{
//    NSIndexPath* _lastSelectIndexPath;
}
@property(nonatomic)CGFloat menuBaseHeight;
@property(nonatomic,strong)UIButton* dropDownBtn;

@property(nonatomic,strong)UITableView* dropDownTableView;
@property(nonatomic,strong)NSArray* dataArray;
//@property(nonatomic,assign,getter = isOpen) BOOL opened;

@end

@implementation JYCDropDownMenuView

//-(void)setIsOpened:(BOOL)isOpened
//{
//    _isOpened = isOpened;
//    self.menuBaseHeight = self.frame.size.height;
//    NSLog(@"isopen-----%d",isOpened);
//    CGFloat viewHeight = _isOpened ? 4 * getNumWithScanf(70) : self.menuBaseHeight ;
//    NSLog(@"isopen-----%f",viewHeight);
//    self.dropDownBtn.imageView.transform = _isOpened ?CGAffineTransformMakeRotation(M_PI):CGAffineTransformMakeRotation(0);
//    [self showDropDownListWithHeight:viewHeight];

//}

- (void)createOneMenuTitleArray:(NSArray *)menuTitleArray{
    self.isOpened = NO;
    self.menuBaseHeight = self.frame.size.height;
    self.dataArray = menuTitleArray;
    [self creatMenuWithData:menuTitleArray];
    [self creatMenuList];
}

-(void)creatMenuWithData:(NSArray*)data
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.menuBaseHeight);
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width - 15, self.menuBaseHeight)];
    self.titleLab.text = self.selectIndex ? data[self.selectIndex]:data[0];
    self.titleLab.textColor = getColor(@"595959");
    self.backgroundColor = getColor(@"ffffff");
    self.titleLab.font = self.menuTitleFont ? self.menuTitleFont : DEF_FontSize_13;
    [self addSubview:self.titleLab];
    
    self.dropDownBtn = [[UIButton alloc]initWithFrame:self.bounds];
    self.dropDownBtn.backgroundColor = [UIColor clearColor];
    [self.dropDownBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.dropDownBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width - 30, 0, 0)];
    [self.dropDownBtn addTarget:self action:@selector(dropDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dropDownBtn];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.menuBaseHeight-1, self.frame.size.width, 1)];
    lineView.backgroundColor = getColor(@"dddddd");
    [self addSubview:lineView];
}

-(void)dropDownBtnClick
{
    _isOpened = !_isOpened;
    [self ConfirmHeigthWithBool:_isOpened];
    if ([self.delegate respondsToSelector:@selector(dropDownMenuDidClick:andSelf:)]) {
        [self.delegate dropDownMenuDidClick:_isOpened andSelf:self];
    }
}

-(void)ConfirmHeigthWithBool:(BOOL)isOpen
{
    CGFloat viewHeight = isOpen ? (self.NumOfRow-1) * getNumWithScanf(70)+self.menuBaseHeight : self.menuBaseHeight ;
    self.dropDownBtn.imageView.transform = isOpen ?CGAffineTransformMakeRotation(M_PI):CGAffineTransformMakeRotation(0);
    [self showDropDownListWithHeight:viewHeight];
}

-(void)showDropDownListWithHeight:(CGFloat)viewHeight
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight);
        self.dropDownTableView.frame = CGRectMake(0, self.menuBaseHeight, self.frame.size.width, viewHeight - self.menuBaseHeight);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideDropDownList
{
    _isOpened = !_isOpened;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.menuBaseHeight);
        self.dropDownTableView.frame = CGRectMake(0, self.menuBaseHeight, self.frame.size.width, 0);
        self.dropDownBtn.imageView.transform = _isOpened ?CGAffineTransformMakeRotation(M_PI):CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)creatMenuList
{
    self.dropDownTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.menuBaseHeight, self.frame.size.width, 0) style:UITableViewStylePlain];
    self.dropDownTableView.dataSource = self;
    self.dropDownTableView.delegate = self;
    self.dropDownTableView.bounces = YES;
    self.dropDownTableView.userInteractionEnabled = YES;
    self.dropDownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.dropDownTableView registerClass:[JYCDropDownTableViewCell class] forCellReuseIdentifier:@"MyCell"];
    [self.dropDownTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex? self.selectIndex : 0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self insertSubview:self.dropDownTableView belowSubview:self.dropDownBtn];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    JYCDropDownTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[JYCDropDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.titleLab.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath == _lastSelectIndexPath) {
//        cell.backgroundColor = getColor(@"ABE5FE");
//    }
    return cell;
}


#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getNumWithScanf(70);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.titleLab.text = self.dataArray[indexPath.row];
    self.isOpened = NO;
    [self ConfirmHeigthWithBool:self.isOpened];
    
//    JYCDropDownTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = getColor(@"ABE5FE");
//    
//    if (_lastSelectIndexPath && _lastSelectIndexPath != indexPath) {
//        JYCDropDownTableViewCell* cell = [tableView cellForRowAtIndexPath:_lastSelectIndexPath];
//        cell.backgroundColor = getColor(@"ffffff");
//    }
//    _lastSelectIndexPath = indexPath;
    
    if ([self.delegate respondsToSelector:@selector(tableViewDidSelect)]) {
        [self.delegate tableViewDidSelect];
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
