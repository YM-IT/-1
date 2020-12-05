//
//  ZFEmotionPageView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/29.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionPageView.h"
#import "UIView+Extension.h"
#import "ZFEmotion.h"
#import "NSString+Emoji.h"
#import "ZFEmotionPopView.h"
#import "ZFEmotionButton.h"
#import "ZFEmotionTool.h"
@interface ZFEmotionPageView()
//点击表情按钮后弹出的放大镜，因为可以公共用它，所以只需要懒加载创建一次，且为了在没显示的时候页存在所有用强指针
@property (nonatomic,strong) ZFEmotionPopView *popView;
//删除按钮
@property (nonatomic,weak) UIButton *deletButton;
@end


@implementation ZFEmotionPageView

- (ZFEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [ZFEmotionPopView popView];
        
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //表情键盘删除按钮
        UIButton *deletButton = [[UIButton alloc]init];
        [deletButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deletButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deletButton addTarget:self action:@selector(deletClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deletButton];
        self.deletButton = deletButton;
        
        //添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}

  //获得手指所在的位置
-(ZFEmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
  
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        ZFEmotionButton *btn = self.subviews[i+1];
        
        if (CGRectContainsPoint(btn.frame, location)) {
        
            
            return btn;
        }
    }
    return nil;
}

-(void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    //所获的手指所在的位置
    ZFEmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: //手势不再触摸popview
            [self.popView removeFromSuperview];
            //如果手还在按钮上
            if (btn) {
                //发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
        
        case UIGestureRecognizerStateBegan: //手势开始
        case UIGestureRecognizerStateChanged: {//手势改变
     
            [self.popView showFrom:btn];
            break;
        }
            
            break;
    }
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        ZFEmotionButton *btn = [[ZFEmotionButton alloc]init];
       
         [self addSubview:btn];
        
        //设置表情数据，显示在键盘上,吧emotions模型传给btn的数组模型
          btn.emotion = emotions[i];
   
      
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //内边距
    CGFloat inset = 10;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / ZFEmotionMaxCols;
     CGFloat btnH = (self.height - inset) / ZFEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % ZFEmotionMaxCols)*btnW;
        btn.y = inset + (i / ZFEmotionMaxCols)*btnH;
        
        
    }
    //表情键盘删除按钮
    self.deletButton.width = btnW;
    self.deletButton.height = btnH;
    //162
    self.deletButton.y = self.height - btnH;
    //532
    self.deletButton.x = self.width - inset - btnW;
   
}
//表情键盘上的删除按钮
-(void)deletClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFEmotionDidDeleteNotification" object:nil];
}


/**
 监听表情按钮点击
 btn  被点击的表情按钮
 */
-(void)btnClick:(ZFEmotionButton *)btn
{
    
    [self.popView showFrom:btn];
    //让popview消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    //发出通知，让textview知道点击了哪个表情。从而显示在tetxview上
    [self selectEmotion:btn.emotion];
}

-(void)selectEmotion:(ZFEmotion *)emotion
{
    //将这个表情存进沙盒
    [ZFEmotionTool addRecentEmotion:emotion];
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"selectEmotion"] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFEmotionDidSelectNotification" object:nil userInfo:userInfo];
}


@end
