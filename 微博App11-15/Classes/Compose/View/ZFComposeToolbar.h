//
//  ZFComposeToolbar.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/27.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ZFComposeToolbarButtonTypeCamera,//拍照
    ZFComposeToolbarButtonTypePicture,//相册
    ZFComposeToolbarButtonTypeMention,//@
    ZFComposeToolbarButtonTypeTrend,//#
    ZFComposeToolbarButtonTypeEmotion//表情
}ZFComposeToolbarButtonType;


@class ZFComposeToolbar;

@protocol ZFComposeToolbarDelegate <NSObject>
@optional

-(void)composeToolbar:(ZFComposeToolbar *)toobar didClickButton:(ZFComposeToolbarButtonType)buttonType;
@end
@interface ZFComposeToolbar : UIView

@property (nonatomic,weak) id<ZFComposeToolbarDelegate> delegate;
/**是否要显示键盘按钮*/
@property (nonatomic,assign) BOOL showKeyboardButton;
@end
