//
//  LhkhImagePickerController.h
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/3/13.
//  Copyright © 2017年 LHKH. All rights reserved.
//

typedef void(^ImagePickerBlock)(UIImage *image);

#import <UIKit/UIKit.h>

@interface LhkhImagePickerController : UIViewController
@property (nonatomic, copy) ImagePickerBlock imagePickerBlock;
@property (nonatomic, copy) NSString *seleType;//用来判断碑它那边选择的什么  图片 或者 拍照
@property (nonatomic, copy) NSString *type;//用来区分是头像 还是 背景
@end
