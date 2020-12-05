//
//  ZFStatusToolbar.h
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/22.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFStatus;
@interface ZFStatusToolbar : UIView

+(instancetype)toolbar;
@property (nonatomic,strong) ZFStatus *status;
@end
