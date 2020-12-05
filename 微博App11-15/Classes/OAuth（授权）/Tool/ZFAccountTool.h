//
//  ZFAccountTool.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFAccount.h"
@interface ZFAccountTool : NSObject


/**
 储存账号
 
 */
+(void)saveAccount:(ZFAccount *)account;

/**
 返回账号信息
 */
+(ZFAccount *)account;
@end
