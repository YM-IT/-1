//
//  ZFEmotionTextView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionTextView.h"
#import "ZFEmotion.h"
#import "ZFEmotionAttachment.h"

#import "NSString+Emoji.h"
#import "UITextView+Extension.h"
@implementation ZFEmotionTextView

-(void)insertEmotion:(ZFEmotion *)emotion;
{
    if (emotion.code) {
        //insertText:将文字插入到光标的位置
        [self insertText:emotion.code.emoji];
    }else if (emotion.png){
        //加载图片
        ZFEmotionAttachment *attch = [[ZFEmotionAttachment alloc]init];
        //传递模型
        attch.emotion = emotion;
        
        //设置图片尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4,  attchWH,  attchWH);
        
        //根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        //插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
          ////设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
        
        
       
    }
}

-(NSString *)fullText
{
    //遍历所有的属性文字（图片，emoji，普通文字）
    NSMutableString *fullText = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        //如果是图片
        ZFEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) {//是图片
            [fullText appendString:attch.emotion.chs];
           
        }else{//emoji，普通文本
            NSAttributedString * str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
            
        }
    }];
    return fullText;
}
@end
