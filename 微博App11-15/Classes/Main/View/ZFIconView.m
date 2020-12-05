//
//  ZFIconView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/26.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFIconView.h"
#import "ZFUser.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
@interface ZFIconView()
@property (nonatomic,weak) UIImageView *verifiedView;
@end
@implementation ZFIconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc]init];
        [self addSubview:verifiedView];
        
    }
    return  _verifiedView;
}


-(void)setUser:(ZFUser *)user
{
    _user = user;
    //下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //设置家V图片
   
    if (user.isVerified ) {
        self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
        self.verifiedView.hidden = NO;
    }else{
           self.verifiedView.hidden = YES;
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
     self.verifiedView.y = self.height - self.verifiedView.height * scale;
}
@end
