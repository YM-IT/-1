//
//  ZFStatus.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFStatus.h"
#import "ZFUser.h"
#import "MJExtension.h"
#import "ZFPhoto.h"
#import "NSDate+Extension.h"
#import "RegexKitLite.h"
#import "ZFUser.h"
#import "ZFTextPart.h"
#import "ZFEmotion.h"
#import "ZFEmotionTool.h"
#import "ZFSpecial.h"
@implementation ZFStatus
-(NSDictionary *)objectClassInArray
{
    return @{@"pic_urls":[ZFPhoto class]};
}

//普通 ----- >属性文字
-(NSAttributedString *)attributedTextWithText:(NSString *)text
{

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    //表情规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5+]\\]";
    //@规则
    NSString *atPattern = @"@[0-9a-zA-z\\u4e00-\\u9fa5-_]+";
    //#话题#规则
    NSString *topicPattern = @"#[0-9a-zA-z\\u4e00-\\u9fa5]+#";
    //url规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@",emotionPattern,atPattern,topicPattern,urlPattern];
  
    //遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [ text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return ;
        
        ZFTextPart *part = [[ZFTextPart alloc]init];
        part.special = YES;
        
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"[" ]&& [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];

    /**遍历所有的非特殊字符*/
    
   [ text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
         if ((*capturedRanges).length == 0) return ;
        ZFTextPart *part = [[ZFTextPart alloc]init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
   }];
  
    //排序
    //系统是从小到大排序
    [parts sortUsingComparator:^NSComparisonResult(ZFTextPart *part1, ZFTextPart *part2) {
        if (part1.range.location > part2.range.location) {
            //part1 > 2  part1放后面，part2放前面
            return NSOrderedDescending;
        }
        //part1 < 2  part1放放前面，part2后面
        
        return NSOrderedAscending;
    }];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    //按顺序拼接每一段文字
    for (ZFTextPart *part in parts) {
        NSAttributedString *substr = nil;
        if (part.isemotion) {//表情
            
            NSTextAttachment *attch = [[NSTextAttachment alloc]init];
            NSString *name = [ZFEmotionTool  emotionWithChs:part.text].png;
            if (name) {//能找到对应图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            }else{//找不到对应图片
                substr = [[NSAttributedString alloc]initWithString:part.text];
            }
           
        }else if (part.isSpecial){//非表情特殊文字
            substr = [[NSAttributedString alloc]initWithString:part.text attributes:@{
            NSForegroundColorAttributeName:[UIColor redColor]
              }];
            //创建特殊对象
            ZFSpecial *s = [[ZFSpecial alloc]init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            s.range = NSMakeRange(loc,len);
            [specials addObject:s];
        }else{//普通文字
            substr = [[NSAttributedString alloc]initWithString:part.text];
        }
        
        [attributedText appendAttributedString:substr];
    }
    // 一定要设置字体,保证计算出来的尺寸是正确的
   
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
  
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    return attributedText;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
  
        //利用text生成attributedText
    self.attributedText = [self attributedTextWithText:text];
  
}

-(void)setRetweeted_status:(ZFStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status.user.name, retweeted_status.text];
    self.retweetedAttributedText = [self attributedTextWithText:retweetContent];
    
}
- (NSString *)created_at
{
    // _created_at == Thu Oct 16 17:06:25 +0800 2014
    // dateFormat == EEE MMM dd HH:mm:ss Z yyyy
    // NSString --> NSDate
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

// <a href="http://app.weibo.com/t/feed/4iDt6Q" rel="nofollow">微博云剪</a>
- (void)setSource:(NSString *)source
{
//     NSLog(@"---%@---",source);
//    return;
    // 正则表达式 NSRegularExpression
    // 截串 NSString
    NSRange range;

    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;

    if (source.length  >=  range.location +  range.length) {
        _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];


    }

}
@end
