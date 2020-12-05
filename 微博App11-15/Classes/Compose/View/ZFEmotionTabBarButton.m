//
//  ZFEmotionTabBarButton.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionTabBarButton.h"

@implementation ZFEmotionTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //设置字体
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    //按钮高量所做的一切操作都不存在
}
@end
