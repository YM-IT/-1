//
//  ZFEmotion.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/28.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFEmotion : NSObject
/**表情的文字描述*/
@property (nonatomic,copy) NSString *chs;
/**表情的png图片名*/
@property (nonatomic,copy) NSString *png;
/**emoji表情的16进制编码*/
@property (nonatomic,copy) NSString *code;
@end
