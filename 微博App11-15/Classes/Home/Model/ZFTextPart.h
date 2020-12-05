//
//  ZFTextPart.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/12/3.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFTextPart : NSObject
/**这段文字的内容*/
@property (nonatomic,copy) NSString *text;
/**这段文字的范围*/
@property (nonatomic,assign) NSRange range;
/**是否是特殊文字*/
@property (nonatomic,assign,getter=isSpecial) BOOL special;
/**是否为表情*/
@property (nonatomic,assign,getter=isemotion) BOOL emotion;
@end
