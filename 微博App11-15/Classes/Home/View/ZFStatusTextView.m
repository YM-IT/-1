//
//  ZFStatusTextView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/12/4.
//  Copyright © 2020年 林漳峰. All rights reserved.
//
#define ZFtag 99

#import "ZFStatusTextView.h"
#import "ZFSpecial.h"
#import "UIView+Extension.h"
@implementation ZFStatusTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor clearColor];
        self.editable = NO;
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
       //禁止滚动
        self.scrollEnabled = NO;
    }
    return self;
}


- (void)setupSpecialRects
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    //用speicals这个key，拿到字符串算出有几个矩形框
    for (ZFSpecial *special in specials) {
        self.selectedRange = special.range;
        //self.selectedRange -->影响self.selectedTextRange
        //获得选中的矩形框
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        //清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selsctionRect in selectionRects) {
            CGRect rect = selsctionRect.rect;
            if (rect.size.width == 0 ||rect.size.height ==0) continue;
            
            //添加rcet
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }

}
/**
 *找到被触摸的特殊字符串
 */
-(ZFSpecial *)touchingSpecialWithpoint:(CGPoint)point
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    //用speicals这个key，拿到字符串
    for (ZFSpecial *special in specials) {
        
        for (NSValue *rectValue in special.rects) {
    
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {//点中某个特殊字符串
                return special;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //触摸对象
    UITouch *touch = [touches anyObject];
    //触摸点
    CGPoint point = [touch locationInView:self];
    
    //初始化矩形框
    [self setupSpecialRects];
    //根据触摸点获得被触摸的特殊字符串
    ZFSpecial *special = [self touchingSpecialWithpoint:point];
    
   //在触摸的特殊字符串背景显示高亮
    for (NSValue *rectValue in special.rects ) {
        //被触摸的字符串后面显示高亮背景
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor blueColor];
        cover.frame = rectValue.CGRectValue;
        cover.tag = ZFtag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self touchesCancelled:touches withEvent:event];     
    });
  
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //去掉字符串的高亮背景
    for (UIView *child in self.subviews ) {
        if (child.tag == ZFtag) [child removeFromSuperview];
    }
   
}
/**告诉系统：触摸点是否在这个UI控件身上*/
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    //初始化矩形框
    [self setupSpecialRects];
    //根据触摸点获得被触摸的特殊字符串
    ZFSpecial *special = [self touchingSpecialWithpoint:point];
    if (special) {
        return YES;
    }else{
        return NO;
    }
}
@end
