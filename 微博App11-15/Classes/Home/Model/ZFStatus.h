//
//  ZFStatus.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class ZFUser;
@interface ZFStatus : NSObject
/**    string  字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**    string    微博信息内容*/
@property (nonatomic, copy) NSString *text;
/**       微博信息内容  带有属性，显示表情或者链接*/
@property (nonatomic, copy) NSAttributedString *attributedText;

/**    object    微博作者的用户信息字段 详细*/
@property (nonatomic, strong) ZFUser *user;
/**    String 微博创建时间*/
@property (nonatomic,copy) NSString *created_at;
/**    string 微博来源*/
@property (nonatomic,copy) NSString *source;

/**微博配图地址，*/
@property (nonatomic,strong) NSArray *pic_urls;
/**被转发的微博信息字段。当该微博为转发时返回*/
@property (nonatomic,strong) ZFStatus *retweeted_status;
/** 被转发 微博信息内容  带有属性，显示表情或者链接*/
@property (nonatomic, copy) NSAttributedString *retweetedAttributedText;

/**    int    转发数*/
@property (nonatomic, assign) int reposts_count;
/**    int    评论数*/
@property (nonatomic, assign) int comments_count;
/**    int    表态数*/
@property (nonatomic, assign) int attitudes_count;
@end
