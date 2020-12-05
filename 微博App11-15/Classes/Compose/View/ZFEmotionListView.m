//
//  ZFEmotionListView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotionListView.h"
#import "UIView+Extension.h"
#import "ZFEmotionPageView.h"

@interface ZFEmotionListView() <UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;
@end
@implementation ZFEmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
    
        //分页
        scrollView.pagingEnabled = YES;
        //监听scrollview的滚动，成为代理
        scrollView.delegate = self;
        
        //去除水平方向滚动条
       scrollView.showsHorizontalScrollIndicator = NO;
        //去除垂直方向滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //pageControl
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        //只有一页的时候不显示页数,自动隐藏pageControl
        pageControl.hidesForSinglePage = YES;
        //禁止点击
        pageControl.userInteractionEnabled = NO;
        //设置内部圆点图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    //删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + ZFEmotionPageSize - 1)/ZFEmotionPageSize;
   // CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    //设置页数
    self.pageControl.numberOfPages = count;

    //创建用来显示每一页表情的控件
    for (int i = 0; i<count; i++) {
        ZFEmotionPageView *pageView = [[ZFEmotionPageView alloc]init];
        //设置这一页的表情范围
        NSRange range;
        range.location = i * ZFEmotionPageSize;
        //剩余表情的个数（可截取）
        NSUInteger left = emotions.count - range.location;
        if (left>=ZFEmotionPageSize) {//这一页足够20个
                range.length = ZFEmotionPageSize;
        }else{
            range.length = left;
        }
        //设置这一页的表情
        pageView.emotions = [emotions subarrayWithRange:range] ;
        [self.scrollView addSubview:pageView];
    }
    
   
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    //pagecontrol
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    //scroview
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
     //设置scrollView内部的每一页尺寸
     NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i<count; i++) {
        ZFEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    //设置scrollview的controsize
    self.scrollView.contentSize = CGSizeMake(count *self.scrollView.width, 0);
}

#pragma makr scroviewDeleagte
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}
@end
