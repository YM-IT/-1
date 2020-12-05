//
//  ZFEmotionAttachment.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionAttachment.h"
#import "ZFEmotion.h"
@implementation ZFEmotionAttachment

- (void)setEmotion:(ZFEmotion *)emotion
{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
 
}

@end

