//
//  FWPhotoVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWPhotoVC.h"
#import "CropImageViewController.h"
#import "FWWarrantInfoVC.h"
#import "UIImage+FixOrientation.h"
@interface FWPhotoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
//@property (strong, nonatomic)UIImagePickerController *imagePickerVC;
@end

@implementation FWPhotoVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (void)dealloc
{
    DLog(@"delloc");
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [UIImage fixOrientation:originalImage];
    CropImageViewController *cropImg = [[CropImageViewController alloc] initWithCropImage:image type:@"photo"];
    [self presentViewController:cropImg animated:NO completion:^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSure:) name: Notif_CropPhotoImageSure object: nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response

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


#pragma mark - Setters
//- (UIImagePickerController*)imagePickerVC
//{
//    if (_imagePickerVC == nil) {
//        _imagePickerVC = [[UIImagePickerController alloc] init];
//        _imagePickerVC.delegate = self;
//        _imagePickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        _imagePickerVC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    }
//    return _imagePickerVC;
//}

#pragma mark - Getters


@end
