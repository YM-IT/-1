//
//  ZFEmotionTextView.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFTextView.h"
@class ZFEmotion;
@interface ZFEmotionTextView : ZFTextView
-(void)insertEmotion:(ZFEmotion *)emotion;

-(NSString *)fullText;
@end
