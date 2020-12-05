//
//  ZFEmotionTool.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFEmotion;
@interface ZFEmotionTool : NSObject
+(void)addRecentEmotion:(ZFEmotion *)emotion;
+(NSArray *)recentEmotions;
+(NSArray *)defaultEmotions;
+(NSArray *)lxhEmotions;
+(NSArray *)emojiEmotions;


/**通过表情描述找到对应的表情*/
+(ZFEmotion *)emotionWithChs:(NSString *)chs;
@end
