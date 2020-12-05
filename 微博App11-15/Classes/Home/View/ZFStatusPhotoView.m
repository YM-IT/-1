//
//  ZFStatusPhotoView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/26.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFStatusPhotoView.h"
#import "ZFPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
@interface ZFStatusPhotoView()
@property (nonatomic,weak) UIImageView *gifView;
@end
@implementation ZFStatusPhotoView

-(UIImageView *)gifView
{
    if (!_gifView) {
        //这样子创建的imageview的尺寸就和gif图片的尺寸一样
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc]initWithImage:image];
        
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        //内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        //超出边框的内容都剪掉；
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setPhoto:(ZFPhoto *)photo
{
    _photo = photo;
    //设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
//        [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //显示/隐藏gif控件,当图片地址不是以gif结尾就 隐藏,以防图片后缀gif大写，所以统一转成小写
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
  
    
}
//设置子控件尺寸，当控件确定尺寸，或者改了尺寸就会调用这个方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gifView.x = self.width - self.gifView.width;
     self.gifView.y = self.height - self.gifView.height;
}
@end
