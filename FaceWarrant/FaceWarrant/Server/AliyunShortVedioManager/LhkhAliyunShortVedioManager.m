//
//  LhkhAliyunShortVedioManager.m
//  FaceWarrant
//
//  Created by Weapon on 2018/11/30.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "LhkhAliyunShortVedioManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AliyunVideoSDK/AliyunVideoSDK.h>

#import "FWWarrantInfoVC.h"

static LhkhAliyunShortVedioManager *manager = nil;
@implementation LhkhAliyunShortVedioManager
{
    AliyunVideoRecordParam *_quVideo;
    AliyunVideoCropParam *_cropParam;
    UIViewController *_superVC;
    NSString *_videoImgPath;
    UIImage *_videoImg;
}

- (id)init
{
    if (self=[super init]) {
        [self setupSDKBaseUI];
        [self setupSDKBaseRecordParam];
    }
    return self;
}

+ (id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    });
    return manager;
}



- (void)setupSDKBaseUI {
    AliyunVideoUIConfig *config = [[AliyunVideoUIConfig alloc] init];
    
    config.backgroundColor = RGB_COLOR(35, 42, 66);
    config.timelineBackgroundCollor = RGB_COLOR(35, 42, 66);
    config.timelineDeleteColor = [UIColor redColor];
    config.timelineTintColor = RGB_COLOR(239, 75, 129);
    config.durationLabelTextColor = [UIColor redColor];
    config.cutTopLineColor = [UIColor redColor];
    config.cutBottomLineColor = [UIColor redColor];
    config.noneFilterText = @"无滤镜";
    config.hiddenDurationLabel = NO;
    config.hiddenFlashButton = NO;
    config.hiddenBeautyButton = NO;
    config.hiddenCameraButton = NO;
    config.hiddenImportButton = NO;
    config.hiddenDeleteButton = NO;
    config.hiddenFinishButton = NO;
    config.recordOnePart = NO;
    config.filterArray = @[@"炽黄",@"粉桃",@"海蓝",@"红润",@"灰白",@"经典",@"麦茶",@"浓烈",@"柔柔",@"闪耀",@"鲜果",@"雪梨",@"阳光",@"优雅",@"朝阳",@"波普",@"光圈",@"海盐",@"黑白",@"胶片",@"焦黄",@"蓝调",@"迷糊",@"思念",@"素描",@"鱼眼",@"马赛克",@"模糊"];
    config.imageBundleName = @"QPSDK";
    config.filterBundleName = @"FilterResource";
    config.recordType = AliyunVideoRecordTypeCombination;
    config.showCameraButton = YES;
    
    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
}

- (void)setupSDKBaseRecordParam
{
    _quVideo = [[AliyunVideoRecordParam alloc] init];
    _quVideo.ratio = AliyunVideoVideoRatio3To4;
    _quVideo.size = AliyunVideoVideoSize540P;
    _quVideo.minDuration = 2;
    NSString *videoTime = [USER_DEFAULTS objectForKey:UD_VideoTimeLimit];
    _quVideo.maxDuration = videoTime.intValue;
    _quVideo.position = AliyunCameraPositionBack;
    _quVideo.beautifyStatus = YES;
    _quVideo.beautifyValue = 100;
    _quVideo.torchMode = AliyunCameraTorchModeOff;
    _quVideo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
}

- (void)aliyunShortVedio:(UIViewController*)superVC
{
    _superVC = superVC;
    [self checkCamera];
}

//判断相机权限
- (void)checkCamera
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                // 授权成功
                DLog(@"允许");
                [self checkMic];
            }else{
                // 授权失败
                DLog(@"拒绝");
                [UIAlertController js_alertAviewWithTarget:self->_superVC andAlertTitle:@"提示" andMessage:@"相机已被禁止使用，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
            }
        }];
    }else{
        if (videoAuthStatus != AVAuthorizationStatusAuthorized) {
            [UIAlertController js_alertAviewWithTarget:self->_superVC andAlertTitle:@"提示" andMessage:@"相机已被禁止使用，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
        }else{
            [self checkMic];
        }
    }
}


//监测麦克风权限
- (void)checkMic
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                // 授权成功
                DLog(@"允许");
                [self setRecordViewController];
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }else{
                // 授权失败
                DLog(@"拒绝");
                [UIAlertController js_alertAviewWithTarget:self->_superVC andAlertTitle:@"提示" andMessage:@"麦克风已被禁止使用，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
            }
        }];
    }else{
        if (status != AVAuthorizationStatusAuthorized) {
            [UIAlertController js_alertAviewWithTarget:self->_superVC andAlertTitle:@"提示" andMessage:@"麦克风已被禁止使用，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
        }else{
            [self setRecordViewController];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }
}

//创建录制控制器
- (void)setRecordViewController
{
    UIViewController *recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:self->_quVideo];
    [AliyunVideoBase shared].delegate = (id)self;
    [self->_superVC.navigationController pushViewController:recordViewController animated:YES];
}

#pragma mark - AliyunVideoBaseDelegate
-(void)videoBaseRecordVideoExit
{
    DLog(@"退出录制");
    [self->_superVC.navigationController popToRootViewControllerAnimated:YES];
}

- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath
{
    DLog(@"录制完成  %@", videoPath);
    //判断一下相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        // 无权限
        [UIAlertController js_alertAviewWithTarget:recordVC andAlertTitle:@"提示" andMessage:@"相册已被禁止访问，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        self->_videoImgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_image.png"];
                                        self->_videoImg = [self getVideoPreViewImage:assetURL];
                                        BOOL result = [UIImagePNGRepresentation(self->_videoImg) writeToFile:self->_videoImgPath atomically:YES];// 保存成功会返回YES
                                        if (result) {
//                                            UIViewController *cropVC = [[AliyunVideoBase shared] createPhotoViewControllerCropParam:[self videoBaseRecordViewShowLibrary:recordVC]];
//                                            [recordVC.navigationController pushViewController:cropVC animated:NO];
                                            FWWarrantInfoVC *vc = [FWWarrantInfoVC new];
                                            vc.image = self->_videoImg;
                                            vc.imagePath = self->_videoImgPath;
                                            vc.videoPath = videoPath;
                                            vc.type = @"1";
                                            [self->_superVC.navigationController pushViewController:vc animated:YES];
                                        }
                                    });
                                }];
    
}

- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC
{
    DLog(@"录制页跳转Library");
    //判断一下相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        // 无权限
        [UIAlertController js_alertAviewWithTarget:recordVC andAlertTitle:@"提示" andMessage:@"相册已被禁止访问，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
    }
    
    // 可以更新相册页配置
    AliyunVideoCropParam *mediaInfo = [[AliyunVideoCropParam alloc] init];
    mediaInfo.minDuration = 2.0;
//    NSString *videoTime = [USER_DEFAULTS objectForKey:UD_VideoTimeLimit];
//    mediaInfo.maxDuration = videoTime.intValue;
    mediaInfo.fps = 25;
    mediaInfo.gop = 5;
    mediaInfo.videoQuality = 1;
    mediaInfo.size = AliyunVideoVideoSize540P;
    mediaInfo.ratio = AliyunVideoVideoRatio3To4;
    mediaInfo.cutMode = AliyunVideoCutModeScaleAspectFill;
    mediaInfo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
    return mediaInfo;
}

// 裁剪
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath
{
    unsigned long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:videoPath error:nil].fileSize;
    NSString *videoTime = [USER_DEFAULTS objectForKey:UD_VideoTimeLimit];
    DLog(@"裁剪完成=%@,filesize=%llu", videoPath,fileSize);
    float aSize = fileSize/1024/1024;
    if (aSize>20.f) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD showTips:[NSString stringWithFormat:@"视频文件太大(请选择不超过%@秒的视频)",videoTime]];
            [cropVC.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        self->_videoImgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_image.png"];
                                        self->_videoImg = [self getVideoPreViewImage:assetURL];
                                        BOOL result = [UIImagePNGRepresentation(self->_videoImg) writeToFile:self->_videoImgPath atomically:YES];// 保存成功会返回YES
                                        if (result) {
                                            FWWarrantInfoVC *vc = [FWWarrantInfoVC new];
                                            vc.image = self->_videoImg;
                                            vc.imagePath = self->_videoImgPath;
                                            vc.videoPath = videoPath;
                                            vc.type = @"1";
                                            [self->_superVC.navigationController pushViewController:vc animated:YES];
                                        }
                                    });
                                }];
    
}


//如果用户选择的是图片
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC image:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showTips:@"请选择视频文件"];
        [cropVC.navigationController popViewControllerAnimated:YES];
    });
}

- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC
{
    DLog(@"从相册跳转回录制页");
    return nil;
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC
{
    DLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
}

//取到录制的视频的第一帧图片
- (UIImage*) getVideoPreViewImage:(NSURL*)pathUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:pathUrl options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 30);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
@end



