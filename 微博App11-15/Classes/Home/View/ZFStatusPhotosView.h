//
//  ZFPhotosView.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/25.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFStatusPhotosView : UIView
@property (nonatomic,strong) NSArray *photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+(CGSize)sizeWithCount:(NSUInteger)count;
@end
