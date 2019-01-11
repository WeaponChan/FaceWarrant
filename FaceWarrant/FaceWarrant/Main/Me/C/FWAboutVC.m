//
//  FWAboutVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAboutVC.h"
@interface FWAboutVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIView *webviewProgressLine;
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation FWAboutVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"关于脸碑";
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
    
    NSString *url = APIURLStringConnect(@"/v1/base/aboutUs");
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSString *htmlCode = [NSString stringWithFormat:@"<html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"><style type=\"text/css\">body{font-size : 0.9em;}img{width:%@ !important;}</style></head><body>%@</body></html>",@"100%",dic[@"pinfo"][@"detail"]];
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
                                                     //                                                     "myimg.height = myimg.height * (maxwidth/oldwidth);"
                                                     "myimg.height = myimg.height * (myimg.width/myimg.height);"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",Screen_W]
     ];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}


#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests



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
