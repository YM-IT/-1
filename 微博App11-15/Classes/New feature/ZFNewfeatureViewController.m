//
//  ZFNewfeatureViewController.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/18.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFNewfeatureViewController.h"
#import "UIView+Extension.h"
#import "ZFTabBarViewController.h"
// RGB颜色
#define ZFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ZFNewfeatureCount 4
@interface ZFNewfeatureViewController () <UIScrollViewDelegate>

@property (nonatomic,weak) UIPageControl *pageControl;

@property (nonatomic,weak) UIScrollView *scrollView;
@end

@implementation ZFNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建一个scrollView 显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //1添加图片到scrollview中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i<ZFNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = scrollW * i;
        
        //2显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        //如果是最后一个imageview，就往里面添加其他内容
        if (i == ZFNewfeatureCount - 1) {
            [self setupLatsImageView:imageView];
        }
        
    }
    
    //3设置scrollview的其他属性
    //如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0；
    scrollView.contentSize = CGSizeMake(ZFNewfeatureCount *scrollW, 0);
    //去除弹簧效果
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    //4添加pagecontrol：分页 展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = ZFNewfeatureCount;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor =ZFColor(253, 89, 42);
    pageControl.pageIndicatorTintColor = ZFColor(189, 189, 189);
    pageControl.centerX = scrollW *0.5;
    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
     // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
    
}

-(void)setupLatsImageView:(UIImageView *)imageView
{
    //开启交互功能
    imageView.userInteractionEnabled = YES;
    //分享给大家
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
     [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 200;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width *0.5;
    shareBtn.centerY = imageView.height *0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
     // EdgeInsets: 自切
    // titleEdgeInsets:只影响按钮内部的titleLabel
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    //开始微博
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}


-(void)shareClick:(UIButton *)shareBtn
{
    //状态取反
    shareBtn.selected = !shareBtn.selected;
}
-(void)startClick
{
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[ZFTabBarViewController alloc]init];
    // modal方式，不建议采取：新特性控制器不会销毁
    //    HWTabBarViewController *main = [[HWTabBarViewController alloc] init];
    //    [self presentViewController:main animated:YES completion:nil];
}














@end
