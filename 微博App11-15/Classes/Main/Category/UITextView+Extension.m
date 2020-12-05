//
//  UITextView+Extension.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
-(void)insertAttributedText:(NSAttributedString *)text
{
    [self insertAttributedText:text settingBlock:nil];
}

-(void)insertAttributedText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributedText))settingBlock
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    //拼接之前的文字（图片和普通文字）
    [attributedText appendAttributedString:self.attributedText];
    
    //拼接其他文字
    NSUInteger loc =self.selectedRange.location;
   // [attributedText insertAttributedString:text atIndex:loc];
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    //调用外面传进来代码
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
    self.attributedText = attributedText;
    //移除光标到表情后面.点击光标在哪，输入png的表情之后不会移动光标在文字的最后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}
@end
