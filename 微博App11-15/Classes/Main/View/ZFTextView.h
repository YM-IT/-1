//
//  ZFTextView.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/27.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFTextView : UITextView
 /**站位文字*/
@property (nonatomic,copy) NSString *placeholder;
 /**站位文字的颜色*/
@property (nonatomic,strong) UIColor *placeholderColor;
@end
