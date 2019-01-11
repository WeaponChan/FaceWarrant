//
//  FWShareView.m
//  FaceWarrant
//
//  Created by FW on 2018/9/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWShareView.h"
#import "FWWarrantDetailModel.h"
#import "WXApi.h"
@interface FWShareView()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) FWWarrantDetailModel *model;
@end

@implementation FWShareView

#pragma mark - Life Cycle

+ (instancetype)shareView
{
    return [[NSBundle mainBundle] loadNibNamed:@"FWShareView" owner:self options:nil].firstObject;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.view1.layer.cornerRadius = 5.f;
    self.view1.layer.masksToBounds = YES;
    self.view2.layer.cornerRadius = 5.f;
    self.view2.layer.masksToBounds = YES;
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)cellClick:(UIButton *)sender {
    if (sender.tag == 0) {
        DLog(@"微信好友");
        [self shareWithtype:@"0"];
    }else if(sender.tag == 1){
        DLog(@"朋友圈");
        [self shareWithtype:@"1"];
    }else{
        DLog(@"取消");
        if (self.cancelblock) {
            self.cancelblock();
        }
    }
}

#pragma mark - Network Requests

- (void)shareWithtype:(NSString *)type
{
    NSString *kLinkUrl = [NSString stringWithFormat:@"%@/%@/v1/base/share?userId=%@&releaseGoodsId=%@&isNew=0",FWBaseUrl,FWBaseMethod,[USER_DEFAULTS objectForKey:UD_UserID],self.model.releaseGoodsId];
    NSString *kLinkTitle = self.model.goodsName;
    NSString *kLinkDescription = self.model.brandSynopsis;
    
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
    NSData *imageData = [NSData dataWithContentsOfURL:URL(self.model.modelUrl)];
    UIImage *thumd = [self originImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(100, 100)] ;
    [urlMessage setThumbImage:thumd];//分享图片,使用SDK的setThumbImage方法压缩图片大小
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkUrl;//分享链接
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    req1.message = urlMessage;
    //发送分享信息
    [WXApi sendReq:req1];
}



#pragma mark - Public Methods
- (void)configViewWithModel:(FWWarrantDetailModel*)model
{
    self.model = model;
}

#pragma mark - Private Methods
-(UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - Setters


#pragma mark - Getters



@end
