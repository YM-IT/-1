//
//  ZFTextPart.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/12/3.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFTextPart.h"

@implementation ZFTextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}
@end
