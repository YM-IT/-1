//
//  ZFEmotionTabBar.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ZFemotionTabBarButtonTypeRecent,//最近
    ZFemotionTabBarButtonTypeDefault,//默认
    ZFemotionTabBarButtonTypeEmoji,//emoji
    ZFemotionTabBarButtonTypeLxh,//浪小花
    
    
} ZFemotionTabBarButtonType;


@class ZFEmotionTabBar;

@protocol ZFEmotionTabBarDelegate <NSObject>

@optional
-(void)emotionTabBar:(ZFEmotionTabBar *)tabBar didSelectButton:(ZFemotionTabBarButtonType)buttonType;
@end
@interface ZFEmotionTabBar : UIView

@property (nonatomic,weak) id<ZFEmotionTabBarDelegate> delegate;
@end
