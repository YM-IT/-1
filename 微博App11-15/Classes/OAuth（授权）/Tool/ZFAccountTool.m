//
//  ZFAccountTool.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFAccountTool.h"

@implementation ZFAccountTool


/**
 储存账号
 
 */
+(void)saveAccount:(ZFAccount *)account
{
    //获得账号储存时间 （accessToken产生的的时间）
    account.created_time = [NSDate date];
    //自定义对象的储存必须用到NSK
    //s沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
    //自定义对象储存必须用NSKeyedArchiver 不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:path];
}

/**
 返回账号信息
 */
+(ZFAccount *)account
{
    //s沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
   //加载模型
    ZFAccount *account= [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    //验证账号过期
    //过期秒数
    long long expires_in = [account.expires_in longLongValue];
    //获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //获得当前时间
    NSDate *now = [NSDate date];
    
    // 如果expiresTime <= now，过期
    /**
     NSOrderedAscending = -1L, 升序，右边 > 左边
     NSOrderedSame, 一样
     NSOrderedDescending 降序，右边 < 左边
     */
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    return account;
}
@end
