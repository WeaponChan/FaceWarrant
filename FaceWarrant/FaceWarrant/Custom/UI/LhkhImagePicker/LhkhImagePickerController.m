//
//  LhkhImagePickerController.m
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/3/13.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhImagePickerController.h"
#import "LhkhCropImageController.h"
#import "CropImageViewController.h"
#import "UIImage+FixOrientation.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@interface LhkhImagePickerController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
@end

@implementation LhkhImagePickerController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.seleType isEqualToString:@"1"]) {
        [self isOpenPhoto];
    }else if ([self.seleType isEqualToString:@"2"]){
        [self isOpenCamera];
    }else{
        [self addAction];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        float fileMB = (float)([representation size]/1024/1024);
        DLog(@"size of asset in bytes: %0.2f", fileMB);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fileMB >= 20) {
                [MBProgressHUD showTips:@"您选择的图片超过了20M,请重新选择"];
            }else{
                NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1);
                UIImage *originalImage = [UIImage imageWithData:imageData];
                
                if ([self.seleType isEqualToString:@"1"]) {
                    [picker dismissViewControllerAnimated:NO completion:nil];
                    UIImage *image = [UIImage fixOrientation:originalImage];
                    [self cropImageWithImage:image type:@"photo"];
                }else if ([self.seleType isEqualToString:@"2"]){
                    [picker dismissViewControllerAnimated:NO completion:nil];
                    UIImage *image = [UIImage fixOrientation:originalImage];
                    [self cropImageWithImage:image type:@"camera"];
                } else{
                    CGFloat height = originalImage.size.height * (Screen_W/originalImage.size.width);
                    UIImage * orImage = [originalImage resizeImageWithSize:CGSizeMake(Screen_W, height)];
                    [picker dismissViewControllerAnimated:NO completion:^{
                        LhkhCropImageController *cropVC = [[LhkhCropImageController alloc] initWithImage:orImage];
                        if ([self.type isEqualToString:@"head"]) {
                            cropVC.ovalClip = YES;
                        }else{
                            cropVC.ovalClip = NO;
                        }
                        LhkhWeakSelf(cropVC);
                        cropVC.selectBlock = ^(UIImage *image) {
                            if (self.imagePickerBlock) {
                                self.imagePickerBlock(image);
                            }
                            [weakcropVC dismissViewControllerAnimated:NO completion:nil];
                            [self dismissViewControllerAnimated:NO completion:nil];
                            [self.navigationController popViewControllerAnimated:NO];
                        };
                        cropVC.cancleBlock = ^{
                            [weakcropVC dismissViewControllerAnimated:NO completion:nil];
                            [self dismissViewControllerAnimated:NO completion:nil];
                            [self.navigationController popViewControllerAnimated:NO];
                        };
                        [self presentViewController:cropVC animated:NO completion:nil];
                    }];
                }
            }
        });
    } failureBlock:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
    });
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)addAction{
    NSString *title = @"";
    if ([self.type isEqualToString:@"head"]) {
        title = @"更换头像";
    }else if ([self.type isEqualToString:@"bg"]){
        title = @"更换背景";
    }else{
        title = @"";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    
    actionSheet.tag = 555;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 555) {
        
        switch (buttonIndex) {
            case 0:
            {
                //拍照
                [self isOpenCamera];
            }
                break;
            case 1:
            {
                //选取本地图片
                [self isOpenPhoto];
            }
                break;
            default:
            {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
                break;
        }
    }
}

/** 拍照 */
- (void)takePhoto{
    //校验相机权限
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        if ([self.type isEqualToString:@"head"]) {
            [self setCameraDevice:picker];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:picker animated:NO completion:nil];
        });
    }else{
        [MBProgressHUD showTips:@"请到设置打开相机权限"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

/** 选取本地图片 */
- (void)localPhoto{
    //校验照片权限
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,nil];
        [self presentViewController:picker animated:NO completion:nil];
        
    }else{
        [MBProgressHUD showTips:@"请到设置打开相册权限"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


//裁剪
- (void)cropImageWithImage:(UIImage*)image type:(NSString *)type
{
    CropImageViewController *cropImg = [[CropImageViewController alloc] initWithCropImage:image type:type];
    [self presentViewController:cropImg animated:NO completion:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

/**
 *  设置闪光灯模式
 *  UIImagePickerControllerCameraFlashModeAuto 自动
 *  UIImagePickerControllerCameraFlashModeOn 打开
 *  UIImagePickerControllerCameraFlashModeOff 关闭
 *
 *  @param imagePicker 类型为相机的UIImagePickerController
 */
- (void)setCameraFlashMode:(UIImagePickerController *)imagePicker {
    if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    } else if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    } else if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
}

/**
 *  设置摄像头模式
 *  UIImagePickerControllerCameraDeviceRear 后置摄像头
 *  UIImagePickerControllerCameraDeviceFront 前置摄像头
 *
 *  @param imagePicker 类型为相机的UIImagePickerController
 */
- (void)setCameraDevice:(UIImagePickerController *)imagePicker {
    //前后置摄像头
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


- (void)isOpenPhoto
{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        [self localPhoto]; //获取本地照片
    } else {
        if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { //弹出访问权限提示框
                if (status == PHAuthorizationStatusAuthorized) {
                    [self localPhoto];
                } else {
                    [self setUpAlertViewWithMessage:@"相册已被禁止访问，为了您更好的体验，是否去重新设置？"];
                }
            }];
        } else {
            [self setUpAlertViewWithMessage:@"相册已被禁止访问，为了您更好的体验，是否去重新设置？"];
        }
    }
    
}

- (void)isOpenCamera
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                // 授权成功
                DLog(@"允许");
                //拍照
                [self takePhoto];
            }else{
                // 授权失败
                DLog(@"拒绝");
                [self setUpAlertViewWithMessage:@"相机已被禁止使用，为了您更好的体验，是否去重新设置？"];
            }
        }];
    }else{
        if (videoAuthStatus != AVAuthorizationStatusAuthorized) {
            [self setUpAlertViewWithMessage:@"相机已被禁止使用，为了您更好的体验，是否去重新设置？"];
        }else{
            //拍照
            [self takePhoto];
        }
    }
}


- (void)setUpAlertViewWithMessage:(NSString *)Message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:Message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - Setters


#pragma mark - Getters




@end
