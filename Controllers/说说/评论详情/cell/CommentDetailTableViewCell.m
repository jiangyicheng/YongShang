//
//  CommentDetailTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/7.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "CommentDetailTableViewCell.h"

@interface CommentDetailTableViewCell ()

{
    UIView* _lineView;
}

@end

@implementation CommentDetailTableViewCell

- (NSAttributedString *)setLabelLineSpace:(CGFloat)lineSpace text:(NSString *)text{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [text length])];
    [attributedString  addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];
    [attributedString  addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [text length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    return attributedString;
}

-(void)setCommentModel:(SSTalkTalkCommonDetailModel *)commentModel
{
    _commentModel = commentModel;
    
    NSLog(@"%@",_commentModel.message);
    NSString* mainBussinessStr = commentModel.message;
    mainBussinessStr = [mainBussinessStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    if ([self imageData:mainBussinessStr].count > 0) {
        NSMutableAttributedString *string = [self findImage:mainBussinessStr];
        
        [_commentContentLab setAttributedText:string];
    }else{
        _commentContentLab.text = mainBussinessStr;
    }

    [self.personImage sd_setImageWithURL:[NSURL URLWithString:commentModel.headimageurl] placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];
    self.companyNameLab.text = commentModel.linkman;
    NSString* timeStr = [self timeWithTimeIntervalString:commentModel.createtime];
    _dateLab.text = [NSString stringWithFormat:@"%@",timeStr];
    
    [self setupAutoHeightWithBottomView:_lineView bottomMargin:0];
}

- (void)awakeFromNib {
    
    //添加长安手势
    UILongPressGestureRecognizer* longTouch = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTouchTheCell:)];
    longTouch.minimumPressDuration = 0.7;
    [self addGestureRecognizer:longTouch];
    
    self.companyNameLab.font = DEF_FontSize_11;
    self.commentContentLab.font = DEF_FontSize_12;
    self.commentContentLab.numberOfLines = 0;
    
    self.dateLab.font = DEF_FontSize_11;
    self.dateLab.textAlignment = NSTextAlignmentRight;
    
    _lineView = [UIView new];
    _lineView.backgroundColor = getColor(@"dddddd");
    [self.contentView addSubview:_lineView];
    
    self.commentImageView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,getNumWithScanf(30))
    .widthIs(getNumWithScanf(30))
    .heightEqualToWidth(0);
    
    self.personImage.sd_layout
    .centerYEqualToView(self.commentImageView)
    .leftSpaceToView(self.commentImageView,10)
    .widthIs(getNumWithScanf(52))
    .heightEqualToWidth(0);
    
    self.dateLab.sd_layout
    .topSpaceToView(self.contentView,getNumWithScanf(20))
    .rightSpaceToView(self.contentView,getNumWithScanf(5))
    .widthIs(getNumWithScanf(260))
    .heightIs(getNumWithScanf(22));
    
    self.companyNameLab.sd_layout
    .topSpaceToView(self.contentView,getNumWithScanf(20))
    .leftSpaceToView(self.personImage,10)
    .heightIs(getNumWithScanf(22))
    .rightSpaceToView(self.contentView,getNumWithScanf(5));
    
    self.commentContentLab.sd_layout
    .topSpaceToView(self.companyNameLab,getNumWithScanf(8))
    .leftEqualToView(self.companyNameLab)
    .rightSpaceToView(self.contentView,getNumWithScanf(5))
    .autoHeightRatio(0);
    
    _lineView.sd_layout
    .leftEqualToView(self.commentContentLab)
    .rightSpaceToView(self.contentView,0)
    .heightIs(0.5)
    .topSpaceToView(self.commentContentLab,5);
    
    self.personImage.layer.masksToBounds = YES;
    self.personImage.layer.cornerRadius = (self.personImage.frame.size.width/2);

}

-(void)longTouchTheCell:(UILongPressGestureRecognizer*)longTouch
{
    if ([self.delegate respondsToSelector:@selector(longTouchTheCommentWithCell:andGesture:)]) {
        [self.delegate longTouchTheCommentWithCell:self andGesture:longTouch];
    }
}

//查看聊天消息中是否有表情
- (NSArray *)imageData:(NSString *)text{
    
    //    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSString *str = @"\\[[^\\[\\]]*\\]";
    NSError *error = nil;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:str
                                                                             options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *resultArr = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    return resultArr;
    
}

- (NSMutableAttributedString *)findImage:(NSString *)text{
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"[笑]", @"[冷漠]", @"[皱眉]", @"[沮丧]",
                      @"[惊讶]", @"[哭笑]", @"[汗]", @"[亲]", @"[心]", @"[碎]", @"[蜡烛]", @"[花]", nil];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Image" ofType:@"plist"];
    NSArray *headers = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *textArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (NSDictionary *dict in headers) {
        [nameArr addObject:[dict objectForKey:@"ImageName"]];
        [textArr addObject:[dict objectForKey:@"ImageText"]];
    }
    
    NSArray *resultArr = [self imageData:text];
    
    for (NSInteger i = 0; i  < [resultArr count]; ++i) {
        NSTextCheckingResult *result = resultArr[i];
        NSRange range =  [result range];
        NSString *subStr = [text substringWithRange:range];
        
        for (int j = 0; j < [array count]; j ++) {
            if ([subStr isEqualToString:[array objectAtIndex:j]]) {
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [imageDic setObject:[nameArr objectAtIndex:j] forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [imageArray addObject:imageDic];
            }
        }
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:text];
    for (NSInteger i = [imageArray count]-1; i>=0; i--) {
        NSDictionary *dic = imageArray[i];
        NSRange range = [dic[@"range"] rangeValue];
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        // 设置图片大小
        attch.bounds = CGRectMake(0, -1.5, getNumWithScanf(20), getNumWithScanf(20));
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributeString replaceCharactersInRange:range withAttributedString:string];
        NSRange ranges = NSMakeRange(0, attributeString.length);
        NSDictionary *attributes = @{NSFontAttributeName:DEF_FontSize_12};
        [attributeString addAttributes:attributes range:ranges];
    }
    
    return attributeString;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
