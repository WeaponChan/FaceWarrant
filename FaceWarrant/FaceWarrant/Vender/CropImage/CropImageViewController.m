//
//  CropImageViewController.m
//  WHCropImage
//
//  Created by 魏辉 on 16/9/5.
//  Copyright © 2016年 Weihui. All rights reserved.
//

#import "CropImageViewController.h"
#import "TKImageView.h"

@interface CropImageViewController ()
@property (nonatomic,strong)TKImageView *tkImageView;
@property (nonatomic,strong)UIImage *cropImg;
@property (nonatomic,strong)NSString *type;
@end

@implementation CropImageViewController

- (instancetype)initWithCropImage:(UIImage *)cropImage type:(NSString*)type{
    
    if (self = [super init]) {
        self.cropImg = cropImage;
        self.type = type;
        [self viewConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    _tkImageView.cropAspectRatio = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewConfig{
    
    self.tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(0, NavigationBar_H, Screen_W, Screen_H*0.8)];
    [self.view addSubview:_tkImageView];
    
    _tkImageView.toCropImage = self.cropImg;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = YES;
    _tkImageView.cropAreaCornerWidth = 3;
    _tkImageView.cropAreaCornerHeight = 3;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor lightGrayColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor grayColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 6;
    _tkImageView.cropAreaMidLineWidth = 30;
    _tkImageView.cropAreaMidLineHeight = 8;
    _tkImageView.cropAreaMidLineColor = [UIColor grayColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 1;
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset (20);
        make.width.offset (50);
        make.left.equalTo(self.view).offset(50);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset (20);
        make.width.offset (50);
        make.right.equalTo(self.view).offset(-50);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}



#pragma mark buttonAction
- (void)cancleBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.type isEqualToString:@"photo"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_CropPhotoImageSure object: [self->_tkImageView currentCroppedImage]];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_CropCameraImageSure object: [self->_tkImageView currentCroppedImage]];
        }
    }];
    
}



@end
