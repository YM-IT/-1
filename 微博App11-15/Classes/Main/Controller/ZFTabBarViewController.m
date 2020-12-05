//
//  ZFTabBarViewController.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/15.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFTabBarViewController.h"
#import "ZFHomeViewController.h"
#import "ZFMessageCenterViewController.h"
#import "ZFDiscoverViewController.h"
#import "ZFProfileViewController.h"
#import "ZFNavigationViewController.h"
#import "ZFTabBar.h"
#import "ZFComposeViewController.h"
// RGB颜色
#define ZFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define ZFRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface ZFTabBarViewController () <ZFTabBarDelegate>

@end

@implementation ZFTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控制器
    ZFHomeViewController *home = [[ZFHomeViewController alloc]init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    
    ZFMessageCenterViewController *messageCenter = [[ZFMessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    ZFDiscoverViewController *discover = [[ZFDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    ZFProfileViewController *profile = [[ZFProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];

   //更换系统自带的tabbar
    ZFTabBar *tabBar = [[ZFTabBar alloc]init];
    tabBar.delegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    //设置子控制器的title文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = ZFColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
   // childVc.view.backgroundColor = HWRandomColor;
   //先给外面传进来的控制器 包装一个导航控制器
    ZFNavigationViewController *nav = [[ZFNavigationViewController alloc]initWithRootViewController:childVc];
    //添加为子控制器
    [self addChildViewController:nav];
}
#pragma mark - HWTabBarDelegate代理方法
-(void)tabBarDidClickPlusButton:(ZFTabBar *)tabBar
{
    ZFComposeViewController *compose = [[ZFComposeViewController alloc]init];
    ZFNavigationViewController *nav = [[ZFNavigationViewController alloc]initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
