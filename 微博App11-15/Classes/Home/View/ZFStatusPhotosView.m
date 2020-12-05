//
//  ZFPhotosView.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/25.
//  Copyright © 2020年 林漳峰. All rights reserved.
//
#define ZFStatusPhotoWH  70
#define ZFStatusPhotoMargin  10
#define ZFStatusPhotoMaxCol(count) ((count == 4)?2:3)
#import "ZFStatusPhotosView.h"
#import "ZFPhoto.h"

#import "UIView+Extension.h"
#import "ZFStatusPhotoView.h"

@implementation ZFStatusPhotosView

//重写set方法，传数据过来就改变里面的东西
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSUInteger photosCount = photos.count;
    //创建足够数量的图片控件
    while (self.subviews.count <photosCount) {
        ZFStatusPhotoView *photoview = [[ZFStatusPhotoView alloc]init];
        photoview.backgroundColor = [UIColor redColor];
        [self addSubview:photoview];
    }
    //遍历所有图片控件
    for (int i = 0; i<self.subviews.count; i++) {
        ZFStatusPhotoView *photoView = self.subviews[i];
       
        if (i <photosCount) {//显示
           photoView.photo = photos[i];
              photoView.hidden = NO;
        
          
        }else{
            photoView.hidden = YES;
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = ZFStatusPhotoMaxCol(photosCount);
    for (int i = 0 ; i<photosCount;i++) {
        ZFStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col*(ZFStatusPhotoWH + ZFStatusPhotoMargin);
        int row = i / maxCol;
        photoView.y =row*(ZFStatusPhotoWH + ZFStatusPhotoMargin);
        photoView.width = ZFStatusPhotoWH;
        photoView.height = ZFStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    //最大列数
    int maxCols = ZFStatusPhotoMaxCol(count);
    //列数
    NSUInteger cols = (count >= maxCols)? maxCols :count;
    CGFloat photosW = cols * ZFStatusPhotoWH +(cols - 1) *ZFStatusPhotoMargin;
    //行数这条公式很多地方可以用得上，例如分页
    //有1000条数据，每页最多20条，就一共有50页
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    //    if(count % 3 == 0) {//3/6/9
    //        rows = count / 3 ;
    //    }else{//1/2/4/5/7/8
    //        rows = count / 3 + 1;
    //    }
    
    CGFloat photosH = rows * ZFStatusPhotoWH +(rows - 1) *ZFStatusPhotoMargin;
    return CGSizeMake(photosW, photosH);
    
}
@end
