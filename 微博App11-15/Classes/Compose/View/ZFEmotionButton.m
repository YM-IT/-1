//
//  ZFEmotionButton.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/29.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionButton.h"
#import "ZFEmotion.h"
#import "NSString+Emoji.h"
@implementation ZFEmotionButton
//通过代码创建就会调用这个
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          [self setup];
    }
    return self;
}
//当控件是从xib 或者stortboard创建出来的就会调用这个方法，而不会调用xib
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    //按钮高亮时不要去调整图片为灰色
    self.adjustsImageWhenHighlighted = YES;
}

- (void)setEmotion:(ZFEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) {//有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        
    }else if (emotion.code){//是emoji
        //  设置emoji           这个emoji是扩展类的对象
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
     
    }
}

@end
