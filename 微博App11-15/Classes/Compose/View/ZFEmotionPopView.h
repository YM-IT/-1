//
//  ZFEmotionPopView.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/29.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFEmotion, ZFEmotionButton;
@interface ZFEmotionPopView : UIView
+(instancetype)popView;

-(void)showFrom:(ZFEmotionButton *)button;


@end
