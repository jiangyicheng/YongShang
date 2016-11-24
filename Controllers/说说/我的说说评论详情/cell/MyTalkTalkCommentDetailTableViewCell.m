//
//  MyTalkTalkCommentDetailTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/9.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "MyTalkTalkCommentDetailTableViewCell.h"
#import "SDWeiXinPhotoContainerView.h"

@interface MyTalkTalkCommentDetailTableViewCell ()
{
    SDWeiXinPhotoContainerView* _photoView;
    UILabel* _dateLab;
    UIButton* _deleteBtn;
}
@end

@implementation MyTalkTalkCommentDetailTableViewCell

- (void)awakeFromNib {
    self.contentLab.font = DEF_FontSize_12;
    self.contentLab.textColor = getColor(@"595959");
    
    _photoView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:_photoView];
    
    _dateLab = [UILabel new];
    _dateLab.text = @"07-26 12:30";
    _dateLab.textColor = getColor(@"a8a8a8");
    _dateLab.font = DEF_FontSize_11;
    [self.contentView addSubview:_dateLab];
    
    _deleteBtn = [UIButton new];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:getColor(@"3fbefc") forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = DEF_FontSize_12;
    [_deleteBtn addTarget:self action:@selector(deleteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
    self.contentLab.sd_layout
    .leftSpaceToView(self.contentView,getNumWithScanf(20))
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,getNumWithScanf(20))
    .autoHeightRatio(0);
    
    _photoView.sd_layout
    .leftEqualToView(self.contentLab);
    
    _dateLab.sd_layout
    .leftEqualToView(self.contentLab)
    .topSpaceToView(_photoView,10)
    .heightIs(getNumWithScanf(22))
    ;
    
    _deleteBtn.sd_layout
    .topEqualToView(_dateLab)
    .leftSpaceToView(_dateLab,5)
    .widthIs(getNumWithScanf(60))
    .heightIs(getNumWithScanf(26));
}

-(void)setModel:(SSTalkTalkDetailModel *)model
{
    _model = model;
    _contentLab.text = model.talkcontext;
    
    NSString* timeStr = [self timeWithTimeIntervalString:model.talkpublishtime];
    _dateLab.text = [NSString stringWithFormat:@"%@",timeStr];
    [_dateLab setSingleLineAutoResizeWithMaxWidth:getNumWithScanf(260)];
    
    NSMutableArray* imagePathsArray = [[NSMutableArray alloc]init];
    NSMutableArray* bigImagePathArray = [[NSMutableArray alloc]init];
    if (model.imageurl1s) {
        [imagePathsArray addObject:model.imageurl1s];
        [bigImagePathArray addObject:model.imageurl1];
    }
    if (model.imageurl2s) {
        [imagePathsArray addObject:model.imageurl2s];
        [bigImagePathArray addObject:model.imageurl2];
    }
    if (model.imageurl3s) {
        [imagePathsArray addObject:model.imageurl3s];
        [bigImagePathArray addObject:model.imageurl3];
    }
    if (model.imageurl4s) {
        [imagePathsArray addObject:model.imageurl4s];
        [bigImagePathArray addObject:model.imageurl4];
    }
    if (model.imageurl5s) {
        [imagePathsArray addObject:model.imageurl5s];
        [bigImagePathArray addObject:model.imageurl5];
    }
    if (model.imageurl6s) {
        [imagePathsArray addObject:model.imageurl6s];
        [bigImagePathArray addObject:model.imageurl6];
    }
    if (model.imageurl7s) {
        [imagePathsArray addObject:model.imageurl7s];
        [bigImagePathArray addObject:model.imageurl7];
    }
    if (model.imageurl8s) {
        [imagePathsArray addObject:model.imageurl8s];
        [bigImagePathArray addObject:model.imageurl8];
    }
    if (model.imageurl9s) {
        [imagePathsArray addObject:model.imageurl9s];
        [bigImagePathArray addObject:model.imageurl9];
    }
    
    _photoView.picPathStringsArray = imagePathsArray;
    _photoView.bigPathStringArray = bigImagePathArray;
    
    CGFloat picContainerTopMargin = 0;
    if (imagePathsArray.count) {
        picContainerTopMargin = 10;
    }
    _photoView.sd_layout.topSpaceToView(_contentLab,picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:_dateLab bottomMargin:10];
}

/**
 *  时间戳转换为日期
 *
 *  @param timeString 时间戳
 *
 *  @return 日期
 */
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [NSString string];
    dateString = [self compareDate:date];
    if ([dateString isEqualToString:@"昨天"]) {
        dateString = [self compareDate:date];
    }else if([dateString isEqualToString:@"今天"]){
        dateString = [self compareCurrentTime:date];
    }else{
        dateString = [formatter stringFromDate:date];
    }
    return dateString;
}

-(NSString *) compareCurrentTime:(NSDate*) compareDate
//计算指定时间与当前的时间差
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

/**
 *  判断日期为今天还是昨天
 *
 *  @param date 日期
 *
 *  @return
 */
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}


-(void)deleteBtnDidClick
{
    if ([self.delegate respondsToSelector:@selector(commentDidDelete)]) {
        [self.delegate commentDidDelete];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
