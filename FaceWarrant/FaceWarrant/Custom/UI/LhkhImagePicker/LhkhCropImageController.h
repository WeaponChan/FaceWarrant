//
//  LhkhCropImageController.h
//  FaceWarrant
//
//  Created by Weapon on 2018/12/27.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LhkhCropImageController : UIViewController
@property (nonatomic, copy)void(^selectBlock)(UIImage *image);
@property (nonatomic, copy)void(^cancleBlock)(void);
//圆形裁剪，默认NO;
@property (nonatomic, assign) BOOL ovalClip;
- (instancetype)initWithImage:(UIImage *)originalImage;
@end
