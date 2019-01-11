//
//  FWVideoVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWVideoVC.h"
//#import <AliyunVideoSDK/AliyunVideoSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OSSUploadFileManager.h"
#import "FWWarrantInfoVC.h"
@interface FWVideoVC ()
//@property (strong, nonatomic) AliyunVideoRecordParam *quVideo;
//@property (strong, nonatomic) AliyunVideoCropParam *cropParam;
@end

@implementation FWVideoVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
//    [self setupSDKBaseUI];
//    [self setupSDKBaseRecordParam];
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate
#pragma mark - AliyunVideoBaseDelegate
/*
-(void)videoBaseRecordVideoExit {
    DLog(@"退出录制");

    UIViewController *vc = self.navigationController.Lhkh_childViewControllers[0];
    [self.navigationController popToViewController:vc animated:NO];
}

- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
    DLog(@"录制完成  %@", videoPath);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {

                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIViewController *cropVC = [[AliyunVideoBase shared] createPhotoViewControllerCropParam:[self videoBaseRecordViewShowLibrary:recordVC]];
                                        [self.navigationController pushViewController:cropVC animated:NO];
                                    });
                                }];
    
}

- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {
    
    DLog(@"录制页跳转Library");
    // 可以更新相册页配置
    AliyunVideoCropParam *mediaInfo = [[AliyunVideoCropParam alloc] init];
    mediaInfo.minDuration = 2.0;
    mediaInfo.maxDuration = 10.0*60;
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
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {
    
    DLog(@"裁剪完成  %@", videoPath);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        [cropVC.navigationController popViewControllerAnimated:YES];
//                                        [[OSSUploadFileManager sharedOSSManager] asyncOSSUploadVideo:videoPath complete:^(NSString *videoUrl, UploadImageState state) {
//                                            DLog(@"----->%@",videoUrl);
//
//                                        }];
                                       [self videoPath:videoPath image:[self getVideoPreViewImage:assetURL]];
                                    });
                                }];
   
}

- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {
    
    DLog(@"跳转录制页");
    return nil;
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    
    DLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
    
}*/

#pragma mark - Event Response

- (void)videoPath:(NSString*)path image:(UIImage *)image
{
//    FWWarrantInfoVC *vc = [FWWarrantInfoVC new];
//    vc.image = image;
//    vc.videoPath = path;
//    vc.type = @"1";
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
/*
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
    _quVideo.position = AliyunCameraPositionFront;
    _quVideo.beautifyStatus = YES;
    _quVideo.beautifyValue = 100;
    _quVideo.torchMode = AliyunCameraTorchModeOff;
    _quVideo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
    
    UIViewController *recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:_quVideo];
    [AliyunVideoBase shared].delegate = (id)self;
//    [self addChildViewController:recordViewController];
//    [self.view addSubview:recordViewController.view];
    [self.navigationController pushViewController:recordViewController animated:YES];
    
}*/



//- (UIImage*) getVideoPreViewImage:(NSURL*)pathUrl
//{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:pathUrl options:nil];
//    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    
//    assetGen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 30);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
//    CGImageRelease(image);
//    return videoImage;
//}


#pragma mark - Setters


#pragma mark - Getters


@end
