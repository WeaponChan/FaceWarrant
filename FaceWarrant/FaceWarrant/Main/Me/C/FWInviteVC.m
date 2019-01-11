//
//  FWInviteVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/12.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWInviteVC.h"
#import "WXApi.h"
@interface FWInviteVC ()<UIWebViewDelegate,JSObjectDelegate>
@property(nonatomic,strong)UIView *webviewProgressLine;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)JSContext *context;

@end

@implementation FWInviteVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"邀请好友";
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    
    self.webviewProgressLine = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_H, Screen_W, 2)];
    self.webviewProgressLine.backgroundColor = [UIColor colorWithHexString:@"#48c547"];
    self.webviewProgressLine.hidden = YES;
    [self.view addSubview:self.webviewProgressLine];
    
    NSString *url =  [NSString stringWithFormat:@"%@/%@/v1/base/inviteInfo?userId=%@",FWBaseUrl,FWBaseMethod,[USER_DEFAULTS objectForKey:UD_UserID]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self startLoadingAnimation];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self endLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self endLoadingAnimation];
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"webViewInterface"] = self;
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth=%f;" //缩放系数
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.width > maxwidth){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.width = maxwidth;"
                                                     "myimg.height = myimg.height * (myimg.width/myimg.height);"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",Screen_W]
     ];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];

}


#pragma mark - Custom Delegate

//- (void)OC_JSClick:(NSString *)flag
//{
//    DLog(@"-------->%@",flag);
//    NSString *alertJS = @"aaaa(57892375982798357)";
//    [self.context evaluateScript:alertJS];
//}

-(void)JS_OCClick:(NSString*)flag
{
    DLog(@"-------->%@",flag);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([WXApi isWXAppInstalled]) {
            [self shareWithtype:flag];
        }
    });
}


#pragma mark - Event Response


#pragma mark - Network Requests

- (void)shareWithtype:(NSString *)type
{
    NSString *kLinkUrl = [NSString stringWithFormat:@"%@/%@/v1/base/invite?userId=%@",FWBaseUrl,FWBaseMethod,[USER_DEFAULTS objectForKey:UD_UserID]];
    NSString *kLinkTitle = [NSString stringWithFormat:@"我是%@，快来下载【脸碑】！",self.name];
    NSString *kLinkDescription = [NSString stringWithFormat:@"注册立即奖励%@个积分，可以兑换脸值（钱呀钱），签到还有更多惊喜噢~",self.point];
    
    SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];
    
    // 是否是文档
    req1.bText =  NO;
    
    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,        /**< 收藏     */
    if ([type isEqualToString:@"0"]) {
        req1.scene = WXSceneSession;
    }else{
        req1.scene = WXSceneTimeline;
    }
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = kLinkTitle;//分享标题
    urlMessage.description = kLinkDescription;//分享描述
    [urlMessage setThumbImage:Image(@"FWQrcode")];//分享图片,使用SDK的setThumbImage方法压缩图片大小
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkUrl;//分享链接
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    req1.message = urlMessage;
    //发送分享信息
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXApi sendReq:req1];
    });
}

#pragma mark - Public Methods


#pragma mark - Private Methods
-(void)startLoadingAnimation{
    self.webviewProgressLine.hidden = NO;
    self.webviewProgressLine.width = 0.0;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.webviewProgressLine.width = Screen_W * 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.webviewProgressLine.width = Screen_W * 0.8;
        }];
    }];
}

-(void)endLoadingAnimation{
    [UIView animateWithDuration:0.2 animations:^{
        self.webviewProgressLine.width = Screen_W;
    } completion:^(BOOL finished) {
        self.webviewProgressLine.hidden = YES;
    }];
}

#pragma mark - Setters


#pragma mark - Getters


@end
