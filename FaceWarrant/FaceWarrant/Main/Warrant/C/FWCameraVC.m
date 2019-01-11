//
//  FWCameraVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCameraVC.h"
#import "FWAddWarrantBottomView.h"
#import "CropImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FWWarrantInfoVC.h"
#import "UIImage+FixOrientation.h"
@interface FWCameraVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    BOOL isChange;
    BOOL isOn;
}
@property (weak,nonatomic) FWAddWarrantBottomView *addWarrantBottomView;
@end

@implementation FWCameraVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    [self setAddWarrantView];
//    [self takePhoto];
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [UIImage fixOrientation:originalImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_ChangeBtnTitleAndImg object:nil];
    isChange = YES;
    CropImageViewController *cropImg = [[CropImageViewController alloc] initWithCropImage:image type:@"camera"];
    [self presentViewController:cropImg animated:NO completion:^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSure:) name: Notif_CropCameraImageSure object: nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Custom Delegate


#pragma mark - Event Response

/**
 *  取消拍照
 */
- (void)cancelCameraTakePicture
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  切换前后置摄像头、完成拍照
 */
- (void)completeCameraTakePicture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notificationSure: (NSNotification *)notification
{
    FWWarrantInfoVC *vc = [FWWarrantInfoVC new];
    vc.image = notification.object;
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)takePhoto{
    
    //校验相机权限
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.sourceType = sourceType;
        self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }else{
        [MBProgressHUD showTips:@"请到设置打开相册权限"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setAddWarrantView
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.delegate = self;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //隐藏系统相机操作
        self.showsCameraControls = NO;
        //设定相机全屏
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 1.0f/1.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        self.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, scale, scale);
//        self.cameraOverlayView = [self addWarrantBottomViewImagePicker:self];
    }else {
        NSLog(@"照相机不可用");
    }
}

- (UIView *)addWarrantBottomViewImagePicker:(UIImagePickerController *)imagePicker {
    
    _addWarrantBottomView = [[[UINib nibWithNibName:@"FWAddWarrantBottomView" bundle:nil]instantiateWithOwner:nil options:nil]objectAtIndex:0];
    _addWarrantBottomView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    _addWarrantBottomView.tagBlock = ^(NSInteger tag) {
        if (tag == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (tag == 1){
            if (self->isChange == YES) {
                [self completeCameraTakePicture];
            }else{
                [self changeCameraDevice];
            }
        }else if (tag == 2){
            [self takePicture];
        }else if (tag == 6){
            self->isOn = !self->isOn;
            [self changeCameraFlashMode];
        }
    };
    return _addWarrantBottomView;
}


- (void)changeCameraFlashMode
{

    Class captureDeviceClass =NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (isOn == YES) {
                [device setTorchMode:AVCaptureTorchModeOn];//手电筒开
            }else{
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
           [device unlockForConfiguration];
        }
    }
}

- (void)changeCameraDevice
{
    //前后置摄像头
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


#pragma mark - Setters


#pragma mark - Getters


@end
