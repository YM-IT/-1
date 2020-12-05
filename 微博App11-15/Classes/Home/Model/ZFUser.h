//
//  ZFUser.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZFUser : NSObject
/**    string    型的用户UID*/
@property (nonatomic,copy) NSString *idstr;
/**    string    友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**    string    用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

/**  会员类型 》2代表会员*/
@property (nonatomic,assign) int mbtype;

/** 会员等级*/
@property (nonatomic,assign) int mbrank;
@property (nonatomic,assign,getter = isVip) BOOL  vip;

/**认证类型*/
@property (nonatomic,assign,getter=isVerified) BOOL verified;
@end
