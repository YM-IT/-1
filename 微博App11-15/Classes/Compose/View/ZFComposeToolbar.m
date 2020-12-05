//
//  ZFComposeToolbar.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/27.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFComposeToolbar.h"
#import "UIView+Extension.h"

@interface ZFComposeToolbar()
@property (nonatomic,weak) UIButton *emotionButton;
@end
@implementation ZFComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //平铺
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:ZFComposeToolbarButtonTypeCamera];
        
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:ZFComposeToolbarButtonTypePicture];
        
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:ZFComposeToolbarButtonTypeMention];
        
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:ZFComposeToolbarButtonTypeTrend];
        
       self.emotionButton=  [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:ZFComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    //默认的图片名
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highIMage = @"compose_emoticonbutton_background_highlighted";
    
    //显示键盘图标
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highIMage = @"compose_keyboardbutton_background_highlighted";
    }
    
    //设置图片
    
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
     [self.emotionButton setImage:[UIImage imageNamed:highIMage] forState:UIControlStateHighlighted];
}


/**
 创建一个按钮
 */
-(UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(ZFComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        [self.delegate composeToolbar:self didClickButton:btn.tag];
    }
}

@end
