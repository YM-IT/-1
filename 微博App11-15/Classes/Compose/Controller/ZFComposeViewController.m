//
//  ZFComposeViewController.m
//  微博App11-15
//
//  Created by 林漳峰 on 2020/11/27.
//  Copyright © 2020年 林漳峰. All rights reserved.
//

#import "ZFComposeViewController.h"
#import "ZFAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "UIView+Extension.h"
#import "ZFComposeToolbar.h"
#import "ZFComposePhotosView.h"
#import "ZFEmotionKeyboard.h"
#import "ZFEmotion.h"
#import "NSString+Emoji.h"
#import "ZFEmotionTextView.h"
@interface ZFComposeViewController () <UITextViewDelegate,ZFComposeToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/**输入控件*/
@property (nonatomic,weak) ZFEmotionTextView *textView;
/**键盘顶部的工具条*/
@property (nonatomic,weak) ZFComposeToolbar *toolbar;
/**相册（存放拍照或者相册中选择的照片）*/
@property (nonatomic,weak) ZFComposePhotosView *photosView;
/**表情键盘*/
@property (nonatomic,strong) ZFEmotionKeyboard *emotionKeyboard;
/**  是否正在切换键盘*/
@property (nonatomic,assign) BOOL switchingKeybaord;
@end

@implementation ZFComposeViewController

#pragma mark 懒加载
- (ZFEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[ZFEmotionKeyboard alloc]init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

#pragma mark 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏内容
    [self setupNav];
    
    //添加输入控件
    [self setupTextView];
    
    //添加工具条
    [self setupToobar];
    //添加相册
    [self setupPhotosView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //成为第一响应者，（输入的文本框控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark 初始化方法

/**
添加相册
 */
-(void)setupPhotosView

{
    ZFComposePhotosView *photosView = [[ZFComposePhotosView alloc]init];
    photosView.y = 100;
    photosView.width = self.view.width;
    photosView .height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

/**
 添加工具条
 */
-(void)setupToobar
{
    ZFComposeToolbar *toolbar = [[ZFComposeToolbar alloc]init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

/**
 设置导航栏内容
 */
-(void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *name = [ZFAccountTool account].name;
    NSString *prefix = @"发微博" ;
    if(name){
    UILabel *titleView = [[UILabel alloc]init];
    titleView.width = 200;
    titleView.height = 100;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    //自动换行
    titleView.numberOfLines = 0;
    titleView.y = 50;
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
    
    //创建一个带有属性的字符串
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    //添加属性
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:[str rangeOfString:name]];
    
    titleView.attributedText = attrStr;
    self.navigationItem.titleView = titleView;
    }else{
        self.title = prefix;
    }
}

/**
 设置输入控件
 */
-(void)setupTextView
{
    //在这个控制器中textView的ContentInset默认会等于64
    ZFEmotionTextView *textView = [[ZFEmotionTextView alloc]init];
   //让其垂直方向上有弹簧效果
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    //文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"ZFEmotionDidSelectNotification" object:nil];
    //删除文字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"ZFEmotionDidDeleteNotification" object:nil];
    
}

#pragma mark监听方法

/**
删除文字
 */
-(void)emotionDidDelete
{
    //往回删除
    [self.textView deleteBackward];
}

/**
 表情被选中了
 */
-(void)emotionDidSelect:(NSNotification *)notification
{
   ZFEmotion *emotion =  notification.userInfo[@"selectEmotion"];
   
    [self.textView insertEmotion:emotion];
}


/**
 键盘的frame发生改变时调用（显示，隐藏等）
 */
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
    //如果正在切换键盘，就不要执行后面代码
    if (self.switchingKeybaord) return;
    NSDictionary *userInfo = notification.userInfo;
    //动画持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        //工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) {// 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
     
    }];
}


-(void)cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send{
   
    if (self.photosView.photos.count) {
        [self sendWithImage];
    }else{
        [self sendWithoutImage];
    }
    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 发布有带图片的微博
 */
-(void)sendWithImage
{
    // URL: https://api.weibo.com/2/statuses/share.json
    // 参数:
    /**    status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**    access_token true string*/
    /**   pic falsebinary    用户想要分享到微博的图片，仅支持JPEG、GIF、PNG图片，上传图片大小限制为<5M。上传图片时，POST方式提交请求，需要采用multipart/form-data编码方式。。*/
    
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [ZFAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    //发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/share.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //拼接文件数据
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image,1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [MBProgressHUD showError:@"发送有图片的微博成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送有图片的微博失败"];
        NSLog(@"发送图片%@",error);  
    }];
}



/**
 发布没有带图片的微博
 */
-(void)sendWithoutImage
{
    //URL:https://api.weibo.com/2/statuses/share.json
    //参数
    /**access_token    true    string    采用OAuth授权方式为必填参数，OAuth授权后获得。
     status    true    string    用户分享到微博的文本内容，必须做URLencode，内容不超过140个汉字
     
     */
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [ZFAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
  
    //发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/share.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showMessage:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
        NSLog(@"发送失败%@",error);
    }];
}
/**
 监听文字改变
 */
-(void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

#pragma mark uitextview代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}

#pragma mark ZFComposeToolbarDelegate

- (void)composeToolbar:(ZFComposeToolbar *)toobar didClickButton:(ZFComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ZFComposeToolbarButtonTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case ZFComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case ZFComposeToolbarButtonTypeMention: // @
            
            break;
            
        case ZFComposeToolbarButtonTypeTrend: // #
            
            break;
            
        case ZFComposeToolbarButtonTypeEmotion: // 表情键盘
            [self switchKeyboard];
            break;
    }
}


#pragma mark 其他方法

/**切换键盘*/
- (void)switchKeyboard
{
    if (self.textView.inputView == nil) {//切换自定义的表情键盘
        self.textView.inputView = self.emotionKeyboard;
        //显示键盘
        self.toolbar.showKeyboardButton = YES;
    }else{
        self.textView.inputView = nil;
        //显示表情按钮
          self.toolbar.showKeyboardButton = NO;
    }
    
    //开始切换键盘
    self.switchingKeybaord = YES;
    
    //推出键盘
    [self.textView endEditing:YES];
    
    //结束切换键盘
    self.switchingKeybaord = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        //探出键盘
        [self.textView becomeFirstResponder];
        
      
    });
}
-(void)openCamera
{
    [self OPenImagepickerController:UIImagePickerControllerSourceTypeCamera];
}
-(void)openAlbum
{
    //
    [self OPenImagepickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)OPenImagepickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type])  return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate =self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}


#pragma mark UIimageOickerControllerDelegate
/**
 从UIimageOickerControllerDelegate 选择玩图片后就调用
 */

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //info中就包含了选择图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //添加图片到photosview中
    [self.photosView addphoto:image];
}

@end
