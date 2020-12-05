//
//  ZFTitleButton.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFTitleButton.h"
#import "UIView+Extension.h"
#define ZFMargin 15
@implementation ZFTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    frame.size.width += ZFMargin;
    [super setFrame:frame];
}
-(void)layoutSubviews
{
    
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    //计算titlelable的frame
    self.titleLabel.x = self.imageView.x;
    //计算imageview的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + ZFMargin;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    //只要修改了文字按钮就会重新计算自己的尺寸
    [self sizeToFit];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    //只要修改了文字按钮就会重新计算自己的尺寸
    [self sizeToFit];
}
@end
