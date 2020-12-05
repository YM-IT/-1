//
//  ZFEmotionPageView.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/29.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
//每一页的表情个数
#define ZFEmotionPageSize ((ZFEmotionMaxRows * ZFEmotionMaxCols) - 1)
//一页中对多三行
#define ZFEmotionMaxRows 3
//一行中对多七列
#define ZFEmotionMaxCols 7
@interface ZFEmotionPageView : UIView
/**这一页显示的表情 （里面都是ZFemotion这个模型）*/
@property (nonatomic,strong) NSArray *emotions;
@end
