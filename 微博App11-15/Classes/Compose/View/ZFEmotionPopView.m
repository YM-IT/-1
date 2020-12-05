//
//  ZFEmotionPopView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/29.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionPopView.h"
#import "ZFEmotion.h"
#import "ZFEmotionButton.h"
#import "UIView+Extension.h"
@interface ZFEmotionPopView()
@property (weak, nonatomic) IBOutlet ZFEmotionButton *emotionButton;

@end

@implementation ZFEmotionPopView

+(instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZFEmotionPopView" owner:nil options:nil]lastObject];
}

- (void)showFrom:(ZFEmotionButton *)button
{
    if (button == nil) return;
    //给popview传递数据
     self.emotionButton.emotion = button.emotion;
    
    //获取最上面的windo
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //这样popview才不会被其他控件挡住
    [window addSubview:self];
    //计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
    
}


@end
