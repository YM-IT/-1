//
//  ZFEmotion.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFEmotion.h"
#import "MJExtension.h"

@interface ZFEmotion()  <NSCoding>
@end

@implementation ZFEmotion

MJCodingImplementation

/**
 用来比较两ZFEmotion个对象是否一样
 other ：另外一个ZFEotion对象
 
 */

-(BOOL)isEqual:(ZFEmotion*)other
{
    //判断对象的文字是否相同，
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString: other.code ];
    //判断对象的地址是否相同
    // return [self.chs isEqual:other.chs];
}


@end
