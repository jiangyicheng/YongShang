//
//  ChatMessageTableViewCell.m
//  YongShang
//
//  Created by 姜易成 on 16/9/5.
//  Copyright © 2016年 姜易成. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "ArrowLeftView.h"
#import "ArrowRightView.h"

@interface ChatMessageTableViewCell ()
{
    UILabel* _timeLab;
    UIImageView* _iconView;
    UIButton* _textView;
}

@property(nonatomic,strong)ArrowLeftView* leftArrow;
@property(nonatomic,strong)ArrowRightView* rightArrow;

@end

@implementation ChatMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        _timeLab = [[UILabel alloc]init];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.textColor = getColor(@"c1c1c1");
        _timeLab.font = DEF_FontSize_10;
        [self.contentView addSubview:_timeLab];
        
        _iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 8;
        _textView.titleLabel.font = DEF_FontSize_12;
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding-5, textPadding, textPadding-5, textPadding);
        [self.contentView addSubview:_textView];

    }
    return self;
}

-(ArrowLeftView *)leftArrow
{
    if (!_leftArrow) {
        _leftArrow = [[ArrowLeftView alloc]init];
        _leftArrow.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_leftArrow];
    }
    return _leftArrow;
}

-(ArrowRightView *)rightArrow
{
    if (!_rightArrow) {
        _rightArrow = [[ArrowRightView alloc]init];
        _rightArrow.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_rightArrow];
    }
    return _rightArrow;
}

-(void)setCellFrame:(CellFrameModel *)cellFrame
{
    self.rightArrow.hidden = NO;
    self.leftArrow.hidden = NO;
    self.rightArrow.frame = cellFrame.arrowFrame;
    self.leftArrow.frame = cellFrame.arrowFrame;
    _cellFrame = cellFrame;
    MessageModel* message = cellFrame.message;
    
    _timeLab.frame = cellFrame.timeFrame;
    _timeLab.text = message.time;
    
    _iconView.frame = cellFrame.iconFrame;
    NSString* iconStr = message.type ? self.headImageUrl : [UserModel shareInstanced].icon;
//    NSLog(@"---%@---%@",self.headImageUrl,[UserModel shareInstanced].icon);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"noPerson"] options:SDWebImageAllowInvalidSSLCertificates];;
    
    if (message.type) {
        self.rightArrow.hidden = YES;
    }
    else{
        self.leftArrow.hidden = YES;
    }
    
    _textView.frame = cellFrame.textFrame;
//    NSString* textBg = message.type ? @"other_talk" : @"me_talk";
    UIColor* textColor = message.type ? getColor(@"333333") : getColor(@"333333");
    UIColor* textBgColor = message.type ? getColor(@"ffffff") : getColor(@"ceedfc");
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundColor:textBgColor];

    if ([message.messageType isEqualToString:@"0"]) {
        if ([self imageData:message.text].count > 0) {
            NSMutableAttributedString *string = [self findImage:message.text];
            [_textView setAttributedTitle:string forState:UIControlStateNormal];
        }else{
            [_textView setTitle:message.text forState:UIControlStateNormal];
        }
    }else if([message.messageType isEqualToString:@"1"]){
//        [_textView setBackgroundImage:[UIImage imageNamed:@"loadFailed"] forState:UIControlStateNormal];
        UIImageView* image = [[UIImageView alloc]initWithFrame:cellFrame.textFrame];
        [image sd_setImageWithURL:[NSURL URLWithString:message.text] placeholderImage:nil];
        image.layer.cornerRadius = 8;
        image.layer.masksToBounds = YES;
        [self.contentView addSubview:image];
//        [_textView setBackgroundImage:[self BaseChangeToImage:message.text] forState:UIControlStateNormal];
    }
    
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = (_iconView.frame.size.width)/2;
    
}

//base64字符串转成UIImage图片
-(UIImage*)BaseChangeToImage:(NSString*)baseString
{
    NSData* _imageData = [[NSData alloc]initWithBase64EncodedString:baseString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage* _decodeImage = [UIImage imageWithData:_imageData];
    return _decodeImage;
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
        attch.bounds = CGRectMake(0, -2 , getNumWithScanf(25), getNumWithScanf(25));
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributeString replaceCharactersInRange:range withAttributedString:string];
        NSRange ranges = NSMakeRange(0, attributeString.length);
        NSDictionary *attributes = @{NSFontAttributeName:DEF_FontSize_12};
        [attributeString addAttributes:attributes range:ranges];
    }
    
    return attributeString;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
