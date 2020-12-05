//
//  ZFEmotionTool.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

//最近表情的储存路径
#define ZFRecentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "ZFEmotionTool.h"
#import "ZFEmotion.h"
#import "MJExtension.h"
@implementation ZFEmotionTool

static NSMutableArray *_recentEmotions;
//第一次使用就会加载
+(void)initialize
{
    //加载沙盒中的表情数据
   _recentEmotions =[NSKeyedUnarchiver unarchiveObjectWithFile:ZFRecentEmotionPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+(ZFEmotion *)emotionWithChs:(NSString *)chs
{
    NSArray *defaults =[self defaultEmotions];
    for (ZFEmotion *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    NSArray *lxhs = [self lxhEmotions];
    for (ZFEmotion *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    return nil;
}

+(void)addRecentEmotion:(ZFEmotion *)emotion
{

    //删除重复表情
    [_recentEmotions removeObject:emotion];
    //将表情放到数组最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    //讲所有的表情数据写进沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:ZFRecentEmotionPath];
}
//返回装着ZFEmotion模型数据
+(NSArray *)recentEmotions
{
    return _recentEmotions;
}
static NSArray *_emojiEmotions, *_defaultEmotions, *_lxhEmotions;
+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        return [ZFEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
   
}
+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        return [ZFEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
   
}
+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        return [ZFEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
   
}
@end
