//
//  ZFSeachBar.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/17.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFSeachBar.h"
#import "UIView+Extension.h"
@implementation ZFSeachBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        UIImageView *searchIcon = [[UIImageView alloc]init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        //设置搜索框的左边view为searIcon
        self.leftView = searchIcon;
        //设置搜索框左边的view一直显示。
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

+(instancetype)srarchBar
{
    return [[self alloc] init];
}

@end
