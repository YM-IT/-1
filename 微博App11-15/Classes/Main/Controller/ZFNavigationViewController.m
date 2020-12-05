//
//  ZFNavigationViewController.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/16.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFNavigationViewController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
@interface ZFNavigationViewController ()

@end

@implementation ZFNavigationViewController

 +(void)initialize
{
    //设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置普通状态
    NSMutableDictionary *textArrs = [NSMutableDictionary dictionary];
    textArrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textArrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textArrs forState:UIControlStateNormal];
    
    //设置状态不可用
    NSMutableDictionary *disableTextArrs = [NSMutableDictionary dictionary];
    disableTextArrs[NSForegroundColorAttributeName] =[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
     disableTextArrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
     [item setTitleTextAttributes:disableTextArrs forState:UIControlStateDisabled];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >0) {// 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        //自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        //设置导航栏上面的内容
      //设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        

        //设置右边的更多按钮
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
        
      
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}
-(void)more
{
    [self popToRootViewControllerAnimated:YES];
}
@end
