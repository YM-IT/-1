//
//  ZFStatusCell.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/20.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFStatusFrame;
@interface ZFStatusCell : UITableViewCell
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;
+(instancetype)cellWithTableView:(UITableView *)tableview;

@property (nonatomic,strong) ZFStatusFrame *statusFrame;
@end
