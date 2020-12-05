//
//  ZFEmotionTabBar.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionTabBar.h"
#import "ZFEmotionTabBarButton.h"
#import "UIView+Extension.h"
@interface ZFEmotionTabBar()
@property (nonatomic,weak) ZFEmotionTabBarButton *selectedBtn;
@end
@implementation ZFEmotionTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:ZFemotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:ZFemotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:ZFemotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:ZFemotionTabBarButtonTypeLxh];
    }
    return self;
}

/**
 创建一个按钮
 */
- (ZFEmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(ZFemotionTabBarButtonType)buttonType
{
 //创建按钮
    ZFEmotionTabBarButton *btn = [[ZFEmotionTabBarButton alloc]init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    //选中默认按钮
    if (buttonType == ZFemotionTabBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    //设置图片背景
    NSString *image= @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置按钮frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    
    for (int i = 0; i<btnCount; i++) {
        ZFEmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x  = i * btnW;
        btn.height = btnH;
        
    }
}

- (void)setDelegate:(id<ZFEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    //选中默认按钮
    [self btnClick:(ZFEmotionTabBarButton *)[self viewWithTag:ZFemotionTabBarButtonTypeDefault]];
}

/**
 按钮点击
 */
-(void)btnClick:(ZFEmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:btn.tag];
    }
}
@end
