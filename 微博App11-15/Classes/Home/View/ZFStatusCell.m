//
//  ZFStatusCell.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/20.
//  Copyright © 2020年 林漳峰. All rights reserved.
//
// RGB颜色
#define ZFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "ZFStatusCell.h"
#import "ZFStatus.h"
#import "ZFUser.h"
#import "ZFStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "ZFPhoto.h"
#import "ZFStatusToolbar.h"
#import "ZFStatusPhotosView.h"
#import "ZFIconView.h"
#import "ZFStatusTextView.h"
@interface ZFStatusCell()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) ZFIconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) ZFStatusPhotosView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) ZFStatusTextView *contentLabel;


/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) ZFStatusTextView *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) ZFStatusPhotosView *retweetPhotosView;

/** 工具条 */
@property (nonatomic, weak) ZFStatusToolbar *toolbar;

@end
@implementation ZFStatusCell


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    ZFStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell= [[ZFStatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    
        self.backgroundColor = [UIColor clearColor];
            //点击cell不要变色
        
          self.selectionStyle = UITableViewCellSelectionStyleNone;
        /**初始化原创微博*/
        [self setupOriginal];
        
           /**初始化转发微博*/
        [self setupRetweet];
        
        //初始化工具条
        [self setupToobar];
    }
    return self;
}


 /**初始化工具条*/
-(void)setupToobar
{
    ZFStatusToolbar *toolbar = [[ZFStatusToolbar alloc]init];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

 /**初始化转发微博*/
-(void)setupRetweet
{
     /**转发微博整体*/
    UIView *retweetView = [[UIView alloc]init];
    retweetView.backgroundColor =ZFColor(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /**转发微博正文 + 昵称*/
    ZFStatusTextView *retweetContentLable = [[ZFStatusTextView alloc]init];
    retweetContentLable.font = ZFStatusCellRetweetContentFont;
    [retweetView addSubview:retweetContentLable];
    self.retweetContentLabel = retweetContentLable;
    
    /**转发微博配图*/
    ZFStatusPhotosView *retweePhotosView = [[ZFStatusPhotosView alloc]init];
    [retweetView addSubview:retweePhotosView];
    self.retweetPhotosView = retweePhotosView;


}

/**初始化原创微博*/
-(void)setupOriginal
{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
     originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    ZFIconView *iconView = [[ZFIconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    ZFStatusPhotosView *photosView = [[ZFStatusPhotosView alloc] init];
     [originalView addSubview:photosView];
    self.photosView = photosView;
    
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = ZFStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = ZFStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = ZFStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    ZFStatusTextView *contentLabel = [[ZFStatusTextView alloc] init];
    contentLabel.font = ZfStatusCellContentFont;
    [originalView addSubview:contentLabel];
    
    self.contentLabel = contentLabel;
}
- (void)setStatusFrame:(ZFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    ZFStatus *status = statusFrame.status;
    ZFUser *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    /** 配图 */
    if (status.pic_urls.count) {
         self.photosView.frame = statusFrame.photosViewF;
        self.photosView.photos= status.pic_urls;

        self.photosView.hidden = NO;
    }else{
        self.photosView.hidden = YES;
    }
   
  
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + ZFStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:ZFStatusCellTimeFont];
    statusFrame.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(statusFrame.timeLabelF) + ZFStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:ZFStatusCellSourceFont];
    statusFrame.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 时间 */
        self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.text = status.source;
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    self.contentLabel.attributedText = status.attributedText;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    /**被转发微博*/
    if (status.retweeted_status) {
        ZFStatus *retweeted_status = status.retweeted_status;
      
        self.retweetView.hidden = NO;
        /**被转发的微博整体*/
        self.retweetView.frame = statusFrame.retweetViewF;
        
        
    /** 被转发的微博正文 */
        self.retweetContentLabel.attributedText = status.retweetedAttributedText;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        
        
        /** 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            self.retweetPhotosView.hidden = YES;
        }

    }else {
        self.retweetView.hidden = YES;
    }
    

    /**工具条*/
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = status;
}
@end
