//
//  ZFEmotionKeyboard.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionKeyboard.h"
#import "ZFEmotionTabBar.h"
#import "ZFEmotionListView.h"
#import "UIView+Extension.h"
#import "MJExtension.h"
#import "ZFEmotion.h"
#import "ZFEmotionTool.h"

@interface ZFEmotionKeyboard() <ZFEmotionTabBarDelegate>
/**保存正在显示listView*/
@property (nonatomic,weak) ZFEmotionListView *showingListView;
/**内容表情*/
@property (nonatomic,strong) ZFEmotionListView *recentListView;
@property (nonatomic,strong) ZFEmotionListView *defaulListView;
@property (nonatomic,strong) ZFEmotionListView *emojiListView;
@property (nonatomic,strong) ZFEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic,weak) ZFEmotionTabBar *tabBar;
@end
@implementation ZFEmotionKeyboard


#pragma mark 懒加载
- (ZFEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[ZFEmotionListView alloc]init];
        //加载沙盒中的数据
        self.recentListView.emotions = [ZFEmotionTool recentEmotions];
    }
    return _recentListView;
}

- (ZFEmotionListView *)defaulListView
{
    if (!_defaulListView) {
        self.defaulListView = [[ZFEmotionListView alloc]init];
    
        self.defaulListView.emotions =[ZFEmotionTool defaultEmotions];
    
       
    }
    return _defaulListView;
}

- (ZFEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[ZFEmotionListView alloc]init];
     
        self.emojiListView.emotions = [ZFEmotionTool emojiEmotions];
       
    }
    return _emojiListView;
}

- (ZFEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[ZFEmotionListView alloc]init];
        
        self.lxhListView.emotions = [ZFEmotionTool lxhEmotions];
       
    }
    return _lxhListView;
}

#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //tabbar
        ZFEmotionTabBar *tabBar = [[ZFEmotionTabBar alloc]init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        //
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"ZFEmotionDidSelectNotification" object:nil];
    }
    return self;
}

-(void)emotionDidSelect
{
    self.recentListView.emotions = [ZFEmotionTool recentEmotions];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    //tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;


    //表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y ;
    
  
}
#pragma mark ZFEmotionTabBarDelaget
- (void)emotionTabBar:(ZFEmotionTabBar *)tabBar didSelectButton:(ZFemotionTabBarButtonType)buttonType
{
    //移除contenView之前显示的控件
    [self.showingListView removeFromSuperview];
   
    //根据按钮类型切换contenView上的listview
    switch (buttonType) {
        case ZFemotionTabBarButtonTypeRecent:{
            [self addSubview:self.recentListView];
           
            break;
        }
            
        case ZFemotionTabBarButtonTypeDefault:{
            [self addSubview:self.defaulListView];
            break;
        }
            
        case ZFemotionTabBarButtonTypeEmoji:{
            [self addSubview:self.emojiListView];
            break;
        }
            
        case ZFemotionTabBarButtonTypeLxh:{
            [self addSubview:self.lxhListView];
            break;
        }
    }
    self.showingListView = [self.subviews lastObject];
    //重新计算子控件的frame,这个会重新调用layousubview
    [self setNeedsLayout];
}

@end
