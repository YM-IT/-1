//
//  ZFTextView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/27.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFTextView.h"

@implementation ZFTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
/**当textview死亡时就取消通知*/
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/**监听文字改变*/
-(void)textDidChange
{
    //重绘（重新调用）
    [self setNeedsDisplay];
    
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText: text];
    [self setNeedsDisplay];
}
//该属性文字就会调用，
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    //如果有输入文字，就直接返回，
    if (self.hasText) return;
    
    //文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    //画文字
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height -2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    //限制画文字在哪个区域
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}


@end
