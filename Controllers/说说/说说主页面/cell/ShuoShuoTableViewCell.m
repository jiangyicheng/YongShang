//
//  ShuoShuoTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/6.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ShuoShuoTableViewCell.h"
#import "SDWeiXinPhotoContainerView.h"

@interface ShuoShuoTableViewCell ()
{
    SDWeiXinPhotoContainerView* _photoView;
}
@end

@implementation ShuoShuoTableViewCell

- (void)awakeFromNib {
    
    self.nameAndCompanyLab.font = DEF_FontSize_12;
//    self.nameAndCompanyLab.numberOfLines = 1;
    self.dateLab.font = DEF_FontSize_11;
    self.dateLab.text = @"昨天";
    self.contentLab.font = DEF_FontSize_12;
    self.deleteBtn.titleLabel.font = DEF_FontSize_12;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* touchIconView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTheIconView)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:touchIconView];
    
    _photoView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:_photoView];
    
    _commentAndPrise = [CommentAndPriseView new];
    [self.contentView addSubview:_commentAndPrise];
    
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView,getNumWithScanf(20))
    .topSpaceToView(self.contentView,getNumWithScanf(20))
    .widthIs(getNumWithScanf(82))
    .heightEqualToWidth();
    
    self.nameAndCompanyLab.sd_layout
    .topSpaceToView(self.contentView,getNumWithScanf(25))
    .leftSpaceToView(self.iconView,getNumWithScanf(20))
    .rightSpaceToView(self.contentView,getNumWithScanf(70))
    .autoHeightRatio(0);
    
    self.dateLab.sd_layout
    .leftEqualToView(self.nameAndCompanyLab)
    .topSpaceToView(self.nameAndCompanyLab,getNumWithScanf(5))
    .heightIs(getNumWithScanf(22))
    .widthIs(160);
    
    self.contentLab.sd_layout
    .leftSpaceToView(self.contentView,getNumWithScanf(20))
    .topSpaceToView(self.iconView,10)
    .rightSpaceToView(self.contentView,getNumWithScanf(20))
    .autoHeightRatio(0);
    
    _photoView.sd_layout
    .leftEqualToView(self.contentLab);
    
    self.deleteBtn.sd_layout
    .rightSpaceToView(self.contentView,getNumWithScanf(5))
    .topSpaceToView(self.contentView,getNumWithScanf(15))
    .widthIs(getNumWithScanf(60))
    .heightIs(getNumWithScanf(50));
    
    _commentAndPrise.sd_layout
    .leftEqualToView(self.iconView)
    .rightSpaceToView(self.contentView,getNumWithScanf(20))
    .heightIs(getNumWithScanf(70))
    .topSpaceToView(_photoView,10);
    
    [_commentAndPrise creatCommentAndPriseView];
    [_commentAndPrise.priseBtn addTarget:self action:@selector(priseBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_commentAndPrise.commentBtn addTarget:self  action:@selector(commentBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = (self.iconView.frame.size.width/2);
}

-(void)setModel:(SSAllTalkDetailModel *)model
{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];
    _contentLab.text = model.context;
    _nameAndCompanyLab.text = [NSString stringWithFormat:@"(%@)%@",model.linkman,model.companyname];
    if ([model.is_clicklike isEqualToString:@"1"]) {
        _commentAndPrise.priseBtn.selected = YES;
    }else{
        _commentAndPrise.priseBtn.selected = NO;
    }
    if ([model.is_talkmessage isEqualToString:@"1"]) {
        _commentAndPrise.commentBtn.selected = YES;
    }else
    {
        _commentAndPrise.commentBtn.selected = NO;
    }
    [_commentAndPrise.priseBtn setTitle:model.clickliketotal forState:UIControlStateNormal];
    [_commentAndPrise.commentBtn setTitle:model.messagetotal forState:UIControlStateNormal];
   
    NSString* timeStr = [self timeWithTimeIntervalString:model.createtime];
    _dateLab.text = [NSString stringWithFormat:@"%@",timeStr];
    
    if (!([model.quid integerValue] == [[UserModel shareInstanced].userID integerValue])) {
        _deleteBtn.hidden = YES;
    }else{
        _deleteBtn.hidden = NO;
    }
    
    NSMutableArray* imagePathsArray = [[NSMutableArray alloc]init];
    NSMutableArray* bigImagePathArray = [[NSMutableArray alloc]init];
    if ([model.imageurl1s isKindOfClass:[UIImage class]] || [model.imageurl1s isEqual:@""]) {
        if ([model.imageurl1s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl1s];
            [bigImagePathArray addObject:model.imageurl1];
        }
        if ([model.imageurl2s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl2s];
            [bigImagePathArray addObject:model.imageurl2];
        }
        if ([model.imageurl3s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl3s];
            [bigImagePathArray addObject:model.imageurl3];
        }
        if ([model.imageurl4s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl4s];
            [bigImagePathArray addObject:model.imageurl4];
        }
        if ([model.imageurl5s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl5s];
            [bigImagePathArray addObject:model.imageurl5];
        }
        if ([model.imageurl6s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl6s];
            [bigImagePathArray addObject:model.imageurl6];
        }
        if ([model.imageurl7s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl7s];
            [bigImagePathArray addObject:model.imageurl7];
        }
        if ([model.imageurl8s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl8s];
            [bigImagePathArray addObject:model.imageurl8];
        }
        if ([model.imageurl9s isKindOfClass:[UIImage class]]) {
            [imagePathsArray addObject:model.imageurl9s];
            [bigImagePathArray addObject:model.imageurl9];
        }
    }else{
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
    }
    
//    imagePathsArray = (NSMutableArray*)@[@"loadFailed"];
//    NSLog(@"---%@",imagePathsArray);
    _photoView.picPathStringsArray = imagePathsArray;
    _photoView.bigPathStringArray = bigImagePathArray;
    CGFloat picContainerTopMargin = 0;
    if (imagePathsArray.count) {
        picContainerTopMargin = 10;
    }
    _photoView.sd_layout.topSpaceToView(_contentLab,picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:_commentAndPrise bottomMargin:0];
    
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

/**
 *  说说代理协议
 */
-(void)deleteBtnDidClick
{
    if ([self.delegate respondsToSelector:@selector(deleteTalkTalkWithCell:)]) {
        [self.delegate deleteTalkTalkWithCell:self];
    }
}

-(void)priseBtnDidClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(PriseTheTalkTalkWithCell:WithBtn:)]) {
        [self.delegate PriseTheTalkTalkWithCell:self WithBtn:btn];
    }
}

-(void)commentBtnDidClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(CommentTheTalkTalkWithCell:WithBtn:)]) {
        [self.delegate CommentTheTalkTalkWithCell:self WithBtn:btn];
    }
}

-(void)touchTheIconView
{
    if ([self.delegate respondsToSelector:@selector(enterPriseDetailWithCell:)]) {
        [self.delegate enterPriseDetailWithCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
