//
//  FWWarrantItemVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantItemVC.h"
#import "FWPhotoVC.h"
#import "FWCameraVC.h"
//#import <AliyunVideoSDK/AliyunVideoSDK.h>
//#import <AssetsLibrary/AssetsLibrary.h>
@interface FWWarrantItemVC ()
//@property (strong, nonatomic) AliyunVideoRecordParam *quVideo;
//@property (strong, nonatomic) AliyunVideoCropParam *cropParam;
@end

@implementation FWWarrantItemVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self setupSDKBaseUI];
//    [self setupSDKBaseRecordParam];
//    self.view.superview.backgroundColor = [UIColor clearColor];
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate

-(void)videoBaseRecordVideoExit {
    DLog(@"退出录制");

//    UIViewController *vc = self.navigationController.Lhkh_childViewControllers[0];
//    [self.navigationController popToViewController:vc animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Event Response

- (IBAction)itemClick:(UIButton *)sender {
    if (sender.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender.tag == 1){
        FWPhotoVC *vc = [[FWPhotoVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if(sender.tag == 2){
        FWCameraVC *vc = [[FWCameraVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if(sender.tag == 3){
//        UIViewController *recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:_quVideo];
//        [AliyunVideoBase shared].delegate = (id)self;
//        LhkhNavigationController *recordNav = [[LhkhNavigationController alloc] initWithRootViewController:recordViewController];
//        [self presentViewController:recordNav animated:YES completion:nil];
        
//        if ([self.delegate respondsToSelector:@selector(FWWarrantItemVCDelegateClickWithTag:)]) {
//            [self.delegate FWWarrantItemVCDelegateClickWithTag:sender.tag];
//        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods

//- (void)setupSDKBaseUI {
//    AliyunVideoUIConfig *config = [[AliyunVideoUIConfig alloc] init];
//
//    config.backgroundColor = RGB_COLOR(35, 42, 66);
//    config.timelineBackgroundCollor = RGB_COLOR(35, 42, 66);
//    config.timelineDeleteColor = [UIColor redColor];
//    config.timelineTintColor = RGB_COLOR(239, 75, 129);
//    config.durationLabelTextColor = [UIColor redColor];
//    config.cutTopLineColor = [UIColor redColor];
//    config.cutBottomLineColor = [UIColor redColor];
//    config.noneFilterText = @"无滤镜";
//    config.hiddenDurationLabel = NO;
//    config.hiddenFlashButton = NO;
//    config.hiddenBeautyButton = NO;
//    config.hiddenCameraButton = NO;
//    config.hiddenImportButton = NO;
//    config.hiddenDeleteButton = NO;
//    config.hiddenFinishButton = NO;
//    config.recordOnePart = NO;
//    config.filterArray = @[@"炽黄",@"粉桃",@"海蓝",@"红润",@"灰白",@"经典",@"麦茶",@"浓烈",@"柔柔",@"闪耀",@"鲜果",@"雪梨",@"阳光",@"优雅",@"朝阳",@"波普",@"光圈",@"海盐",@"黑白",@"胶片",@"焦黄",@"蓝调",@"迷糊",@"思念",@"素描",@"鱼眼",@"马赛克",@"模糊"];
//    config.imageBundleName = @"QPSDK";
//    config.filterBundleName = @"FilterResource";
//    config.recordType = AliyunVideoRecordTypeCombination;
//    config.showCameraButton = YES;
//
//    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
//}
//
//- (void)setupSDKBaseRecordParam
//{
//    _quVideo = [[AliyunVideoRecordParam alloc] init];
//    _quVideo.ratio = AliyunVideoVideoRatio3To4;
//    _quVideo.size = AliyunVideoVideoSize540P;
//    _quVideo.minDuration = 2;
//    NSString *videoTime = [USER_DEFAULTS objectForKey:UD_VideoTimeLimit];
//    _quVideo.maxDuration = videoTime.intValue;
//    _quVideo.position = AliyunCameraPositionFront;
//    _quVideo.beautifyStatus = YES;
//    _quVideo.beautifyValue = 100;
//    _quVideo.torchMode = AliyunCameraTorchModeOff;
//    _quVideo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
//}

#pragma mark - Setters


#pragma mark - Getters


@end
