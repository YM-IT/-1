//
//  UITextView+Extension.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/30.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
-(void)insertAttributedText:(NSAttributedString *)text;

-(void)insertAttributedText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributedText))settingBlock;
@end
