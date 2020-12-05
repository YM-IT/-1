//
//  ZFHomeViewController.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/15.
//  Copyright © 2020年 林漳峰. All rights reserved.
//
// RGB颜色
#define ZFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "ZFHomeViewController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "ZFDropdownMenu.h"
#import "ZFTitleMenuViewController.h"
#import "ZFAccountTool.h"
#import "AFNetworking.h"
#import "ZFTitleButton.h"
#import "UIImageView+WebCache.h"
#import "ZFUser.h"
#import "ZFStatus.h"
#import "MJExtension.h"
#import "ZFLoadMoreFooter.h"
#import "ZFStatusCell.h"
#import "ZFStatusFrame.h"
#import "MBProgressHUD.h"
@interface ZFHomeViewController () <ZFDropdownMenuDelegate>
/**
 *  微博数组（里面放的都是StatusFrame模型，一个StatusFrame对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation ZFHomeViewController

-(NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}
- (void)viewDidLoad {
    
    self.tableView.backgroundColor = ZFColor(211, 211, 211);
    
    [super viewDidLoad];
    //设置导航栏上面的内容
    [self setupNav];
    //设置用户信息
    [self setupUserInfo];

  //集成下拉刷新控件
    [self setupDownRefresh];
    //集成上拉刷新控件
    [self setupUpRefresh];
    //获得未读数组
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
  //  主线程也会抽时间处理一下timer（不管住线程是否在在其他事的请）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 获得未读数组
 
 */
-(void)setupUnreadCount
{

//        NSLog(@"setupUnreadCount");
//       return;
    //请求管理者
     AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];


    //拼接数据
    ZFAccount *account = [ZFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;


    //发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

        // 设置提醒数字
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {//0 得清空
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{//非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

    }];
}


/**
 集成上拉刷新控件
 */
-(void)setupUpRefresh
{
    ZFLoadMoreFooter *footer = [ZFLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}
/**
 集成下拉刷新控件
 */
-(void)setupDownRefresh
{
    //添加刷新控件
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    //只有用户通过手动下拉刷新才会出发change方法
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [control beginRefreshing];
    //马上加载数据
    [self refreshStateChange:control];
}



/**
 *  将HWStatus模型转为HWStatusFrame模型
 */

-(NSArray *)statusFrameWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (ZFStatus *status in statuses) {
        ZFStatusFrame *f = [[ZFStatusFrame alloc]init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}


/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    //请求管理者
AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    
    //拼接数据
    ZFAccount *account = [ZFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    //取出前面的微博 （最新的微博 ID最大的微博）
    ZFStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        //若指定此参数 则返回ID比since——ID大的微博
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    //发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
     //   NSLog(@"%@",responseObject);
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [ZFStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
      
        //将ZDFStatus数组转为ZFSTAatusFrmae数组
        NSArray *newFrames = [self statusFrameWithStatuses:newStatuses];
        
        //将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
       
        //刷新表哥
        [self.tableView reloadData];
        //结束刷新
        [control endRefreshing];
        //显示最新微博
        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载最新出错%@",error);
        
        //结束刷新
        [control endRefreshing];
    }];
}


/**
 加载更多微博数据
 */
-(void)loadMoreStatus
{
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
 
    //拼接请求参数
    ZFAccount *account = [ZFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sccess_token"] = account.access_token;
    
    //取出最后面的微博 （最新的微博ID越大）
    ZFStatusFrame *lasStatusF = [self.statusFrames lastObject];
    if (lasStatusF) {
        //若指定次参数，则返回ID小于或等于MAX——id的微博。默认为0
        //id这种数据一般比较大，一般专程整数的话最好是longlong类型
        long long maxId = lasStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
 
    //发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [ZFStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //将ZFStatus数组转为ZFSTAatusFrmae数组
        NSArray *newFrames = [self statusFrameWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"加载更多出错%@",error);
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}
/**
 显示最新微博数量
 */
-(void)showNewStatusCount:(NSUInteger)count
{
    
    //刷新成功(晴空图标数)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  //创建label
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    //设置其他属性
    if (count == 0) {
        label.text =@"共有0条微博";
        
    }else{
        label.text = [NSString stringWithFormat:@"共刷新了%zd",count];
    }
    label.tintColor = [UIColor whiteColor];
    //文字剧中
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    
    //添加
    label.y = 64-label.height;
    //将label添加到导航控制器view中，并且时盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //动画
    //利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
      
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
       
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}
/**
 获得用户信息
 */
-(void)setupUserInfo
{
    /**
    请求参数：
     // https://api.weibo.com/2/users/show.json
     // access_token    false    string    采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     // uid    false    int64    需要查询的用户ID。
     // 1.请求管理者
    */
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    //拼接请求参数
    ZFAccount *account = [ZFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        //设置名字
        ZFUser *user = [ZFUser objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        //储存昵称在沙盒中
        account.name =user.name;
        [ZFAccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用户信息请求失败%@",error);
    }];
}

 //设置导航栏上面的内容
-(void)setupNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    //中间的标题按钮
    ZFTitleButton *titleButton = [[ZFTitleButton alloc] init];

    // 设置图片和文字
    NSString *name = [ZFAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];

    //监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
  
}

//标题点击
-(void)titleClick:(UIButton *)titleButton
{
 
    //创建下啦菜单
    ZFDropdownMenu *menu = [ZFDropdownMenu menu];
    menu.delegate = self;
    //设置内容
    ZFTitleMenuViewController *vc = [[ZFTitleMenuViewController alloc]init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    [menu showFrom:titleButton];
}
- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}


//下拉菜单被销毁
-(void)dropdownMenuDidDismiss:(ZFDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    //让箭头向下
    titleButton.selected = NO;
}
//下拉菜单显示了
- (void)dropdownMenuDidShow:(ZFDropdownMenu *)menu
{
   UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    //让箭头向上
   titleButton.selected = YES;
  
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获得cell
    ZFStatusCell *cell = [ZFStatusCell cellWithTableView:tableView];
    
    //给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
     return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 ||self.tableView.tableFooterView.isHidden == NO)return;
        CGFloat offsetY = scrollView.contentOffset.y;
        
        //当最后一个cell完全显示在眼前。contentOffset的y值
        CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
        if (offsetY >= judgeOffsetY) {//最后一个cell完全进入视野范围内
            //显示footer
            self.tableView.tableFooterView.hidden = NO;
            // 加载更多的微博数据
            [self loadMoreStatus];
        }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

@end
