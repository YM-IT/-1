//
//  ZFTabBar.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/17.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFTabBar.h"
#import "UIView+Extension.h"
@interface ZFTabBar()
@property (nonatomic,weak) UIButton *plusBtn;
@end
@implementation ZFTabBar

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        //添加一个按键到tabbar中
        UIButton *plusBtn = [[UIButton alloc]init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
      plusBtn.size =  plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

-(void)plusClick
{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    //设置其他tabbarbutton的位置尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIdenx =0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            //设置宽度
            child.width = tabbarButtonW;
            //设置X
            child.x = tabbarButtonIdenx * tabbarButtonW;
            
            //增加索引
            tabbarButtonIdenx++;
            if (tabbarButtonIdenx == 2) {
                tabbarButtonIdenx++;
            }
        }
    }
}
@end
