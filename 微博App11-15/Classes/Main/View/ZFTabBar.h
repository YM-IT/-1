//
//  ZFTabBar.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/17.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFTabBar;

@protocol ZFTabBarDelegate <UITabBarDelegate>

@optional
-(void)tabBarDidClickPlusButton:(ZFTabBar *)tabBar;

@end
@interface ZFTabBar : UITabBar
@property (nonatomic,weak) id<ZFTabBarDelegate> delegate;
@end
