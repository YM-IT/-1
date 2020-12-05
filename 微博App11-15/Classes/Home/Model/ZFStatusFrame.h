//
//  ZFStatusFrame.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/20.
//  Copyright © 2020年 林漳峰. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


// 昵称字体
#define ZFStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define ZFStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define ZFStatusCellSourceFont ZFStatusCellTimeFont
// 正文字体
#define ZfStatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博的正文字体
#define ZFStatusCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell之间的间距
#define ZfStatusCellMargin 15

//cell的宽度
#define ZFStatusCellBorderW 10
@class ZFStatus;
@interface ZFStatusFrame : NSObject


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;

@property (nonatomic,strong) ZFStatus *status;


/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotosViewF;

/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
