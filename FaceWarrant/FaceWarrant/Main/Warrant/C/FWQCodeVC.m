//
//  FWQCodeVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWQCodeVC.h"
#import "FWOrderModel.h"
#import "FWWarrantManager.h"
@interface FWQCodeVC ()
@property (weak, nonatomic) IBOutlet UIView *qcodeView;
@property (weak, nonatomic) IBOutlet UIImageView *oneQRImageView;
@property (weak, nonatomic) IBOutlet UIView *oneQRImageBgView;
@property (weak, nonatomic) IBOutlet UIView *twoQRImageBgView;
@property (weak, nonatomic) IBOutlet UILabel *oneQRTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *twoQRImageView1;
@property (weak, nonatomic) IBOutlet UILabel *twoQRTitleLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *twoQRImageView2;
@property (weak, nonatomic) IBOutlet UILabel *twoQRTitle2;

@end

@implementation FWQCodeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _oneQRImageView.clipsToBounds = YES;
    _twoQRImageView1.clipsToBounds = YES;
    _twoQRImageView2.clipsToBounds = YES;
    
    [self setOneQRImage:_oneQRImage];
    
    if (_oneQRImage) {
        if (self.model.buyUrl) {
            [self createQRImage:self.model.buyUrl toImageView:_oneQRImageView];
            _oneQRTitleLbl.text = @"网上商城";
        } else {
            [self createQRImage:self.model.microMallCode toImageView:_oneQRImageView];
            _oneQRTitleLbl.text = @"微商城";
        }
    } else {
        [self createQRImage:self.model.buyUrl toImageView:_twoQRImageView1];
        [self createQRImage:self.model.microMallCode toImageView:_twoQRImageView2];
    }
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {// 事件开始时执行，其他状态不执行
        UIImageView *imageView = (UIImageView *)sender.view;
        
        if (_oneQRImage) {
            if (self.model.buyUrl) {// 网商城二维码
                // 外链至购买url
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.buyUrl]];
                // 更新商品购买次数
                [self updateClick:self.model.orderId];
            } else {// 微商城二维码
                // 外链至购买url
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.microMallCode]];
                // 更新商品购买次数
                [self updateClick:self.model.microMallOrderId];
            }
        } else {
            if (imageView == _twoQRImageView1) {// 网商城二维码
                // 外链至购买url
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.buyUrl]];
                // 更新商品购买次数
                [self updateClick:self.model.orderId];
            } else if (imageView == _twoQRImageView2) {// 微商城二维码
                // 外链至购买url
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.microMallCode]];
                // 更新商品购买次数
                [self updateClick:self.model.microMallOrderId];
            }
        }
    }
}

#pragma mark - Network Requests

- (void)updateClick:(NSString*)orderId
{
    NSDictionary *param = @{@"orderId":orderId};
    [FWWarrantManager buywarrantgoodsUpdateClickNoWithParameters:param result:^(id response) {
        if (response[@"code"] && [response[@"code"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"message"]];
        }else{
            [MBProgressHUD showTips:response[@"message"]];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)initWithUI
{
    self.qcodeView.layer.cornerRadius = 5.f;
    self.qcodeView.layer.masksToBounds = YES;
    // 设置手势事件
    self.oneQRImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.oneQRImageView addGestureRecognizer:longPress];
    
    self.twoQRImageView1.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.twoQRImageView1 addGestureRecognizer:longPress1];
    
    self.twoQRImageView2.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.twoQRImageView2 addGestureRecognizer:longPress2];
}


- (void)createQRImage:(NSString *)url toImageView:(UIImageView *)imageView
{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = url;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - Setters
- (void)setOneQRImage:(BOOL)oneQRImage
{
    _oneQRImage = oneQRImage;
    
    if (oneQRImage) {
        _oneQRImageBgView.hidden = NO;
        _twoQRImageBgView.hidden = YES;
    } else {
        _oneQRImageBgView.hidden = YES;
        _twoQRImageBgView.hidden = NO;
    }
}

#pragma mark - Getters


@end
