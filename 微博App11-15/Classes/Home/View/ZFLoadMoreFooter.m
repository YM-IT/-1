//
//  ZFLoadMoreFooter.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/20.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFLoadMoreFooter.h"

@implementation ZFLoadMoreFooter

+(instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZFLoadMoreFooter" owner:nil options:nil]lastObject];
}

@end
