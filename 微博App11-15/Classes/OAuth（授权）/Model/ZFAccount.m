//
//  ZFAccount.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/19.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFAccount.h"

@implementation ZFAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    ZFAccount *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
     account.uid = dict[@"uid"];
     account.expires_in = dict[@"expires_in"];
    return account;
}
/**当一个对象要归档进沙盒中时，就会调用这个方法
 目的：在这个方法说明这个对象的那些属性要存进沙盒
*/

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.name forKey:@"name"];
}
/**从沙盒解档一个对象（从沙盒加载一个对象时），就会调用这个方法
 目的：在这个方法中说明这个对对象的那些属性要存进沙盒
 */
-(id)initWithCoder:(NSCoder *)encoder
{
    if (self = [super init]) {
        self.access_token = [encoder decodeObjectForKey:@"access_token"];
         self.uid = [encoder decodeObjectForKey:@"uid"];
         self.expires_in = [encoder decodeObjectForKey:@"expires_in"];
        self.created_time = [encoder decodeObjectForKey:@"created_time"];
        self.name = [encoder decodeObjectForKey:@"name"];
    }
    return self;
}



@end
