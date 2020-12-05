//
//  ZFDropdownMenu.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/17.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFDropdownMenu;
@protocol ZFDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(ZFDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(ZFDropdownMenu *)menu;
@end
@interface ZFDropdownMenu : UIView
@property (nonatomic,weak) id<ZFDropdownMenuDelegate> delegate;
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
