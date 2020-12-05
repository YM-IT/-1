//
//  ZFOAuthViewController.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/18.
//  Copyright © 2020年 林漳峰. All rights reserved.




#import "ZFOAuthViewController.h"
#import "AFNetworking.h"
#import "ZFAccount.h"
#import "ZFAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIWindow+Extension.h"
@interface ZFOAuthViewController () <UIWebViewDelegate>

@end

//账号信息
//appkey
NSString * const ZFAppKey = @"4264186904";
//回调地址
NSString * const ZFRedirectURL = @"http://baidu.com";

NSString * const ZFAPPSecret = @"dc8b8788b45520d67291f26c3cc6a9e0";

@implementation ZFOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc]init];
    web.frame = self.view.bounds;
    web.delegate = self;
    [self.view addSubview:web];
    
    //用web加载登录界面
    //
 
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",ZFAppKey,ZFRedirectURL];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

#pragma mark - webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载"];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [MBProgressHUD hideHUD];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获得url
    NSString *url = request.URL.absoluteString;

    //判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length !=0 ) {//是回调地址
        //截取code=后面的参数值
        NSUInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        //利用code换取一个sccessToke
        [self accessTokenWithCode:code];
        //禁止加载回调地址
        return NO;
    }
   
    return YES;

}

/**
 *  利用code（授权成功后的request token）换取一个accessToken
 *
 *  @param code 授权成功后的request token
 */
- (void)accessTokenWithCode:(NSString *)code
{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     
     请求参数：
     urlhttps://api.weibo.com/oauth2/access_token?client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=authorization_code&redirect_uri=YOUR_REGISTERED_REDIRECT_URI&code=CODE
     client_id：申请应用时分配的AppKey
     client_secret：申请应用时分配的AppSecret
     grant_type：使用authorization_code
     redirect_uri：授权成功后的回调地址
     code：授权成功后返回的code
     */
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = ZFAppKey;
    params[@"client_secret"] = ZFAPPSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = ZFRedirectURL;
    params[@"code"] = code;
    
    //发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];

        
        //将返回的账号字典数据 --》模型存进沙盒
        ZFAccount *account = [ZFAccount accountWithDict:responseObject];

        //储存账号信息
        [ZFAccountTool saveAccount:account];
   //切换根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD hideHUD];
        NSLog(@"请求失败-%@",error);
    }];
}

@end
