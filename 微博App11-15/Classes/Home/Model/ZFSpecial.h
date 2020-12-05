//
//  ZFSpecial.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/12/4.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFSpecial : NSObject
/**特殊文字的内容*/
@property (nonatomic,copy) NSString *text;
/***特殊文字的范围*/
@property (nonatomic,assign) NSRange range;
/**这段文字的特殊矩形框*/
@property (nonatomic,strong) NSArray *rects;
@end
