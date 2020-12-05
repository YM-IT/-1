//
//  ZFComposePhotosView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/27.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFComposePhotosView.h"
#import "UIView+Extension.h"
@interface ZFComposePhotosView()
@end
@implementation ZFComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

-(void)addphoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = photo;
    [self addSubview:photoView];
    
    //存储图片
    [self.photos addObject:photo];
}

- (void)layoutSubviews
{
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col *(imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

@end
